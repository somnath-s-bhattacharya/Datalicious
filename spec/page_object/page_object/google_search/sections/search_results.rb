module SearchResultsSection
  require 'site_prism'

  class SearchResults < SitePrism::Section
      element :search_result_hyperlink,    ".rc .r a"
  end
end
