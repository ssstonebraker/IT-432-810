#!/bin/bash
#
# Name: Proj1Stonebraker.sh
# Author: Steve Stonebraker
# School: DePaul University
# Class: IT-432-810
# Project: First Project

SCRIPTPATH=$( cd "$(dirname "$0")" ; pwd -P ) 
PROJNAME="Proj1Stonebraker"
PROJPATH="$SCRIPTPATH/$PROJNAME"
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

[ -f "$PROJPATH/tmp/pids/server.pid" ] && print_status "killing running rails server" && kill -INT $(cat $PROJPATH/tmp/pids/server.pid) 
[ -d "$PROJPATH" ] && print_status "found $PROJNAME in current path... removing" && rm -Rf $PROJPATH 

print_status "Creating new rails project $PROJNAME..."

cd $SCRIPTPATH
rails new $PROJNAME > /dev/null || die "unable to create $PROJNAME"
cd $PROJNAME

print_status "Setting up controller ..."
rails g controller MyInfoSite infopage myfavorites photos  --skip-stylesheets >/dev/null 2>&1 || die "Unable to create controller for $PROJNAME"

cat <<_eof > $PROJPATH/Gemfile
source 'https://rubygems.org'
gem 'rails', '3.2.9'
gem 'sqlite3'
 gem 'zurb-foundation'
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end
gem 'jquery-rails', '~> 2.3.0'
_eof
bundle install
yes | rails g foundation:install
print_status "Setting up info page"


cat <<_eof > $PROJPATH/app/views/my_info_site/infopage.html.erb
<h1><%= @title %></h1>
<p>Steve is enrolled in the graduate program at DePaul University and is taking the Network Security track.</p>
<p>His interests include server administration, networking, and ruby on rails!</p>
_eof

print_status "setting up my favorites"

cat <<_eof > $PROJPATH/app/views/my_info_site/myfavorites.html.erb
<h1><%= @title %><h1>
<h2>Color</h2>
	<p>Purple</p>
<h2>Food</h2>
	<p>Pizza</p>
<h2>Music</h2>
	<p>Folk Dance</p>
<h2>Animal</h2>
	<p>Whale</p>
<h2>Book</h2>
<p>What to expect when you are expecting</p>
<h2>Invention</h2>
<p>Internet</p>
_eof

print_status "setting up photos"
cat <<_eof > $PROJPATH/app/views/my_info_site/photos.html.erb
<h1><%= @title %></h1>
<table>
<tr> 
    <td>Head Librarian</td>
    <td>Frieda Farus</td>
    <td><%= image_tag 'frieda.jpg', :class => 'img' %>
    <td>Import because head Librarian</td>
</tr>

<tr> 
    <td>Reference Librarian</td>
    <td>Lotus Gergenson</td>
    <td><%= image_tag 'lotus.jpg', :class => 'img' %>
    <td>He was sent to detention last week</td>
</tr>

</table>
_eof



print_status "Setting up css overrides"

echo "
\$include-html-top-bar-classes: $include-html-classes;
\$include-html-nav-classes: $include-html-classes;
\$topbar-bg: #00006F !default;
\$topbar-bg: #00006F !default;
\$topbar-bg-color: #00006F !default;
\$body-bg: #F4F4F4;
\$body-bg: #F4F4F4;
\$body-font-color: #222;
\$body-font-family: "Helvetica Neue", "Helvetica", Helvetica, Arial, sans-serif;
\$body-font-weight: normal;
\$body-font-style: normal;
\$font-smoothing: antialiased;

.navigation-area {
    background-image: url('../img/bg.jpg');
    background-repeat: repeat-x;
}
.top-bar-section {
  background: $topbar-bg-color !important;
    li {
      background: $topbar-bg-color !important;
      a:not(.button) {
        background: $topbar-bg-color !important;
      }
   }

}

p {
font-family:"Helvetica Neue", "Helvetica", Helvetica, Arial, sans-serif;

}
table, tr, td, th {margin:0;border:0;padding:0;}
td {background-color:#f0f8ff;margin:0;border:0;padding:0;}
tr {background-color:#f0f8ff;margin:0;border:0;padding:0;}
table{border-collapse:collapse;}

h1 {
font-family:"Helvetica Neue", "Helvetica", Helvetica, Arial, sans-serif;
font-size: 24pt;
font-weight: bold;
color:#F00 ;
}

li {
  font-family:"Helvetica Neue", "Helvetica", Helvetica, Arial, sans-serif
}

// Grid Variables
//

\$column-gutter: em-calc(60);


" >> $PROJPATH/app/assets/stylesheets/foundation_and_overrides.scss



print_status "setting up controller"
cat <<_eof > $PROJPATH/app/controllers/my_info_site_controller.rb
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
cat <<_eof > $PROJPATH/app/views/layouts/application.html.erb

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>


<head>
	<meta charset="utf-8" />
  <title><%= @title %></title>
 	<%= stylesheet_link_tag    "application" %>
  	<%= javascript_include_tag "vendor/custom.modernizr" %>
    <%= csrf_meta_tags %>
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
  <%= javascript_include_tag "application" %>
</body>
</html>
_eof




print_status "setting up images"
pushd $PROJPATH/app/assets/images >/dev/null 2>&1
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
sed -i '' "s/# root :to => 'welcome#index'/root :to => 'my_info_site#infopage'/g" $PROJPATH/config/routes.rb
[ -f $PROJPATH/public/index.html ] && /bin/rm $PROJPATH/public/index.html

#gem 'jquery-rails'

print_status "Starting Rails Daemon" && rails s -d >/dev/null 2>&1 || die "Unable to start rails daemon!"
print_good "browse http://localhost:3000 to view the app!"
