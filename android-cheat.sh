show_menu(){
  clear
  echo "BASH Script for android stuff..."

  echo "1. Install Burp Cert"

  echo "2. Install Required Lib"

  echo "3. Downlad Files"

  echo "4. Install APK To Mobile"

  echo "5. Install .deb Files"

  echo "6. Move and Unzip Files"

  echo "7. Exit"

}

options(){
  show_menu
  local choice
  read -p "Enter a choice: " choice
  case $choice in
    # To push the burp cerf to mobile, cant automate renaming of the cerf in mobile.
    1) echo "Installing burp Cerf"
    export http_proxy="http://127.0.0.1:8080"
    wget "http://burp/cert"
    mv cert cacert.cert
    adb push cacert.cer /sdcard/cacert.cef
    export http_proxy=
    sleep 2s
    options;
    echo "Done..Or Not." ;;

    # Installing the lib required to use drozer.
    2) echo "Installing Libs"
    apt-get install python-protobuf
    echo "Done"
    sleep 1s
    options;;

    # Downloads the files we need.
    3) echo "Download Files"
    if test -f "drozer-agent-2.3.4.apk"; then
      echo "Skipping"
    else
    wget 'https://github.com/mwrlabs/drozer/releases/download/2.3.4/drozer-agent-2.3.4.apk';
  fi

    if test -f 'drozer_2.3.4.deb'; then
    echo "Skipping .deb"
  else
    wget 'https://github.com/mwrlabs/drozer/releases/download/2.3.4/drozer_2.3.4.deb';
  fi

    if test -f "apktool_2.2.1.jar"; then
      echo "Skipping Apktool.jar"
    else
    wget "https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.2.1.jar";
  fi

    if test -f "download"; then
      echo "dex2jar exists, Skipping"
    else
    wget "https://sourceforge.net/projects/dex2jar/files/dex2jar-2.0.zip/download";
  fi

    clear
    echo "Done"
    options ;;
    # iNSTALLING APK'S TO MOIBLE DEVICE.
    4) echo "Install APK to Mobile"
    adb install drozer-agent-2.3.4.apk
    adb forward tcp:31415 tcp:31415
    drozer console connect;
    echo "APK Pushed"
    sleep 2s
    options ;;
    # INSTALLING DEB Files
    5) echo "Install .deb Files"
    dpkg -i drozer_2.3.4.deb
    echo "Installed"
    options ;;
    # Moving and unzip files required for use..
    6) echo "Move and unzip Files"
    # This is moving the APKtool and Dex2Jar Files to be useable.
    mv apktool_2.2.1.jar apktool.jar
    cp apktool.jar /usr/local/bin
    chmod u+x /usr/local/bin/apktool*
    mv download dex2jar.zip
    echo "unzipping"
    unzip dex2jar.zip
    echo "done"
    options ;;
    # exit
    7) echo "Goodbye"
    exit 0;;
    # Checking..
    *) echo -n "Not a Vaild Input.."
    options
  esac
}




echo "Checking for emulator or avd"
adb devices | while read line
do
    # if it's not empty, use the next line
    if [ ! "$line" = "" ] && [ `echo $line | awk '{print $2}'` = "device" ];
    then
      echo $line
        # assign device variable to the result of printing the first token
        device=`echo $line | awk '{print $1}'`
        echo "$device $@ Is up"
      fi
    done
  options
