#!/bin/bash
#
# Name: Proj1Stonebraker.sh
#
#

SCRIPTPATH=$( cd "$(dirname "$0")" ; pwd -P ) 
PROJNAME="Proj1Stonebraker"

##################################################################
# Pretty print functions
function print_status { echo -e "\x1B[01;34m[*]\x1B[0m $1"; }
function print_good { echo -e "\x1B[01;32m[*]\x1B[0m $1"; }
function print_error { echo -e "\x1B[01;31m[*]\x1B[0m $1"; }
##################################################################

##################################################################
# print message and exit program
function die { print_error "$1" >&2;exit 1; }
##################################################################

[ -f "/tmp/pids/server.pid" ] && print_status "killing running rails server" && kill -INT $(cat tmp/pids/server.pid) 
[ -d "$SCRIPTPATH/$PROJNAME" ] && print_status "found $PROJNAME in current path... removing" && rm -Rf $SCRIPTPATH/$PROJNAME 

print_status "Creating new rails project $PROJNAME..."

rails new $PROJNAME > /dev/null || die "unable to create $PROJNAME"
cd $PROJNAME

print_status "Setting up controller ..."
rails g controller MyInfoSite infopage myfavorites photos >/dev/null 2>&1 || die "Unable to create controller for $PROJNAME"

print_status "Setting up info page"


cat <<_eof > $SCRIPTPATH/$PROJNAME/app/views/my_info_site/infopage.html.erb
<p>Steve is enrolled in the graduate program at DePaul University in the Network Security program.</p>
_eof

print_status "setting up my favorites"

cat <<_eof > $SCRIPTPATH/$PROJNAME/app/views/my_info_site/myfavorites.html.erb
<h2>Favorite Color</h2>
	<p>Purple</p>
<h2>Food</h2>
	<p>Pizza</p>
<h2>Music</h2>
	<p>Folk Dance</p>
<h2>Animal</h2>
	<p>Whale</p>
<h2>Book</h2>
<p>What to expect when you are expecting</p>
_eof

print_status "setting up photos"
cat <<_eof > $SCRIPTPATH/$PROJNAME/app/views/my_info_site/photos.html.erb
<p>Meet Steve Stonebraker:</p>

<table>
<tr> 
    <td>Head Librarian</td>
    <td>Frieda Farus</td>
    <td><%= image_tag 'frieda.jpg', :class => 'img' %>
</tr>

<tr> 
    <td>Reference Librarian</td>
    <td>Lotus Gergenson</td>
    <td><%= image_tag 'lotus.jpg', :class => 'img' %>
</tr>

</table>
_eof

print_status "setting up controller"
cat <<_eof > $SCRIPTPATH/$PROJNAME/app/controllers/my_info_site_controller.rb
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
_eof

print_status "setting up application"
cat <<_eof > $SCRIPTPATH/$PROJNAME/app/views/layouts/application.html.erb

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>


<head>
  <title><%= @title %></title>
  <%= stylesheet_link_tag 'library' %>
</head>
<body>
<nav class="top-bar">
  <ul class="title-area">
    <li class="name">
      <h1><%= link_to "Proj1Stonebraker", my_info_site_infopage_path %></a></h1>
    </li>
  </ul>
  <section class="top-bar-section">
    <ul class="right">
      <li class="divider"></li>
      <li><%= link_to 'Info Page', my_info_site_infopage_path %></li>
      <li class="divider"></li>
      <li><%= link_to 'My Favorites Page', my_info_site_myfavorites_path %></li>
      <li class="divider"></li>
      <li><%= link_to 'Photos Page', my_info_site_photos_path %></li>
    </ul>
  </div>
</nav>
<div class="row">
    <div class="large-8 columns">
      <%= yield %>
    </div>
    <div class="large-4 columns">
      <h2>About Us</h2>
      <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
      tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
      quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
      consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
      cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
      proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
    </div>
  </div>
  <%= javascript_include_tag "application" %>
</body>
</html>
_eof
cat <<_eof > $SCRIPTPATH/$PROJNAME/app/views/layouts/application2.html.erb
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
  <title><%= @title %></title>
  <%= stylesheet_link_tag 'library' %>
</head>
<body>

<h1><%= @title %></h1>

<table>
<tr>
    <td><%= link_to 'Info Page', my_info_site_infopage_path %></td>
    <td><%= link_to 'My Favorites Page', my_info_site_myfavorites_path %></td>
    <td><%= link_to 'Photos Page', my_info_site_photos_path %></td> </td>
</tr>
</table>

<hr />

<%= yield %>

</body>
</html>
_eof

echo '
//= require jquery
//= require jquery_ujs
//= require foundation
//= require_tree .


$(function(){ $(document).foundation(); });
' >> $SCRIPTPATH/$PROJNAME/app/assets/javascripts/application.js

echo '@import "foundation";' > $SCRIPTPATH/$PROJNAME/app/assets/stylesheets/application.css

print_status "setting up images"
pushd $SCRIPTPATH/$PROJNAME/app/assets/images >/dev/null 2>&1
curl -O http://condor.depaul.edu/sjost/it231/examples/ex-folder2/frieda.jpg >/dev/null 2>&1 || die "unable to download image"
curl -O http://condor.depaul.edu/sjost/it231/examples/ex-folder2/lotus.jpg >/dev/null 2>&1 || die "unable to download image"
popd >/dev/null 2>&1

print_good "Environment properly configured for $PROJNAME... starting server"
#print_status "Testing Links:"
print_status "http://localhost:3000/my_info_site/infopage"
print_status "http://localhost:3000/my_info_site/myfavorites"
print_status "http://localhost:3000/my_info_site/photos"
print_status "Current Routes:"
rake routes
print_status "replacing default route"
sed -i '' "s/# root :to => 'welcome#index'/root :to => 'my_info_site#infopage'/g" $SCRIPTPATH/$PROJNAME/config/routes.rb
[ -f $SCRIPTPATH/$PROJNAME/public/index.html ] && /bin/rm $SCRIPTPATH/$PROJNAME/public/index.html

cat <<_eof > $SCRIPTPATH/$PROJNAME/Gemfile
source 'https://rubygems.org'
gem 'rails', '3.2.9'
gem 'sqlite3'
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'compass-rails'
  gem 'zurb-foundation'
end
_eof
#gem 'jquery-rails'
bundle install
rails g foundation:install
print_status "Starting Rails Daemon" && rails s -d >/dev/null 2>&1 || die "Unable to start rails daemon!"
print_good "browse http://localhost:3000 to view the app!"
