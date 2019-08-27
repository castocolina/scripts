#!/bin/zsh
BASEDIR=$(dirname "$0")
sudo echo "Test sudo"

export SEPARATOR="========================================================================================================================"

echo
echo $SEPARATOR
echo ">>>>> ANDROID ................"
echo $SEPARATOR

source $BASEDIR/install_func.zsh
source $MY_SH_CFG_FILE
MY_OS=$(get_os)

echo -n "UPDATE? (y/n) > "
read to_update

printf "\n$SEPARATOR\n >>>>> JAVA\n"
(exist_cmd java ) || {
  if [ "$MY_OS" = "linux" ]; then
    exist_dir "$HOME/.sdkman/candidates/java/current/" || sdk install java 8.0.191-oracle
    JAVA_HOME_TEXT=$(cat <<'EOF'
export JAVA_HOME="$HOME/.sdkman/candidates/java/current/"
export JDK_HOME="$JAVA_HOME"
export JRE_HOME="$JAVA_HOME"
EOF
);
    find_append $MY_SH_CFG_FILE "export JAVA_HOME=" "$JAVA_HOME_TEXT"
  fi
}

# JAVA_PATH=$(readlink $(which java))
if [ "$MY_OS" = "darwin" ]; then
  brew cask install adoptopenjdk/openjdk/adoptopenjdk8
fi

exist_cmd mvn || sdk install maven
(is_true $to_update && exist_cmd mvn) && sdk install maven
exist_cmd gradle || sdk install gradle
(is_true $to_update && exist_cmd gradle) && sdk install gradle

INSTALL_ANDROID_PACK='-1'
function install_android_packages(){
  export INSTALL_ANDROID_PACK='0'
  yes | sdkmanager --licenses || true
  yes | sdkmanager --update --sdk_root="$ANDROID_SDK"

  printf "\n$SEPARATOR\n >>>>> INSTALL REPOS\n"
  yes | sdkmanager "extras;google;m2repository" "extras;android;m2repository" --sdk_root="$ANDROID_SDK"

  printf "\n$SEPARATOR\n >>>>> INSTALL TOOLS\n"
  yes | sdkmanager "tools" "platform-tools" --sdk_root="$ANDROID_SDK"

  printf "\n$SEPARATOR\n >>>>> INSTALL NDK\n"
  yes | sdkmanager "ndk-bundle" --sdk_root="$ANDROID_SDK"

  printf "\n$SEPARATOR\n >>>>> INSTALL PLATFORMs\n"
  yes | sdkmanager "platforms;android-24" --sdk_root="$ANDROID_SDK"
  yes | sdkmanager "platforms;android-25" --sdk_root="$ANDROID_SDK"
  yes | sdkmanager "platforms;android-26" --sdk_root="$ANDROID_SDK"
  yes | sdkmanager "platforms;android-27" --sdk_root="$ANDROID_SDK"
  yes | sdkmanager "platforms;android-28" --sdk_root="$ANDROID_SDK"
  yes | sdkmanager "platforms;android-29" --sdk_root="$ANDROID_SDK"

  printf "\n$SEPARATOR\n >>>>> INSTALL BUIL-TOOLS\n"
  yes | sdkmanager "build-tools;24.0.3" --sdk_root="$ANDROID_SDK"
  yes | sdkmanager "build-tools;25.0.3" --sdk_root="$ANDROID_SDK"
  yes | sdkmanager "build-tools;26.0.3" --sdk_root="$ANDROID_SDK"
  yes | sdkmanager "build-tools;27.0.3" --sdk_root="$ANDROID_SDK"
  yes | sdkmanager "build-tools;28.0.3" --sdk_root="$ANDROID_SDK"
  yes | sdkmanager "build-tools;29.0.1" --sdk_root="$ANDROID_SDK"

  printf "\n$SEPARATOR\n >>>>> INSTALL SOURCES\n"
  yes | sdkmanager "sources;android-24" --sdk_root="$ANDROID_SDK"
  yes | sdkmanager "sources;android-25" --sdk_root="$ANDROID_SDK"
  yes | sdkmanager "sources;android-26" --sdk_root="$ANDROID_SDK"
  yes | sdkmanager "sources;android-27" --sdk_root="$ANDROID_SDK"
  yes | sdkmanager "sources;android-28" --sdk_root="$ANDROID_SDK"
  #No sources for android-29
  yes | sdkmanager "sources;android-29" --sdk_root="$ANDROID_SDK"

  printf "\n$SEPARATOR\n >>>>> INSTALL DOCS\n"
  yes | sdkmanager "docs" --sdk_root="$ANDROID_SDK"

  printf "\n$SEPARATOR\n >>>>> INSTALL EMULATOR\n"
  yes | sdkmanager "emulator" --sdk_root="$ANDROID_SDK"

  printf "\n$SEPARATOR\n >>>>> INSTALL IMAGES\n"
  yes | sdkmanager "system-images;android-24;google_apis_playstore;x86" --sdk_root="$ANDROID_SDK"
  yes | sdkmanager "system-images;android-25;google_apis_playstore;x86" --sdk_root="$ANDROID_SDK"
  yes | sdkmanager "system-images;android-26;google_apis_playstore;x86" --sdk_root="$ANDROID_SDK"
  yes | sdkmanager "system-images;android-27;google_apis_playstore;x86" --sdk_root="$ANDROID_SDK"
  yes | sdkmanager "system-images;android-28;google_apis_playstore;x86" \
                   "system-images;android-28;android-wear;x86" --sdk_root="$ANDROID_SDK"
  yes | sdkmanager "system-images;android-29;google_apis_playstore;x86" --sdk_root="$ANDROID_SDK"

}

#https://dl.google.com/android/repository/sdk-tools-darwin-4333796.zip
VERSION_ANDROID_TOOLS=4333796
FILE_ANDROID_TOOLS="sdk-tools-$MY_OS-$VERSION_ANDROID_TOOLS.zip"
URL_ANDROID_TOOLS="https://dl.google.com/android/repository/$FILE_ANDROID_TOOLS"

exist_cmd sdkmanager || {
  down_uncompress "tools" "tools" "Android SDK Tools" "$FILE_ANDROID_TOOLS" "$URL_ANDROID_TOOLS" "$HOME/Android/Sdk"
  ANDROID_SDK_CONFIG=$(cat <<'EOF'
export ANDROID_SDK="$HOME/Android/Sdk"
export ANDROID_SDK_HOME="$ANDROID_SDK"
export ANDROID_SDK_ROOT="$ANDROID_SDK"
export ANDROID_TOOLS="$ANDROID_SDK/tools"
export ANDROID_PLATFORM_TOOLS="$ANDROID_SDK/platform-tools"
export PATH="$ANDROID_PLATFORM_TOOLS:$ANDROID_TOOLS:$ANDROID_TOOLS/bin:$PATH"
EOF
);
  find_append $MY_SH_CFG_FILE "ANDROID_SDK_HOME=" "$ANDROID_SDK_CONFIG"
  source $MY_SH_CFG_FILE
  echo
  which sdkmanager
  echo

  mkdir -p $ANDROID_SDK/.android/
  ANDROID_REPO_PREFIX="### User Sources for Android SDK Manager"
  ANDROID_REPOSITORIES="$ANDROID_REPO_PREFIX\n# $(date "+%a %b %d %T %Z %Y") count=0\n"
  printf "\n===> ANDROID repositories.cfg\n$ANDROID_REPOSITORIES ----\n\n"
  find_append $ANDROID_SDK/.android/repositories.cfg "$ANDROID_REPO_PREFIX" "$ANDROID_REPOSITORIES"

  install_android_packages;
}

(is_false $to_update || [ $INSTALL_ANDROID_PACK = "0" ] ) || {
  install_android_packages;
}

is_true $to_update && {
  printf "\n$SEPARATOR\n >>>>> UPDATE INSTALLED PACKAGES\n";
  sdkmanager --update --sdk_root="$ANDROID_SDK";
}

printf "\n\n:: $SEPARATOR\n JAVA: "
java -version 
printf ":: $SEPARATOR\n MVN: "
mvn -version
printf ":: $SEPARATOR\n Gradle: "
gradle -version
printf ":: $SEPARATOR\n Android SDK Manager: "
sdkmanager --version
printf ":: $SEPARATOR\n "
echo
