#!/bin/bash

# Modified version of a nginx site enable/disable script

# Credit to Ghassen Telmoudi - https://serverfault.com/a/562210
# For making the original nginx enable/disable site script

##
# VAR
##

LE_DIR="/etc/letsencrypt"
LE_CERTS_LIVE="$LE_DIR/live"
SELECTED_CERT="$2"

##
# MAIN FUNC
##

le_delete_cert() {
#    le_select_cert
#    echo "test"

    [[ ! "$SELECTED_CERT" ]] &&
        le_select_cert "is_live"

    [[ ! -e "$NGINX_SITES_AVAILABLE/$SELECTED_SITE" ]] &&
        le_error "Cert does not appear to exist."

    echo -e "Removing:"
    echo -e "\t/etc/letsencrypt/live/${SELECTED_CERT}"
    echo -e "\t/etc/letsencrypt/archive/${SELECTED_CERT}"
    echo -e "\t/etc/letsencrypt/renewal/${SELECTED_CERT}.conf"

    rm -rf /etc/letsencrypt/live/${SELECTED_CERT}
    rm -rf /etc/letsencrypt/archive/${SELECTED_CERT}
    rm -rf /etc/letsencrypt/renewal/${SELECTED_CERT}.conf
}


le_list_cert() {
    echo "Live Certs:"
    le_certs "live"
}

##
# HELPER FUNC
##

le_select_cert() {
    certs_live=($LE_CERTS_LIVE/*)
    cl="${certs_live[@]##*/}"

    case "$1" in
        is_live) certs=$(comm -13 <(printf "%s\n" $se) <(printf "%s\n" $cl));;
    esac
    
    le_prompt "$certs"
}

le_prompt() {
    certs=($1)
    i=0
    j=0

    filtered=()
    for value in "${certs[@]}"
    do
        [[ "${value}" != "README" ]] && filtered+=($value)
    done
    certs=("${filtered[@]}")
    unset filtered

    echo "SELECT A CERT:"
    for cert in ${certs[@]}; do
        echo -e "$i:\t${certs[$i]}"
        ((i++))
    done

    read -p "Enter number for cert: " i
    SELECTED_CERT="${certs[$i]}"
}

le_certs() {
    case "$1" in
        live) dir="$LE_CERTS_LIVE";;
    esac

    for file in $dir/*; do
        if [[ "${file#*$dir/}" != "README" ]]; then
            echo -e "\t${file#*$dir/}"
        fi
    done
}

le_error() {
    echo -e "${0##*/}: ERROR: $1"
    [[ "$2" ]] && le_help
    exit 1
}

le_help() {
    echo "Usage: ${0##*/} [options]"
    echo "Options:"
    echo -e "\t<-d|--delete> <cert>\tDelete cert"
    echo -e "\t<-l|--list>\t\tList certs"
    echo -e "\t<-h|--help>\t\tDisplay help"
    echo -e "\n\tIf <cert> is left out a selection of options will be presented."
    echo -e "\tIt is assumed you are using the default live certs"
    echo -e "\tlocation at $LE_CERTS_LIVE."
}

##
# Core Piece
##

case "$1" in
    -d|--delete)   le_delete_cert;;
    -l|--list)  le_list_cert;;
    -h|--help)  le_help;;
    *)      le_error "No Options Selected" 1; le_help;;
esac
