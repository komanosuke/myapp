class ApplicationController < ActionController::Base
    def hello
        render plain: 'Hello, world!'
    end
end
