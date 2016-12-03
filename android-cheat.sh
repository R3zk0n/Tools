
echo "Start a AVD Or emulator.."
adb devices | while read line
do
    # if it's not empty, use the next line
    if [ ! "$line" = "" ] && [ `echo $line | awk '{print $2}'` = "device" ];
    then
      echo $line
        # assign device variable to the result of printing the first token
        device=`echo $line | awk '{print $1}'`
        echo "$device $@ Is up"
        echo "Starting Setup progress.."
        echo "Please "
        sleep 10s
        echo "Installing required libs.."
        apt-get install python-protobuf
        apt-get install -f install
        # Setting proxy for cerf
        export http_proxy="http://127.0.0.1:8080"
        wget "http://burp/cert"
        echo "Installing burp cerf.."
        mv cert cacert.cer
        adb push cacert.cer /sdcard/cacert.cer
        clear;
        export http_proxy=
        echo "Downloading required files"
        if test -f "drozer-agent-2.3.4.apk"; then
        echo "File Exists..skipping drozer-apk"
      else
        echo "Downloading drozer-agent file."
        wget 'https://github.com/mwrlabs/drozer/releases/download/2.3.4/drozer-agent-2.3.4.apk'
        adb install drozer-agent-2.3.4.apk;fi
        clear;
        echo "Drozer Routine."
        adb forward tcp:31415 tcp:31415
        sleep 5s
        drozer console connect
        if test -f "drozer_2.3.4.deb"; then
          echo "File Exists..Skipping drozer.deb package"
        else
          echo "Download drozer deb package.."
        wget 'https://github.com/mwrlabs/drozer/releases/download/2.3.4/drozer_2.3.4.deb'
        dpkg -i drozer_2.3.4.deb;fi
        if test -f "apktool_2.2.1.jar"; then
          echo "File Exists Skipping apktool.jar"
        else
        wget "https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.2.1.jar";fi
        mv apktool_2.2.1.jar apktool.jar
        cp apktool.jar /usr/local/bin
        chmod u+x /usr/local/bin/apktool*
        if test -f "dex2jar-2.0.zip"; then
          echo "File Exists skipping dex2jar"
        else
        wget "https://sourceforge.net/projects/dex2jar/files/dex2jar-2.0.zip/download";fi
        mv download dex2jar.zip
        echo "unzipping dex2jar"
        unzip dex2jar.zip
      fi
done
