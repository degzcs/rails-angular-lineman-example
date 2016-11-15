require 'spec_helper'

describe TrazoroMandrill::Mailer do
  context 'Setup Mailer class' do
    it 'should seting up the Mailer class' do
      expected = {
        'api_key' => '3rQlxqb1FHr693HAu_c1XQ', # ENV['MANDRILL_API_KEY'],
        'template' => 'test_template',
        'subject' => 'welcome message',
        'from_name' => 'A name here',
        'from_email' => 'no-reply@trazoro.co',
        'text' => nil,
        'html' => nil,
        'use_merge_vars' => true,
        'global_merge_vars' => [],
        'custom_html_data' => nil,
        'attachments' => [],
        'responses' => []
      }
      mailer = TrazoroMandrill::Mailer.setup(
        subject: 'welcome message',
        from_name: 'A name here',
        from_email: 'no-reply@trazoro.co',
        template: 'test_template',
        global_merge_vars: []
      )

      expect(mailer.attributes).to eq expected
    end
  end

  context 'Sent test emails' do
    let(:mailer) do
      TrazoroMandrill::Mailer.setup(
        subject: 'welcome message',
        from_name: 'A name here',
        from_email: 'no-reply@trazoro.co',
        template: 'test_template',
        global_merge_vars: []
      ) # Mandrill::GenericService.default_global_merge_vars
    end

    subject { mailer }

    before :each do
      # Setup to and merge_vars parameters
      @to = [
        {
          email: 'test@company.com',
          name: 'test user'
        }
      ]

      @merge_vars = [
        {
          rcpt: 'test@company.com',
          vars: [
            {
              name: :NAME,
              content: 'test user'
            }
          ]
        }
      ]
    end

    context 'setup the hash for be sent by email through mandrill API!' do
      it 'should be configured the \'message\' hash with all parameters for ONE user (without custom html data)' do
        expected_response =
          {
            subject: 'welcome message - test',
            from_name: 'A name here',
            from_email: 'no-reply@trazoro.co',
            merge: true,
            to: [
              {
                email: 'test@company.com',
                name: 'test user'
              }
            ],
            merge_vars: [
              {
                rcpt: 'test@company.com',
                vars: [
                  {
                    name: :NAME,
                    content: 'test user'
                  }
                ]
              }
            ],
            global_merge_vars: []
          }

        # craete recipient
        recipient = OpenStruct.new(to: @to, merge_vars: @merge_vars)
        message = mailer.message_data([recipient])
        expect(message).to be_a_kind_of(Hash)
        expect(message).to eq(expected_response)
      end
    end

    context 'send email' do
      it 'should sent just one transactional email', :vcr do
        VCR.use_cassette 'trazoro_mailer_mandrill_response' do
          recipient = OpenStruct.new(to: @to, merge_vars: @merge_vars)
          response = mailer.send_one!(recipient)
          expect(response.first['status']).to include('sent' || 'queued') # be_sent_or_queued
        end
      end
    end
  end
end
