class MyInfoSiteController < ApplicationController
  def infopage
        @title = 'Info Page'
  end

  def myfavorites
        @title = 'My Favorites'
  end

  def photos
        @title = 'Photos'
  end
end
