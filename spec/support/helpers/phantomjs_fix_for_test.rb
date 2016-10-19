if Rails.env.test?
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