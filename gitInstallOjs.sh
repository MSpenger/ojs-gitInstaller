#!/bin/bash

#to run the script, please make sure your account has a SSH Key-Based Authentication to remote git repository (otherwise you will be asked to type in the password in several stages of the script) 
echo "ZEP OJS Installer"

#Ask user for name of OJS-installation
echo Please enter a name for installation:
read installvar

#Ask for vhost
echo Please enter vhost name to install OJS to:
read hostvar

#Ask for admin email
echo Please enter an email address for the OJS admin:
read emailvar

#Confirmation
echo This will install OJS for $installvar in $hostvar
read -p "Continue (y/n)?" choice
case "$choice" in
	y|Y ) echo "yes";;
	n|N ) echo "no";;
	* ) echo "invalid";;
esac

#Ask for remote git repository path
echo Please enter path to access remote git repository:
read gitvar

#Ask user for mysql login to create database
echo Please enter mysql user
read sqluservar

echo Please enter mysql password
read -s sqluserpw

set -e

echo "CREATE DATABASE $installvar DEFAULT CHARSET utf8" | mysql -u$sqluservar -p$sqluserpw
echo "CREATE USER '$installvar'@'localhost' IDENTIFIED BY '$installvar'" | mysql -u$sqluservar -p$sqluserpw
echo "GRANT ALL ON $installvar.* TO '$installvar'@'localhost'" | mysql -u$sqluservar -p$sqluserpw
echo "FLUSH PRIVILEGES" | mysql -u$sqluservar -p$sqluserpw

#check if the following packages are installed:
#php7-phar
#php7-curl
#nodejs


git clone $gitvar:/srv/git/ojs-stable $installvar
cd $installvar
git remote add upstream $gitvar:/srv/git/ojs-stable
git fetch upstream
git checkout -b localTesting upstream/ojs-stable-3_1_1
git submodule update --init --recursive

curl -sS https://getcomposer.org/installer | php
cd lib/pkp
git remote add upstream $gitvar:/srv/git/ojs-pkp-lib-stable
git fetch upstream
git checkout -b localTesting upstream/ojs-stable-3_1_1
php ../../composer.phar update
cd ../..
cd lib/pkp
php ../../composer.phar update
cd ../..
cd plugins/paymethod/paypal
php ../../../composer.phar update
cd ../../..
cd plugins/generic/citationStyleLanguage
php ../../../composer.phar update
cd ../../..

cp config.TEMPLATE.inc.php config.inc.php
sudo chown -R wwwrun:www public
sudo chown -R wwwrun:www cache
sudo chown wwwrun:www config.inc.php
npm install
npm run build
cd ..
mkdir galleys_$installvar
sudo chown wwwrun:www galleys_$installvar
sudo chmod g+rw galleys_$installvar

cd $installvar

#adjustments to installation:
#databaseDriver: mysqli (PHP 7) or mysql (PHP 5)
#make sure to change OJS and database passwords after installation


wget -O - --post-data="adminUsername=admin&adminPassword=admin&adminPassword2=admin&adminEmail=$emailvar&locale=en_US&additionalLocales[]=en_US&clientCharset=utf-8&connectionCharset=utf8&databaseCharset=utf8&filesDir=%2fsrv%2f$hostvar%2fhtml%2fgalleys_$installvar&encryption=sha1&databaseDriver=mysqli&databaseHost=localhost&databaseUsername=$installvar&databasePassword=$installvar&databaseName=$installvar&oaiRepositoryId=ojs2.$hostvar" "https://$hostvar/$installvar/index.php/index/install/install" --no-check-certificate

#Examples for installing additional addons

#cd plugins/themes
#git clone $gitvar:/srv/git/ojs-theme-bsb bsb-theme
#sudo chown -R wwwrun:www bsb-theme
#sudo chmod -R g+rw bsb-theme
#cd ../..

#cd plugins/generic
#git clone $gitvar:/srv/git/ojs-custom-citation-plugin addCustomCitationStyle
#sudo chown -R wwwrun:www addCustomCitationStyle
#sudo chmod -R g+rw addCustomCitationStyle
#cd ../..
