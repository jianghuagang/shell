#!/bin/bash

if [ $# != 1 ]; then
  echo "usage: deploy.sh filename"
  echo "deploy.sh ibatchpharma-180111.tar.gz"
  exit 1;
fi

APP_NAME=ibatchpharma
JAR_NAME=pharma-1.0.jar
TMP_DIR=/tmp/ibatchpharma
FILE_NAME=ibatchpharma-180124.tar
PHARMA_HOME=/opt
PHARMA_DIR=ibatchpharma
RESOURCE_HOME=/tmp/ibatchpharma/app/resource
DAY=`date "+%y%m%d"`

# backup old app
cd $PHARMA_HOME
tar -cf $PHARMA_DIR-$DAY-old.tar $PHARMA_DIR
rm -f $TMP_DIR/app_old/$PHARMA_DIR-$DAY-old.tar
mv $PHARMA_DIR-$DAY-old.tar $TMP_DIR/app_old

#delete old app
rm -Rf $PHARMA_HOME/$PHARMA_DIR

# extract new app
cd $TMP_DIR/app
tar -xf $FILE_NAME
if [ "ibatchpharma" != "$PHARMA_DIR" ]; then
  mv ibatchpharma $PHARMA_DIR
fi

# create classes if not exist
if [ ! -d "$TMP_DIR/app/$PHARMA_DIR/WEB-INF/classes" ]; then
  mkdir -p $TMP_DIR/app/$PHARMA_DIR/WEB-INF/classes
fi

# move jar file
mv $TMP_DIR/app/$PHARMA_DIR/WEB-INF/lib/$JAR_NAME $TMP_DIR/app/$PHARMA_DIR/WEB-INF/classes
cd $TMP_DIR/app/$PHARMA_DIR/WEB-INF/classes
jar -xf $JAR_NAME
rm -rf $JAR_NAME
rm -Rf META-INF

# create resource if not exist
if [ ! -d "$TMP_DIR/app/$PHARMA_DIR/WEB-INF/classes/resource" ]; then
  mkdir -p $TMP_DIR/app/$PHARMA_DIR/WEB-INF/classes/resource
fi
\cp -rf $RESOURCE_HOME $TMP_DIR/app/$PHARMA_DIR/WEB-INF/classes
mv $TMP_DIR/app/$PHARMA_DIR $PHARMA_HOME