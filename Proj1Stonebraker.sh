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

[ -d "$SCRIPTPATH/$PROJNAME" ] && print_status "found $PROJNAME in current path... removing" && rm -Rf $SCRIPTPATH/$PROJNAME

print_status "Creating new rails project $PROJNAME..."

rails new $PROJNAME > /dev/null || die "unable to create $PROJNAME"
cd $PROJNAME

print_status "Setting up controller ..."
rails g controller MyInfoSite infopage myfavorites photos > /dev/null || die "Unable to create controller for $PROJNAME"

print_status "Setting up info page"


cat <<_eof > $SCRIPTPATH/$PROJNAME/app/views/my_info_site/infopage.html.erb
<h1>Informational Page for Steve Stonebraker</h1>
<p>Steve is enrolled in the graduate program at DePaul University in the Network Security program.</p>
_eof

print_status "setting up my favorites"

cat <<_eof > $SCRIPTPATH/$PROJNAME/app/views/my_info_site/myfavorites.html.erb
<h1>Steve's Preferences</h1>
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

print_status "setting up images"
pushd $SCRIPTPATH/$PROJNAME/app/assets/images
curl -O http://condor.depaul.edu/sjost/it231/examples/ex-folder2/frieda.jpg > /dev/null || die "unable to download image"
curl -O http://condor.depaul.edu/sjost/it231/examples/ex-folder2/lotus.jpg > /dev/null || die "unable to download image"
popd

print_good "Environment properly configured for $PROJNAME... starting server"
print_info "Testing Links:"
print_info "http://localhost:3000/my_info_site/infopage"
print_info "http://localhost:3000/my_info_site/myfavorites"
print_info "http://localhost:3000/my_info_site/photos"
rails s
