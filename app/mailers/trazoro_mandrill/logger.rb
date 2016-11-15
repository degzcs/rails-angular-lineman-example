module TrazoroMandrill
  # In charged to log the mailer messages
  class Logger < ::Logger
    def format_message(severity, timestamp, _progname, msg)
      "#{timestamp.to_formatted_s(:db)} #{severity} #{msg}\r\n"
    end
  end
end
