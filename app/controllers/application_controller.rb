module ActionDispatch
  class Flash
    class FlashHash
      def warning=(message)
        self[:warning] = message
      end
    end
  end
end

class ApplicationController < ActionController::Base
  protect_from_forgery
end
