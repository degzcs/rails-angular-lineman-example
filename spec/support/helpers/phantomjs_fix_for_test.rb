if Rails.env.test?
  # NOTE: This fix the issues with VCR and its cassettes. The thing is that the gem is very especial,
  # I meant smart one (for real environments ), it trys to to find a free port in case that the 8910 port is busy.
  # This avoid that VCR handle in a correct war evry request to the RUCOM page on test env (on dev and prod is OK)
  # So the idea with this fix is avoid that dynamic assigment.
  module Selenium
    module WebDriver
      module PhantomJS
        class Service
          def find_free_port
            @port = 8910 #PortProber.above @port
          end
        end
      end
    end
  end
end