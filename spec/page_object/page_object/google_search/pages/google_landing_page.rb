module GoogleLandingPage
  require 'site_prism'

  class LandingPage < SitePrism::Page
    set_url "/#"

    element :search_bar, "#lst-ib"

  end
end
