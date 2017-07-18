module GoogleResultsPage
  require 'site_prism'
  require_relative '../sections/search_results'

  class ResultsPage < SitePrism::Page

    sections :search_result, ::SearchResultsSection::SearchResults, "._NId .srg .g"

  end
end
