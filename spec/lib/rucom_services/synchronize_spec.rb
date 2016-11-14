# Frozen-string-literal: false

require 'spec_helper'

describe RucomServices::Synchronize do
  subject(:sinc) { RucomServices::Synchronize.new }

  before do
    @data = { rol_name: 'Barequero', id_type: 'CEDULA', id_number: '15535725' }
    @sync = RucomServices::Synchronize.new(@data)
  end

  context '#call' do
    it 'executes sucessfully' do
      VCR.use_cassette('successful_authorized_provider_rucom_response') do
        @sync.call

        # sets data attribute with the data sended
        expect(@sync.data).to eq(@data)

        # has a scraper instance setting up @scraper attribute
        expect(@sync.scraper.class).to eq(RucomServices::Scraper)

        # returns the setting object as a scraper attribute
        expect(@sync.scraper.setting.present?).to eq(true)
        expect(@sync.scraper.setting.class).to eq(RucomServices::Setting)

        # returns the state of response of the setting object success as true
        expect(@sync.scraper.setting.success).to eq(true)

        # sets response success key as true
        expect(@sync.response[:success]).to eq(true)

        # returns its own instance
        expect(@sync.class).to eq(RucomServices::Synchronize)

        # returns the respective user
        expect(@sync.user.present?).to eq(true)
        expect(@sync.user.class).to eq(User)

        # returns the respective user rucom
        expect(@sync.rucom.present?).to eq(true)
        expect(@sync.rucom.class).to eq(Rucom)

        # returns the respective user profile
        expect(@sync.user_profile.present?).to eq(true)
        expect(@sync.user_profile.class).to eq(Profile)
      end
    end

    it 'executes unsucessfully' do
      VCR.use_cassette('unsuccessful_authorized_provider_rucom_response') do
        @data[:id_number] = '1234567'
        @sync = RucomServices::Synchronize.new(@data).call

        # it 'sets response success key as false'
        expect(@sync.response[:success]).to eq(false)

        # it 'sets response errors key with the exception'
        expect(@sync.response[:errors].count).to be > 0

        # it 'returns its own instance'
        expect(@sync.class).to eq(RucomServices::Synchronize)
      end
    end
  end

  context '#first_or_create_user_from_rucom' do
    before do
      @data = { rol_name: 'barequero', id_type: 'CEDULA', id_number: '15535725' }
      @sync = RucomServices::Synchronize.new(@data)
    end

    context 'When the user profile exist' do
      context 'When the user registration state is not completed' do
        context 'when rucom exist in the local database' do
          it 'returns the respective rucom row' do
            VCR.use_cassette('successful_authorized_provider_rucom_response') do
              @user = create :user, :with_profile, :with_personal_rucom
              @data[:id_number] = @user.profile.document_number
              rucom = @user.rucom
              @sync = RucomServices::Synchronize.new(@data).call
              expect(@sync.rucom).to eq(rucom)
            end
          end
        end

        it 'creates rucom from scraper service' do
          VCR.use_cassette('successful_authorized_provider_rucom_response') do
            clean_user_profile_rucom_data(@data[:id_number])
            @sync.call
            @rucom = Rucom.find_by(name: 'AMADO  MARULANDA')
            # returns the virtus model to the class response
            expect(@sync.scraper.virtus_model.present?).to eq(true)
            expect(@sync.scraper.virtus_model.class.name).to eq("RucomServices::Models::#{@sync.scraper.setting.response_class}")

            it 'creates a rucom row in the database'
            expect(@sync.rucom.blank?).to eq(false)
            expect(@sync.rucom).to eq(@rucom)
            expect(@rucom.name).to eq 'AMADO  MARULANDA'
            expect(@rucom.original_name).to eq 'AMADO  MARULANDA    '
            expect(@rucom.minerals).to eq 'ORO'
            expect(@rucom.status).to eq 'Activo'
            expect(@rucom.provider_type).to eq 'barequero'
            expect(@rucom.rucomeable_type).to eq 'User'

            it 'creates a user profile row in the database'
            @profile = Profile.find_by(document_number: @data[:id_number])
            expect(@sync.user_profile).to eq(@profile)

            it 'creates a user row in the database'
            @user = @rucom.rucomeable
            expect(@sync.user).to eq(@user)
          end
        end

        context 'when rucom dosen\'t exist in the Rucom Remote database' do
          it 'raises an error and set the response error with it' do
            VCR.use_cassette('unsuccessful_authorized_provider_rucom_response') do
              @data[:id_number] = '1234567'
              @sync = RucomServices::Synchronize.new(@data).call
              expect(@sync.response[:errors].count).to eq(1)
              expect(@sync.response[:errors]).to include(/El rucom no existe con este documento de identidad:/)
            end
          end
        end
      end
    end
  end

  # xit '#user_registration_state_completed?' do
  # end

  # xit '#query_rucom_or_create_it' do
  # end

  context 'user_profile_exist?' do
    before do
      @data = { rol_name: 'Barequero', id_type: 'CEDULA', id_number: '15535725' }
      @sync = RucomServices::Synchronize.new(@data)
    end

    context 'When the producer Profile dosen\'t exist' do
      it 'returns false as a result' do
        VCR.use_cassette('') do
          expect(@sync.user_profile_exist?).to eq false
        end
      end
    end

    context 'When the producer Profile exists' do
      it 'returns true as a result' do
        VCR.use_cassette('successful_authorized_provider_rucom_response') do
          @user = create :user, :with_profile, :with_personal_rucom
          @data[:id_number] = @user.profile.document_number
          @sync = RucomServices::Synchronize.new(@data)

          expect(@sync.user_profile_exist?).to eq true
        end
      end
    end
  end

  context '#rucom_exist?' do
    before do
      @data = { rol_name: 'Barequero', id_type: 'CEDULA', id_number: '15535725' }
      @sync = RucomServices::Synchronize.new(@data)
    end

    context 'When rucom exist' do
      it 'returns true as response' do
        VCR.use_cassette('successful_authorized_provider_rucom_response') do
          @user = create :user, :with_profile, :with_personal_rucom
          @data[:id_number] = @user.profile.document_number
          @sync = RucomServices::Synchronize.new(@data)
          @sync.call
          expect(@sync.rucom_exist?).to eq true
        end
      end
    end

    context 'When rucom no exist' do
      it 'returns false as response' do
        VCR.use_cassette('unsuccessful_authorized_provider_rucom_response') do
          @user = create :user, :with_profile, :with_personal_rucom
          @user.personal_rucom.destroy!
          @user.reload
          @data[:id_number] = @user.profile.document_number
          @sync = RucomServices::Synchronize.new(@data)
          @sync.call
          expect(@sync.rucom_exist?).to eq false
        end
      end
    end
  end

  # Allows remove all the registers if exist them
  def clean_user_profile_rucom_data(id_number)
    return false unless profile = Profile.find_by(document_number: id_number)
    user = profile.user
    rucom = user.rucom
    Profile.destroy(profile)
    Rucom.destroy(rucom) if rucom.present?
    User.destroy(user)
  end

  # specs for company

  context '#call' do
    it 'executes sucessfully' do
      @data = { rol_name: 'Comercializadores', id_type: 'NIT', id_number: '900498208' }
      @sync = RucomServices::Synchronize.new(@data)
      VCR.use_cassette('successful_trader_rucom_response') do
        @sync.call

        # sets data attribute with the data sended
        expect(@sync.data).to eq(@data)

        # has a scraper instance setting up @scraper attribute
        expect(@sync.scraper.class).to eq(RucomServices::Scraper)

        # returns the setting object as a scraper attribute
        expect(@sync.scraper.setting.present?).to eq(true)
        expect(@sync.scraper.setting.class).to eq(RucomServices::Setting)

        # returns the state of response of the setting object success as true
        expect(@sync.scraper.setting.success).to eq(true)

        # sets response success key as true
        expect(@sync.response[:success]).to eq(true)

        # returns its own instance
        expect(@sync.class).to eq(RucomServices::Synchronize)

        # returns the respective rucom
        expect(@sync.rucom.present?).to eq(true)
        expect(@sync.rucom.class).to eq(Rucom)

        expect(@sync.company.present?).to eq(true)
        expect(@sync.company.class).to eq(Company)
        expect(@sync.company.rucom.present?).to eq(true)
        expect(@sync.company.nit_number).to eq(@data[:id_number])
      end
    end
  end

  context '#first_or_create_company_from_rucom' do
    before do
      @data = { rol_name: 'Comercializadores', id_type: 'NIT', id_number: '900498208' }
      @sync = RucomServices::Synchronize.new(@data)
    end

    context 'When the company exist' do
      context '' do
        context 'when rucom exist in the local database' do
          it 'returns the respective rucom row' do
            VCR.use_cassette('successful_trader_rucom_response') do
              @company = create :company
              @data[:id_number] = @company.nit_number
              rucom = @company.rucom
              @sync = RucomServices::Synchronize.new(@data).call
              expect(@sync.rucom).to eq(rucom)
            end
          end
        end

        it 'creates rucom from scraper service' do
          VCR.use_cassette('successful_trader_rucom_response') do
            clean_company_rucom_data(@data[:id_number])
            @sync.call
            @rucom = Rucom.find_by(name: 'INVERSIONES LETONIA S.A.S.')

            # returns the virtus model to the class response
            expect(@sync.scraper.virtus_model.present?).to eq(true)
            expect(@sync.scraper.virtus_model.class.name).to eq("RucomServices::Models::#{@sync.scraper.setting.response_class}")

            # it 'creates a rucom row in the database'
            expect(@sync.rucom.blank?).to eq(false)
            expect(@sync.rucom).to eq(@rucom)
            @company = Company.find_by(nit_number: @data[:id_number])
            expect(@sync.company.rucom.present?).to eq(true)
            expect(@sync.company.rucom).to eq(@rucom)
            expect(@sync.company).to eq(@company)
          end
        end
      end
    end
  end

  context 'company_exist?' do
    before do
      @data = { rol_name: 'Comercializadores', id_type: 'NIT', id_number: '900498208' }
      @sync = RucomServices::Synchronize.new(@data)
    end

    context 'When the producer Profile dosen\'t exist' do
      it 'returns false as a result' do
        VCR.use_cassette('successful_trader_rucom_response') do
          expect(@sync.company_exist?).to eq false
        end
      end
    end

    context 'When the producer Profile exists' do
      it 'returns true as a result' do
        VCR.use_cassette('successful_trader_rucom_response') do
          @company = create :company
          @data[:id_number] = @company.nit_number
          @sync = RucomServices::Synchronize.new(@data)
          expect(@sync.company_exist?).to eq true
        end
      end
    end
  end

  context '#company_rucom_exist?' do
    before do
      @data = { rol_name: 'Comercializadores', id_type: 'NIT', id_number: '900498208' }
    end

    context 'When rucom exist' do
      it 'returns true as response' do
        VCR.use_cassette('unsuccessful_trader_rucom_response') do
          @company = create :company
          @data[:id_number] = @company.nit_number
          @sync = RucomServices::Synchronize.new(@data)
          @sync.call
          expect(@sync.company_rucom_exist?).to eq true
        end
      end
    end
  end

  def clean_company_rucom_data(id_number)
    return false unless company = Company.find_by(nit_number: id_number)
    rucom = company.rucom
    Company.destroy(company)
    Rucom.destroy(rucom) if rucom.present?
  end

  it 'When the company can not market oro' do
    VCR.use_cassette('unsuccessful_trader_rucom_response2') do
      @data = { rol_name: 'Comercializadores', id_type: 'NIT', id_number: '900058021' }
      @sync = RucomServices::Synchronize.new(@data).call
      expect(@sync.response[:success]).to eq(false)
      expect(@sync.response[:errors]).to include(/Esta compañia no puede comercializar ORO/)
      expect(@sync.rucom.blank?).to eq(true)
      expect(@sync.rucom.present?).to eq(false)
    end
  end

  it 'When the authorized_provider can not market oro' do
    VCR.use_cassette('barequero_other_mineral_rucom_response') do
      @data = { rol_name: 'Barequero', id_type: 'CEDULA', id_number: 'xxxxxxxx' }
      @sync = RucomServices::Synchronize.new(@data).call
      expect(@sync.response[:success]).to eq(false)
      expect(@sync.response[:errors]).to include(/Este productor no puede comercializar ORO/)
      expect(@sync.rucom.blank?).to eq(true)
      expect(@sync.rucom.present?).to eq(false)
    end
  end
end
