#!/bin/bash
#
###################################################################
#                       GENERATED FOR Nagios                      #
#                                                                 #
#                  check_fwm_ha,  Version : 1.0.1                 #
#       Licence : GPL - http://www.gnu.org/licenses/gpl.txt      #
#                                                                 #
#               Developped: Eric Herve Tchouamou                  #
#               For information : tchouamou@gmail.com             #
#                                                                 #
#               Last modification March 1, 2014                   #
#                                                                 #
###################################################################



#------------------------------------------------------------------------------
if [ -z $1 ]; then
 echo "USAGE: check_fwm_ha.sh [ [-d] -C COMMUNITY -H HOST_IP -m actif/standby | -h Help ]"
 exit 1
fi

while getopts ":C:H:m:h" option; do
        case $option in
                H) host=$OPTARG
                        ;;
                C) comunity=$OPTARG
                        ;;
                d) set -x
                        ;;
                m) ha_mode=$OPTARG
                        ;;
                h) echo "USAGE: check_fwm_ha.sh [ [-d] -C COMMUNITY -H HOST_IP -m actif/standby | -h Help ]"
                exit 0
                        ;;
                *) echo "USAGE: check_fwm_ha.sh [-d] -C COMMUNITY -H HOST_IP -m actif|standby"
                exit 1
                        ;;
        esac
done
#------------------------------------------------------------------------------
resultat=$(snmpget -v 2c -Cf -Ovq -c $comunity $host 1.3.6.1.4.1.2620.1.7.5.0 2>/dev/null)
#echo "host=$host, comunity=$comunity, ha_mode=$ha_mode, resultat=$resultat"
#------------------------------------------------------------------------------

if [[ $resultat == "\"$ha_mode\"" ]]; then
 echo "$host mode ($ha_mode): OK"
 exit 0
elif [[ $resultat != "" ]]; then
 echo "$host mode ($ha_mode): NOK - HA CHANGED!!!"
 exit 2
else
 echo "$host mode: UNKNOWN"
 exit 1
fi
#------------------------------------------------------------------------------

exit 1
