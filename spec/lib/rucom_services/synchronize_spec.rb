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
      VCR.use_cassette('successful_rucom_response') do
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
      VCR.use_cassette('unsuccessful_rucom_response') do
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
      @data = { rol_name: 'Barequero', id_type: 'CEDULA', id_number: '15535725' }
      @sync = RucomServices::Synchronize.new(@data)
    end

    context 'When the user profile exist' do
      context 'When the user registration state is not completed' do
        context 'when rucom exist in the local database' do
          it 'returns the respective rucom row' do
            @user = create :user, :with_profile, :with_personal_rucom
            @data[:id_number] = @user.profile.document_number
            rucom = @user.rucom
            @sync = RucomServices::Synchronize.new(@data).call
            puts 'ok1'
            expect(@sync.rucom).to eq(rucom)
          end
        end

        it 'creates rucom from scraper service' do
          VCR.use_cassette('successful_rucom_response') do
            clean_user_profile_rucom_data(@data[:id_number])
            @sync.call
            @rucom = Rucom.find_by(name: 'AMADO  MARULANDA')

            # returns the virtus model to the class response
            expect(@sync.scraper.virtus_model.present?).to eq(true)
            expect(@sync.scraper.virtus_model.class.name).to eq("RucomServices::Models::#{@sync.scraper.setting.response_class}")

            # it 'creates a rucom row in the database'
            expect(@sync.rucom.blank?).to eq(false)
            expect(@sync.rucom).to eq(@rucom)

            # it 'creates a user profile row in the database'
            @profile = Profile.find_by(document_number: @data[:id_number])

            expect(@sync.user_profile).to eq(@profile)

            # it 'creates a user row in the database'
            @user = @rucom.rucomeable
            expect(@sync.user).to eq(@user)
          end
        end

        context 'when rucom dosen\'t exist in the Rucom Remote database' do
          it 'raises an error and set the response error with it' do
            VCR.use_cassette('unsuccessful_rucom_response') do
              @data[:id_number] = '1234567'
              @sync = RucomServices::Synchronize.new(@data).call
              expect(@sync.response[:errors].count).to eq(1)
              expect(@sync.response[:errors]).to include(/The rucom dosen't exist for this id_number:/)
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
        expect(@sync.user_profile_exist?).to eq false
      end
    end

    context 'When the producer Profile exists' do
      it 'returns true as a result' do
        @user = create :user, :with_profile, :with_personal_rucom
        @data[:id_number] = @user.profile.document_number
        @sync = RucomServices::Synchronize.new(@data)

        expect(@sync.user_profile_exist?).to eq true
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
        VCR.use_cassette('unsuccessful_rucom_response') do
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
        VCR.use_cassette('unsuccessful_rucom_response') do
          @user = build :user, :with_profile
          @user.save(validates: false)
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
end
