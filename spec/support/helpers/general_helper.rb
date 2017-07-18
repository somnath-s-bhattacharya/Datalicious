require 'capybara'

module GeneralHelper

  def register_as_poltergeist_driver
    Capybara.default_driver = :poltergeist
    Capybara.register_driver :poltergeist do |app|
      options = {
          :js_errors => false,
          :timeout => 120,
          :debug => false,
          :phantomjs_options => ['--load-images=yes', '--disk-cache=false'],
          :inspector => true
      }
      Capybara::Poltergeist::Driver.new(app, options)
    end
    Capybara.javascript_driver = :poltergeist
  end
end