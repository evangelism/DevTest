#!/bin/bash
#
#  Prerequisites for this script: wput & jq utils:
#  Run:
#   $ sudo apt-get install wput jq
#
#  Script usage example:
#   $ ./ftp-upload.sh <parameter_file_dir> <application_dir>
#

if [[ !("$#" -eq 2) ]]; 
    then echo "Parameters are missing!" >&2
    exit 1
fi

# If password contains any special characters
urlencode() {
    # urlencode <string>
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c"
        esac
    done
}

remove_quotes() {
    local string=${1#$"\""}
    echo ${string%$"\""}
}

# Parameters
parameter_file_dir=$1
application_dir=$2
parameter_file_path="${parameter_file_dir}/openWb.parameters.json"

ftp_username=$(remove_quotes $(cat ${parameter_file_path} | jq '.parameters.adminUsername.value'))
ftp_password=$(remove_quotes $(cat ${parameter_file_path} | jq '.parameters.adminPassword.value'))
vm_hostname=$(remove_quotes $(cat ${parameter_file_path} | jq '.parameters.webMachineName.value'))
ftp_hostname="${vm_hostname}.westeurope.cloudapp.azure.com"
ftp_remote_dir="/"

ENCODED_PASSWD=$(urlencode $ftp_password)
URL="ftp://${ftp_username}:${ENCODED_PASSWD}@${ftp_hostname}${ftp_remote_dir}"
BASENAME=$application_dir

# Removing .git directory
rm -rf $application_dir/.git/

# Uploading files to remote dir
wput --basename=${BASENAME} ${BASENAME} ${URL}

if [ $?  == 0 ];
 then
    echo "Succesfully uploaded..."
    exit 0
 else
    exit 1
fi