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
      def send_email(template_name, subject, merge_vars, emails, options={})
        mailer =  TrazoroMandrill::Mailer.setup(subject: subject,
                                        from_name: 'A name here',
                                        from_email: 'no-reply@trazoro.co',
                                        template: template_name,
                                        global_merge_vars: options[:global_merge_vars] || default_global_merge_vars)
        service_log.info "Sending emails to: #{ emails.join(', ') } \n"
        response = if ['development', 'test', 'staging'].include? Rails.env #if Rails.env.staging?
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
        user = user_by_email(email).decorate
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
      # @return [ User ]
      def user_by_email(email)
        User.where(email: email).first
      end

      # @param user [ User ]
      # @return [ Hash ]
      def to_values_from(user)
        { email: user.email, name: user.try(:name) }
      end

      # @return [ Hash ] with the form
      # { rcpt: <email address>, vars: [{ <SYMBOL_KEY> => <value>} , ... ] }
      def merge_vars_values_from(user, merge_vars)
        { rcpt: user.email, vars: vars_from(user, merge_vars) }
      end

      # @param [ User ]
      # @return [ Array ] with hashes in the form:
      # { name: <MERGE_VAR_NAME_AS_A_SYMBOL>, content: <value> }
      def vars_from(user, merge_vars)
        merge_vars.map do |var_name, method|
          {
            name: var_name.to_s.upcase.to_sym,
            content: user.send(method)
          }
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
    end
  end
end