class InfoController < ApplicationController
	
  def welcome
     @title = 'Welcome Page'
  end

  def staff
     @title = 'Staff Listing Page'
  end

  def policies
     @title = 'Policies Page'
  end

end
