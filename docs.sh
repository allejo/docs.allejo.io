#!/bin/bash

TARDIR=./_site

rm -rf projects/
mkdir -p projects/{php,sass}/

rm -rf _site/
mkdir _site/

#
# PHP Projects
#

wget https://getcomposer.org/composer.phar --quiet
chmod +x composer.phar

./composer.phar install --quiet

SAMI=./vendor/bin/sami.php

git clone https://github.com/allejo/PhpPulse.git projects/php/PhpPulse
git clone https://github.com/allejo/PhpSoda.git projects/php/PhpSoda
git clone https://github.com/allejo/PhpWufoo.git projects/php/PhpWufoo

for f in ./projects/php/*
do
    $SAMI update "$f/docs/sami-config.php"

    echo "Copying $f/docs/api/build/ to ../_site/"
    cp -af "$f/docs/api/build/." $TARDIR
done

#
# Sass Projects
#

npm install

git clone https://github.com/allejo/eyeglass-sassy-data.git projects/sass/eyeglass-sassy-data

for f in ./projects/sass/*
do
    node_modules/.bin/sassdoc "$f/sass/*.scss" --package "$f/package.json" --dest "$TARDIR/$(basename $f)"
done

cp _redirects _site/_redirects
