#!/bin/bash

TARDIR=./_site

rm -rf projects/
mkdir -p projects/{php,sass}/

rm -rf _site/
mkdir _site/

#
# PHP Projects
#

#curl -O http://get.sensiolabs.org/sami.phar

curl -O http://get.sensiolabs.org/sami-v4.0.14.phar
mv sami-v4.0.14.phar sami.phar

chmod +x sami.phar
SAMI=./sami.phar

git clone https://github.com/allejo/PhpPulse.git projects/php/PhpPulse
git clone https://github.com/allejo/PhpSoda.git projects/php/PhpSoda
git clone https://github.com/allejo/PhpWufoo.git projects/php/PhpWufoo

for f in ./projects/php/*
do
    php7.2 $SAMI update "$f/docs/sami-config.php"

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
    SASSDOCRC=$(cat .sassdocrc.dist)
    echo "${SASSDOCRC/\%package\%/$f\/package.json}" > .sassdocrc

    node_modules/.bin/sassdoc "$f/sass/*.scss" --dest "$TARDIR/$(basename $f)"
done

cp _redirects _site/_redirects
