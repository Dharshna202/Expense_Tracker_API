#!/bin/sh
# ----------------------------------------------------------------------------
# Simplified Maven Wrapper Script
#
# This script sets up and runs Maven using the Maven wrapper.
# ----------------------------------------------------------------------------

# Function to find Maven base directory
find_maven_basedir() {
  if [ -z "$1" ]; then
    echo "Path not specified to find_maven_basedir"
    return 1
  fi

  basedir="$1"
  wdir="$1"
  while [ "$wdir" != '/' ]; do
    if [ -d "$wdir/.mvn" ]; then
      basedir=$wdir
      break
    fi
    wdir=`cd "$wdir/.."; pwd`
  done
  echo "${basedir}"
}

# Function to concatenate lines of a file
concat_lines() {
  if [ -f "$1" ]; then
    echo "$(tr -s '\n' ' ' < "$1")"
  fi
}

BASE_DIR=`find_maven_basedir "$(pwd)"`
if [ -z "$BASE_DIR" ]; then
  echo "Error: Maven base directory not found."
  exit 1
fi

# Maven wrapper JAR download
if [ ! -r "$BASE_DIR/.mvn/wrapper/maven-wrapper.jar" ]; then
  echo "Maven wrapper JAR not found. Downloading..."
  jarUrl="https://repo.maven.apache.org/maven2/io/takari/maven-wrapper/0.5.6/maven-wrapper-0.5.6.jar"
  wrapperJarPath="$BASE_DIR/.mvn/wrapper/maven-wrapper.jar"
  curl -o "$wrapperJarPath" "$jarUrl"
fi

# Set Maven environment variables
export MAVEN_PROJECTBASEDIR=${MAVEN_BASEDIR:-"$BASE_DIR"}
MAVEN_OPTS="$(concat_lines "$MAVEN_PROJECTBASEDIR/.mvn/jvm.config") $MAVEN_OPTS"

# Run Maven wrapper
exec "$JAVA_HOME/bin/java" \
  $MAVEN_OPTS \
  -classpath "$MAVEN_PROJECTBASEDIR/.mvn/wrapper/maven-wrapper.jar" \
  org.apache.maven.wrapper.MavenWrapperMain "$@"
