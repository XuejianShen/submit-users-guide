#!/bin/bash
WEB_SERVER=submit06.mit.edu
WEB_LOCATION=/var/www/html/submit-users-guide
if [ ".$1" != "." ]
then
   WEB_SERVER="$1"
fi
RSYNC_TARGET=$WEB_SERVER:$WEB_LOCATION

echo " Installing into: $RSYNC_TARGET"

sphinx-build -b html source build
if [ ".$?" != ".0" ]
then
    echo " Sphinx build failed ... please fix."
    exit 1
fi

make html
if [ ".$?" != ".0" ]
then
    echo " Making the html sources failed ... please fix."
    exit 2
fi

# hack to get colors right - overwrite theme pygments file.
echo "\
cp css/pygments.css build/_static/"
cp css/pygments.css build/_static/
echo "\
cp _static/custom.css build/_static"
cp _static/custom.css build/_static

echo "\
rsync -Cavz --delete build/* $RSYNC_TARGET"
rsync -Cavz --delete build/* $RSYNC_TARGET
