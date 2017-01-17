#!/bin/bash
VERSION="0.2.1"; # <release>.<major change>.<minor change>
PROGNAME="Enumration Script";
AUTHOR="R3zk0n";

##########################################################################
## Pipeline:
## TODO: Loop IP Addresses
##########################################################################

##########################################################################
# XXX: Coloured variables
##########################################################################
red=`echo -e "\033[31m"`
lcyan=`echo -e "\033[36m"`
yellow=`echo -e "\033[33m"`
green=`echo -e "\033[32m"`
blue=`echo -e "\033[34m"`
purple=`echo -e "\033[35m"`
normal=`echo -e "\033[m"`

##########################################################################
# XXX: Configuration
##########################################################################

declare -A EXIT_CODES

EXIT_CODES['unknown']=-1
EXIT_CODES['ok']=0
EXIT_CODES['generic']=1
EXIT_CODES['limit']=3
EXIT_CODES['missing']=5
EXIT_CODES['failure']=10

DEBUG=0
param=""

##########################################################################
# XXX: Help Functions
##########################################################################
show_usage() {
        echo -e """Enumration Script\n
        Usage: $0 <target> <port>
        \t-h\t\tshows this help menu
        \t-v\t\tshows the version number and other misc info
        \t-D\t\tdisplays more verbose output for debugging purposes
        \t-f\t\tRead IP's From File and runs the script."""

        exit 1
        exit ${EXIT_CODES['ok']};
}

show_version() {
        echo "$PROGNAME version: $VERSION ($AUTHOR)";
        exit ${EXIT_CODES['ok']};
}

debug() {
        # Only print when in DEBUG mode
        if [[ $DEBUG == 1 ]]; then
                echo $1;
        fi
}

err() {
        echo "$@" 1>&2;
        exit ${EXIT_CODES['generic']};
}

##########################################################################
# XXX: Initialisation and menu
##########################################################################
if [ $# == 0 ] ; then
        show_usage;
fi

while getopts :vhx opt
do
  case $opt in
  v) show_version;;
  h) show_usage;;
  *)  echo "Unknown Option: -$OPTARG" >&2; exit 1;;
  esac
done



# Make sure we have all the parameters we need (if you need to force any parameters)
#if [[ -z "$param" ]]; then
#        err "This is a required parameter";
#fi

##########################################################################
# XXX: Kick off
##########################################################################
header() {
        clear
        echo -e ${green}"""
----------------------------------
 $PROGNAME v$VERSION $AUTHOR
----------------------------------\n ${normal}"""
}

main() {

#need to Loop, IP file so its easy to use.


if [[ $2 = '443' ]];
  then
  echo ${red}'Running TLSSLED'${normal}
  tlssled $1 $2
fi


echo ${yellow}"Would you like to run DIRB > [Y/N]"${normal}
read DIRB
if [ $DIRB = 'Y' ];
then
  echo 'Running DIRB'
  dirb http://$1
fi

echo ${red}"Would like to continue?${normal}"
read continue
if [ $continue = 'Y' ];
then

  while read ip; do
    echo "$ip";
    
  echo ""
  echo ${red} "[====]...Nikto Scan..[====] ${normal}"
  nikto -h $ip
  echo -e '\n'


  echo ""
  echo ${green} "[=======] We're Going knocking.. [========]" ${normal}
  for ARG in "$@"
  do
    nmap -Pn --host_timeout 100 --max-retries 0 -p $ARG $ip
  done

  echo 'Running IKE SCAN '${lcyan} "[===] Version: IKE1 [===]" ${normal}
  ike-scan $ip
  echo -e '\n'

  echo 'Running IKE-SCAN'${lcyan} "[===] Version: IKE2 [===]" ${normal}
  ike-scan $ip --ikev2
  echo -e '\n'

  echo 'Running AGGRESSIVE'
  ike-scan $ip -aggressive
  echo -e '\n'
fi
  done < $1
  echo ${yellow}"Would you like to run GROUPENUM?'${normal} ${red} If you dont have the script, dont run."${normal}
  read GROUPENUM
  if [[ $GROUPENUM = 'Y' ]];
  then
   echo 'Running GROUPENUM'
   python ~/Github/groupenum/groupenum.py -w ~/Github/SecLists/Miscellaneous/ike-groupid.txt -t $1

 fi

fi
}

header
main "$@"

debug $param;
