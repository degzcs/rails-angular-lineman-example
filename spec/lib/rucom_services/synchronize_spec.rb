# Frozen-string-literal: false

require 'spec_helper'
# require 'vcr'

describe RucomServices::Synchronize do
  subject(:sinc) { RucomServices::Synchronize.new }

  before do
    @data = { rol_name: 'Barequero', id_type: 'CEDULA', id_number: '15535725' }
    @sync = RucomServices::Synchronize.new(@data)
  end

  context '#call' do
    context 'When executes sucessfully' do
      before do
        @sync.call
      end

      it 'sets data attribute with the data sended' do
        expect(@sync.data).to eq(@data)
      end

      it 'has a scraper instance setting up @scraper attribute' do
        expect(@sync.scraper.class).to eq(RucomServices::Scraper)
      end

      it 'sets response success key as true' do
        expect(@sync.response[:success]).to eq(true)
      end

      it 'returns its own instance' do
        expect(@sync.class).to eq(RucomServices::Synchronize)
      end
    end

    context 'When executes unsucessfully' do
      before do
        @data[:id_number] = '1234567'
        @sync = RucomServices::Synchronize.new(@data).call
      end

      it 'sets response success key as false' do
        expect(@sync.response[:success]).to eq(false)
      end

      it 'sets response errors key with the exception' do
        expect(@sync.response[:errors].count).to be > 0
      end

      it 'returns its own instance' do
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

            expect(@sync.rucom).to eq(rucom)
          end
        end

        context 'when rucom should be created from scraper service' do
          before do
            clean_user_profile_rucom_data(@data[:id_number])
            @sync.call
            @rucom = Rucom.find_by(name: 'AMADO  MARULANDA')
          end

          it 'creates a rucom row in the database' do
            expect(@sync.rucom).to eq(@rucom)
          end

          it 'creates a user profile row in the database' do
            @profile = Profile.find_by(document_number: @data[:id_number])

            expect(@sync.user_profile).to eq(@profile)
          end

          it 'creates a user row in the database' do
            @user = @rucom.rucomeable
            expect(@sync.user).to eq(@user)
          end
        end

        context 'when rucom dosen\'t exist in the Rucom Remote database' do
          it 'raises an error and set the response error with it' do
            @data[:id_number] = '1234567'
            @sync = RucomServices::Synchronize.new(@data).call

            expect(@sync.response[:errors].count).to eq(1)
            expect(@sync.response[:errors]).to include(/The rucom dosen't exist for this id_number:/)
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
        @user = create :user, :with_profile, :with_personal_rucom
        @data[:id_number] = @user.profile.document_number
        @sync = RucomServices::Synchronize.new(@data)
        @sync.call
        expect(@sync.rucom_exist?).to eq true
      end
    end

    context 'When rucom no exist' do
      it 'returns false as response' do
        @user = build :user, :with_profile
        @user.save(validates: false)
        @data[:id_number] = @user.profile.document_number
        @sync = RucomServices::Synchronize.new(@data)
        @sync.call
        expect(@sync.rucom_exist?).to eq false
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
