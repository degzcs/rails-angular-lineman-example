module TrazoroMandrill
  class Service
    class << self
      GLOBAL_MERGE_VARS_MAPPING = {
        POSTAL_ADDRESS: 'Ruta N, Medellín - Antioquia',
        COMPANY_EMAIL: 'soporte@trazoro.co',
        COMPANY_SITE: 'www.trazoro.co',
        PHONE_NUMBER: '+(57) 516-77-70 ext: 1035',
      }
      # Main method to send transactional emails
      # @param templante_name [ String ]
      # @param subject [ String ]
      # @param methods_to_get_merge_vars [ Hash ]
      # @param emails [ Array ]
      # @return [ Array ] with the mandrill responses
      # ex. [
      #      {
      #             "email" => "recipient.email@anycompany.com",
      #            "status" => "sent",
      #               "_id" => "b3473ea0fa3245549e8eda34928c2526",
      #       "reject_reason" => nil
      #      }
      #     ]
      def send_email(template_name, subject, merge_vars, emails, options={}, attachments=[])
        mailer =  TrazoroMandrill::Mailer.setup(subject: subject,
                                        from_name: 'A name here',
                                        from_email: 'no-reply@trazoro.co',
                                        template: template_name,
                                        global_merge_vars: options[:global_merge_vars] || default_global_merge_vars,
                                        attachments: attachments.present? ? get_file_attachments(attachments) : attachments)
        service_log.info "Sending emails to: #{ emails.join(', ') } \n"
        response = if ['test', 'staging'].include? Rails.env #if Rails.env.staging?
                    send_fake_email!(mailer)
                  else
                    emails.map do |email|
                      recipient = recipient_from(email, merge_vars)
                      mailer.send_one!(recipient)
                    end
                  end
        service_log.info response
        response
      end

      # Send email in an async form
      # @param templante_name [ String ]
      # @param subject [ String ]
      # @param merge_vars [ Hash ] not implemented yet
      # @param emails [ Array ]
      # @return [ String ] with the work id gave it by redis
      def send_async_email(template_name, subject, merge_vars, emails)
        MandrillWorker.perform_async(template_name, subject, merge_vars, emails)
      end

      # @param email [ String ]
      # @param merge_vars [ Hash ] not implemented yet
      # @return [ OpenStruct ] with the basic attributes that the Mandrill Mailer needs to be setup
      def recipient_from(email, merge_vars)
        user = user_by_email(email)
        OpenStruct.new(
        {
          to: to_values_from(user),
          merge_vars: merge_vars_values_from(user, merge_vars),
          custom_html_data: ''
          })
      end

      private
      # @return [Mandrill::Logger] with the methods of Rails Logger
      def service_log
        log_file = File.open("#{Rails.root}/log/mandrill.#{Rails.env}.log", "a")
        log_file.sync = true
        TrazoroMandrill::Logger.new(log_file)
      end

      # @param email [ String ]
      # @return [ UserPresenter ]
      def user_by_email(email)
        user = User.where(email: email).first
        UserPresenter.new(user,nil)
      end

      # @param user [ User ]
      # @return [ Hash ]
      def to_values_from(user)
        { email: user.try(:email), name: user.try(:name) }
      end

      # @return [ Hash ] with the form
      # { rcpt: <email address>, vars: [{ <SYMBOL_KEY> => <value>} , ... ] }
      def merge_vars_values_from(user, merge_vars)
        { rcpt: user.try(:email), vars: vars_from(user, merge_vars) }
      end

      # @param [ User ]
      # @return [ Array ] with hashes in the form:
      # { name: <MERGE_VAR_NAME_AS_A_SYMBOL>, content: <value> }
      def vars_from(user, merge_vars)
        merge_vars.map do |var_name, value|
          {
            name: var_name.to_s.upcase.to_sym,
            content: merge_var_content_for(value, user)
          }
        end
      end

      # Gets the correct value to send. In case that it is a symbol, it will get the value from
      # the UserPresenter class in other cases it will use the value sent as parameter.
      # @param value [ Symbol or Any]
      # @param user [ User ]
      # @return [ String ]
      def merge_var_content_for(value, user)
        if value.is_a? Symbol
          user.send(value)
        else
          value.to_s
        end
      end

      # @return [ Array ]
      def default_global_merge_vars
        GLOBAL_MERGE_VARS_MAPPING.map{ |key, value| { name: key, content: value } }
      end

      # Allows to send fake emails to an specific account
      # @return [ OpenStruct ] with the basic attributes that the Mandrill Mailer needs to be setup
      def fake_recipient
        fake_email = ENV['FAKE_EMAIL'] || 'pcarmonaz@gmail.com'
        OpenStruct.new(
          {
            to: { email: fake_email, name: 'Fake name'},
            merge_vars: { rcpt: fake_email, vars: [] },
            custom_html_data: ''
          }
        )
      end

      # Sends the fake email to the fake recipient
      def send_fake_email!(mailer)
        mailer.send_one!(fake_recipient)
      end

      # Returns the structure required to attachments files to send by email
      # def get_file_attachments(attachments)
      #   attachments.map do |file_attach|
      #     {
      #       type: file_attach.file.content_type,
      #       name: file_attach.type.to_s + '.' + file_attach.file.content_type.split('/').to_s ,
      #       content: Base64.encode64(open_file_attach(file_attach.file))
      #     }
      #   end
      # end

      def get_file_attachments(attachments)
        attachments.map do |file_attach|
          mime_types = get_mime_types(file_attach)
          get_attachment_structure(mime_types, file_attach)
        end
      end


      #  MIME::Types.type_for(file_name)
      #  @param file_name as String
      #  Return Array with a MimeType Object inside
      #  Guess the content-type when you pass as argument the file based on its extension
      # returns an Array with a MimeType Object inside like this:
      #   [
      # [0] {
      #                    "Content-Type" => "application/pdf",
      #       "Content-Transfer-Encoding" => "base64",
      #                      "Extensions" => [
      #                                     [0] "pdf"
      #                                      ],
      #                          "System" => nil,
      #                        "Obsolete" => nil,
      #                            "Docs" => nil,
      #                             "URL" => [
      #                                       [0] "IANA",
      #                                       [1] "RFC3778"
      #                                      ],
      #                      "Registered" => true
      #     }
      #   ]
      def get_attachment_structure(mime_types, file_attach)
        {
          type: mime_types.content_type,
          name: file_attach.attributes['file'],
          content: Base64.encode64(open_file_attach(file_attach.file))
        }
      end

      # file_attach.attributes
      # returns a Hash with the attributes of the Model
      # {
      #                  "id" => 151,
      #                "file" => "equivalent_document.pdf",
      #                "type" => "equivalent_document",
      #     "documentable_id" => "60",
      #   "documentable_type" => "Order",
      #          "created_at" => Wed, 16 Nov 2016 12:44:07 UTC +00:00,
      #          "updated_at" => Wed, 16 Nov 2016 12:44:07 UTC +00:00
      # }

      def get_mime_types(file_attach)
        MIME::Types.type_for(file_attach.attributes['file']).first
      end

      # def get_mime_type(file_attach)
      #   file_attach.file.try(content_type).blank? ? MIME::Types.type_for(file_attach.attributes['file']).first : file_attach.file.content_type
      # end


      def open_file_attach(attachment)
        file = if APP_CONFIG[:USE_AWS_S3] || Rails.env.production?
                  open(attachment.file.url).read
               else
                  File.read(attachment.file.path)
               end
      rescue Exception => error
        service_log.error "open_file_attach: Time: #{Time.now} - Error => #{error}"
      end
    end
  end
end