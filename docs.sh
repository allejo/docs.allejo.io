#!/bin/bash

wget https://getcomposer.org/composer.phar --quiet
chmod +x composer.phar

./composer.phar install --quiet

SAMI=./vendor/bin/sami.php
TARDIR=./_site

# Check out our projects
rm -rf projects/
mkdir -p projects/php/

git clone https://github.com/allejo/PhpPulse.git projects/php/PhpPulse
git clone https://github.com/allejo/PhpSoda.git projects/php/PhpSoda

rm -rf _site
mkdir _site

for f in ./projects/php/*
do
    $SAMI update "$f/docs/sami-config.php"

    echo "Copying $f/docs/api/build/ to ../_site/"
    cp -af "$f/docs/api/build/." $TARDIR
done
