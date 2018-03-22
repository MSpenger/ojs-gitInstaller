git clone https://github.com/bsb-zep/ojs web
cd web
git remote add upstream https://github.com/pkp/ojs
git fetch upstream
git checkout -b localTesting upstream/ojs-stable-3_1_0
git submodule update --init --recursive
cd lib/pkp
git remote add upstream https://github.com/pkp/pkp-lib
git fetch upstream
git checkout -b localTesting upstream/ojs-stable-3_1_0
/opt/composer/composer.phar update
cd ../..
cd lib/pkp
/opt/composer/composer.phar update
cd ../..
cd plugins/paymethod/paypal
/opt/composer/composer.phar update
cd ../../..
cd plugins/generic/citationStyleLanguage
/opt/composer/composer.phar update
cd ../../..
cp config.TEMPLATE.inc.php config.inc.php
sudo chown -R wwwrun:www public
sudo chown -R wwwrun:www cache
sudo chown wwwrun:www config.inc.php
npm install
npm run build
cd ..
mkdir files
sudo chown wwwrun:www files
