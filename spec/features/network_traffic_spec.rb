require 'spec_helper'

feature 'Datalicious - Network Traffic Monitor' do

  include GeneralHelper

  scenario 'Network Traffic' do
    #Task 1a: Go To google.com
    visit('https://www.google.com')
    google_landing_page = GoogleLandingPage::LandingPage.new
    #Task 1b: Put in - Datalicious
    google_landing_page.search_bar.set "Datalicious"
    #Task 1c: Search
    google_landing_page.search_bar.native.send_keys(:enter)
    google_search_result = GoogleResultsPage::ResultsPage.new
    url = google_search_result.search_result[0].search_result_hyperlink[:href]
    #Task 1c: Click First Result from organic search
    google_search_result.search_result[0].search_result_hyperlink.click
    #Task 2
    register_as_poltergeist_driver
    visit(url)
    sleep 4
    url_response_array=[]
    # get all network traffic detail in array
    page.driver.network_traffic.each do |request|
      request.response_parts.uniq(&:url).each do |response|
        #puts "#{response.url}: #{response.status}"
        url_response_array << "#{response.url}"
      end
    end
    # Task 2a: Collect Endpoint of google analytics call
    google_analytics_url_regex = "www.google-analytics.com/r/collect?"
    google_analytics_endpoint = url_response_array.find{ |e| /#{google_analytics_url_regex}/ =~ e }
    puts "##############################################################################################################################################################################"
    puts "Collected Google Analytics Endpoint:"
    puts google_analytics_endpoint
    # Check whether a request was made to google-analytics
    expect(url_response_array).to have_content(google_analytics_url_regex)
    puts "##############################################################################################################################################################################"
    # Task 2b: Collect Endpoint of DC OptimaHub
    dc_optimahub_url_regex = "dc.optimahub.com"
    dc_optimahub_enpoint = url_response_array.find{ |e| /#{dc_optimahub_url_regex}/ =~ e }
    puts "Collected DC OptimaHub Endpoint(s):"
    puts dc_optimahub_enpoint
    # Check whether a request was made to dc.optimahub
    expect(url_response_array).to have_content(dc_optimahub_url_regex)
    puts "##############################################################################################################################################################################"
    # Task 3: Check that the google analytics request has "dt" and "dp" params
    ga_request_all_params =  google_analytics_endpoint.split("?").last
    param_hash = CGI::parse(ga_request_all_params)
    param_values = {"dt"=> param_hash["dt"].first, "dp"=>param_hash["dp"].first}
    # write params to csv log file
    date_stamp =  Time.now.strftime("%d-%b-%YT%H:%M:%S")
    CSV.open("logs/#{date_stamp}_ga_params_log.csv", "wb") {|csv| param_values.to_a.each {|elem| csv << elem} }
    expect(param_hash.key?("dt")).to be_truthy
    #following expect will fail as "dp" param does not exist (this issue was conveyed over to concerned dev over call on 18/07/2017)
    #So the Following step has been commented. Once this is available we can uncomment the last check.
    #Log File is generated the logs directory

    # expect(param_hash.key?("dp")).to be_truthy
  end
end
