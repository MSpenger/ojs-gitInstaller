# gitInstaller for Open Journal Systems

> The OJS gitInstaller has been developed by the Center for Electronic Publishing at the Bavarian State Library. The program uses a bash script based on PKP's Vagrant-script https://github.com/pkp/vagrant/blob/ojs-master/scripts/ojs.sh.

 
## Using Git development source (see README.md on https://github.com/pkp/ojs)

Checkout submodules and copy default configuration:

    cp config.TEMPLATE.inc.php config.inc.php

Install or update dependencies via Composer:

    # if you don't already have Composer installed:
    curl -sS https://getcomposer.org/installer | php
    cd lib/pkp
    php ../../composer.phar update
    cd ../..
    cd plugins/paymethod/paypal
    php ../../../composer.phar update
    cd ../../..
    cd plugins/generic/citationStyleLanguage
    php ../../../composer.phar update
    cd ../../..

Install or update dependencies via [NPM] (https://www.npmjs.com/):

    # install [nodejs](https://nodejs.org/en/) if you don't already have it
    npm install
    npm run build


## Variables used in this script

There are a number of variables used in this script. They can also be defined beforehand, instead of script lines 10-17, 27-37)

    gitvar="[user]@[server]"
    emailvar="[name@example.org]"
    hostvar="[test.site.com]"
    drivervar="mysqli" (or "mysql")
    adminuser="admin"
    adminpassword="password"
    sqluservar="sql_user"
    sqluserpw= "sql_pw"

## Examples to include additional plugins and themes

The last two blocks of the script are commented out but show how to include plugins and themes automatically to the installation script.
