# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Wspolnota::Application.initialize!

Mime::Type.register 'application/pdf', :pdf