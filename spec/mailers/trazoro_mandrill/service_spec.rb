require 'spec_helper'

describe TrazoroMandrill::Service do
  # let(:user){ create :user, email: 'test@company.com', name: 'Cashimiro' }
  let(:user) { create :user, :with_profile, :with_personal_rucom, email: 'test@trazoro.co' }

  context 'send sync emails' do
    context 'single email notification' do
      it 'should check the receipient is ok' do
        merge_vars_mapping = { A_MERGE_VAR: :first_name, ANOTHER: :last_name }
        response = TrazoroMandrill::Service.recipient_from(user.email, merge_vars_mapping).to_h
        expected_response = {
          to: {
            email: 'test@trazoro.co',
            name: user.profile.first_name + ' ' + user.profile.last_name
          },
          merge_vars: {
            rcpt: 'test@trazoro.co',
            vars: [
              {
                name: :A_MERGE_VAR,
                content: user.profile.first_name
              },
              {
                name: :ANOTHER,
                content: user.profile.last_name
              }
            ]
          },
          custom_html_data: ''
        }
        expect(response).to eq(expected_response)
      end

      it 'should send an email', :vcr do
        VCR.use_cassette 'trazoro_mandrill_response_for_one_email' do
          template_name = 'test_template'
          subject_text = 'test email'
          merge_vars_mapping = { A_MERGE_VAR: 'first_name', ANOTHER: 'last_name' }
          emails = [user.email]
          response = TrazoroMandrill::Service.send_email(template_name, subject_text, merge_vars_mapping, emails)
          expect(response.first['status']).to include('sent' || 'queued')
        end
      end
    end

    context 'several emails' do
      before :each do
        @users = ['pcarmonaz@gmail.com', 'paulo.carmona@trazoro.co'].map { |email| create :user, :with_personal_rucom, email: email }
      end
      it 'should send 3 emails', :vcr do
        VCR.use_cassette 'trazoro_mandrill_response_for_three_emails' do
          template_name = 'test_template'
          subject_text = 'test email - send it to more than one'
          merge_vars_mapping = {}
          emails = ['pcarmonaz@hotmail.com', @users[0].email, @users[1].email]
          response = TrazoroMandrill::Service.send_email(template_name, subject_text, merge_vars_mapping, emails)
          response.each do |res|
            expect(res['status']).to include('sent' || 'queued')
          end
        end
      end
    end
  end

  context 'send emails with attachments' do
    it 'shoud to send email with attachments' do
      VCR.use_cassette 'trazoro_mandrill_response_email_with_attachment' do
        sale = create :sale, :with_proof_of_sale_file
        attachments = []
        template_name = 'test_template'
        subject_text = 'test email'
        merge_vars_mapping = {}
        emails = [user.email]
        options = {}
        attachments << sale.proof_of_sale
        response = TrazoroMandrill::Service.send_email(template_name, subject_text, merge_vars_mapping, emails, options, attachments)
        expect(response.last['status']).to eq('queued')
      end
    end
  end
end
