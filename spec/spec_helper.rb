require 'capybara/rspec'
require 'capybara'
require_relative 'page_object/all_page_objects'
require_relative 'support/all_helpers'
require 'selenium-webdriver'
require 'pry'
require 'site_prism'
require 'yaml'
require 'capybara-screenshot/rspec'
require 'active_support/all'
require 'yaml'
require 'time'
require 'capybara/poltergeist'
require 'cgi'
require 'pry'
require 'csv'

Capybara.default_driver = :selenium

RSpec.configure do |config|
  config.before(:suite) do
    Capybara.default_max_wait_time = 5
    case ENV["JS_DRIVER"]
      when nil
        js_driver = "selenium-chrome"
      when "selenium-chrome", "selenium-firefox", "selenium-safari"
        js_driver = ENV["JS_DRIVER"]
      else
        js_driver = "selenium-chrome"
    end
    screenshot_setup
    case js_driver
      when "selenium-chrome"
        Capybara.register_driver :selenium do |app|
          Capybara::Selenium::Driver.new(app, :browser => :chrome)
        end
        Capybara.javascript_driver = :chrome
      when "selenium-firefox"
        Capybara.register_driver :selenium do |app|
          Capybara::Selenium::Driver.new(app, :browser => :firefox)
        end
        Capybara.javascript_driver = :firefox
      when "selenium-safari"
        Capybara.register_driver :selenium do |app|
          Capybara::Selenium::Driver.new(app, :browser => :safari, :extensions => ["SafariDriver.safariextz"])
        end
        Capybara.javascript_driver = :safari
    end
  end

  config.before(:each) do
  end

  config.after(:suite) do
    RSpec.world.all_examples.each do |example|
      if example.pending?
        puts "  - Pending test: #{example.location}"
      end
    end
  end

  def screenshot_setup
    Capybara::Screenshot.prune_strategy = { keep: 20 }
    Capybara.save_path = "spec/screenshots"
    Capybara::Screenshot.autosave_on_failure = true
    Capybara::Screenshot.append_timestamp = true
    Capybara::Screenshot.register_filename_prefix_formatter(:rspec) do |example|
      "screenshot_#{example.description.gsub(' ', '-').gsub(/^.*\/spec\//,'')}"
    end
  end
end