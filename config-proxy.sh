#!/bin/bash

SEPARATOR="======================================================"
echo "========================================="
echo "NETWORK PROXY CONF"
echo "========================================="

scape_str_replace(){
    safe_replacement=$(printf '%s' "$1" | sed 's/[\&/]/\\&/g')
    echo "$safe_replacement"
}

proxy=true
host="$DEF_PROXY_HOST"
port="$DEF_PROXY_PORT"
excep="$DEF_NO_PROXY"

if [ $# -eq 0 ] || [ -z "$1" ]; then
    echo "No arguments supplied or incompleted"
    read -p "You want use proxy config? (y/n) > " proxy
else
    proxy="$1"
fi
proxy=${proxy,,}

if [ "$proxy" = true ] || [ "$proxy" = "true" ] || [ "$proxy" = "1" ] || [ "$proxy" = "y" ]|| [ "$proxy" = "yes" ]; then
    export USE_PROXY=true
else
    export USE_PROXY=false
fi

if [ "$USE_PROXY" = true ]; then
    if [ $# -eq 0 ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
        echo "No arguments supplied or incompleted"
        read -p "Enter HOST (default: '$host') > " ihost
        [ ! -z "$ihost" ] && host=$ihost
        read -p "Enter PORT (default: '$port') > " iport
        [ ! -z "$iport" ] && port=$iport
        read -p "Enter EXCEP (default: '$excep') > " iexcep
        [ ! -z "$iexcep" ] && port=$iexcep
    else
        host="$2"
        port="$3"
        excep="$4"
    fi
fi

export PROXY_HOST=$host
export PROXY_PORT=$port
export HTTP_PROXY=$(scape_str_replace "http://$PROXY_HOST:$PROXY_PORT/")
export HTTPS_PROXY="$HTTP_PROXY"
export NO_PROXY=$excep

#/etc/environment
#~/.subversion/servers
export SVN_PROXY=true
#/etc/default/docker
#/etc/systemd/system/docker.service.d/http-proxy.conf
export DOCKER_PROXY=true

echo 
echo $SEPARATOR
printf "\t\t SYSTEM PROXY ................. $USE_PROXY\n"
printf "   host=$PROXY_HOST, \tport=$PROXY_PORT, \texceptions=$NO_PROXY\n"

cfile=/etc/environment
if [ ! -f "$cfile" ]; then
    sudo touch $cfile
fi
echo "svn file ($cfile) replacing proxy info"
if [ "$USE_PROXY" = true ] ; then
    
    export http_proxy="$HTTP_PROXY"
    export https_proxy="$HTTP_PROXY"
    export no_proxy="$NO_PROXY"


    if ! grep -q "HTTP_PROXY" "$cfile"; then
        echo "export HTTP_PROXY=\"$HTTP_PROXY\"" | sudo tee --append $cfile
        echo "export http_proxy=\"$HTTP_PROXY\"" | sudo tee --append $cfile
    else
        sudo sed -i -r "s/.*HTTP_PROXY\s?=\s?.*/export HTTP_PROXY=\"$HTTP_PROXY\"/g" $cfile
        sudo sed -i -r "s/.*http_proxy\s?=\s?.*/export http_proxy=\"$HTTP_PROXY\"/g" $cfile
    fi
    if ! grep -q "HTTPS_PROXY" "$cfile"; then
        echo "export HTTPS_PROXY=\"$HTTPS_PROXY\"" | sudo tee --append $cfile
        echo "export https_proxy=\"$HTTPS_PROXY\"" | sudo tee --append $cfile
    else
        sudo sed -i -r "s/.*HTTPS_PROXY\s?=\s?.*/export HTTPS_PROXY=\"$HTTPS_PROXY\"/g" $cfile
        sudo sed -i -r "s/.*https_proxy\s?=\s?.*/export https_proxy=\"$HTTPS_PROXY\"/g" $cfile
    fi
    if ! grep -q "NO_PROXY" "$cfile"; then
        echo "export NO_PROXY=\"$NO_PROXY\"" | sudo tee --append $cfile
        echo "export no_proxy=\"$NO_PROXY\"" | sudo tee --append $cfile
    else
        sudo sed -i -r "s/.*NO_PROXY\s?=\s?.*/export NO_PROXY=\"$NO_PROXY\"/g" $cfile
        sudo sed -i -r "s/.*no_proxy\s?=\s?.*/export no_proxy=\"$NO_PROXY\"/g" $cfile
    fi

    sudo sed -i -r "s/^\s*unset HTTP_PROXY HTTPS_PROXY NO_PROXY/# \0/gi" $cfile
else
    if ! grep -q "unset HTTP_PROXY HTTPS_PROXY NO_PROXY" "$cfile"; then
        #echo 'deb blah ... blah'  /etc/apt/sources.list
        echo "" | sudo tee --append $cfile
        echo "unset HTTP_PROXY HTTPS_PROXY NO_PROXY" | sudo tee --append $cfile
        echo "unset http_proxy https_proxy no_proxy" | sudo tee --append $cfile
    else
        sudo sed -i -r "s/.*unset HTTP_PROXY HTTPS_PROXY NO_PROXY/unset HTTP_PROXY HTTPS_PROXY NO_PROXY/gi" $cfile
    fi

    sudo sed -i -r 's/((export)?\s*HTTP_PROXY\s?=\s?.*)/# \0/gi' $cfile
    sudo sed -i -r 's/((export)?\s*HTTPS_PROXY\s?=\s?.*)/# \0/gi' $cfile
    sudo sed -i -r 's/((export)?\s*NO_PROXY\s?=\s?.*)/# \0/i' $cfile
fi

source $cfile

echo
echo $SEPARATOR
printf "\t\tSVN\n"

cfile=~/.subversion/servers
if [ "$USE_PROXY" = true ] && [ "$SVN_PROXY" = true ]; then
    if [ -f "$cfile" ] ; then
        echo "svn file ($cfile) replacing proxy info"

        sed -i "/\[.*\]/h
        /http-proxy-exceptions/{x;/\[global\]/!{x;b;};x;c\
        http-proxy-exceptions = ${NO_PROXY}
        }
        /http-proxy-host/{x;/\[global\]/!{x;b;};x;c\
        http-proxy-host = ${PROXY_HOST}
        }
        /http-proxy-port/{x;/\[global\]/!{x;b;};x;c\
        http-proxy-port = ${PROXY_PORT}
        }" $cfile

    else
        echo "svn file ($cfile) creation for proxy"
        touch $cfile
        echo "" > $cfile
        echo "[global]" >> $cfile
        echo "http-proxy-host\"$PROXY_HOST\"" >> $cfile
        echo "http-proxy-port=\"$PROXY_PORT\"" >> $cfile
        echo "http-proxy-exceptions=\"$NO_PROXY\"" >> $cfile
    fi
elif [ "$USE_PROXY" = false ] && [ -f "$cfile" ]; then
    echo "svn file ($cfile) clean proxy"
    sed -i -r 's/^\s*http-proxy-host\s?=\s?.*/# \0/' $cfile
    sed -i -r 's/^\s*http-proxy-port\s?=\s?.*/# \0/' $cfile
    sed -i -r 's/^\s*http-proxy-exceptions\s?=\s?.*/# \0/' $cfile
fi

echo
echo $SEPARATOR
printf "\t\tDOCKER\n"
cfile=/etc/systemd/system/docker.service.d/http-proxy.conf
if [ "$USE_PROXY" = true ] && [ "$DOCKER_PROXY" = true ]; then

    # if [ ! -f "/etc/default/docker" ]; then
    #     sudo touch $cfile
    # fi
    # if [ -f "/etc/default/docker" ] ; then
    #     if ! grep -q "export http_proxy" /etc/default/docker; then
    #         echo "" > /etc/default/docker
    #         echo "export http_proxy=\"$HTTP_PROXY\"" >> /etc/default/docker
    #         echo "export https_proxy=\"$HTTP_PROXY\"" >> /etc/default/docker
    #         echo "export no_proxy=\"$NO_PROXY\"" >> /etc/default/docker
    #     fi
    # fi

    
    if [ ! -d "/etc/systemd/system/docker.service.d" ] ; then
        sudo mkdir -p /etc/systemd/system/docker.service.d
    fi

    if [ ! -f "$cfile" ]; then
        echo "svn file ($cfile) creation for proxy"
        DOCKER_PROXY_CONF="[Service]\nEnvironment=\"HTTP_PROXY=$HTTP_PROXY\" \"HTTPS_PROXY=$HTTPS_PROXY\" \"NO_PROXY=$NO_PROXY\" \n"
        printf "$DOCKER_PROXY_CONF" | sudo tee $cfile
    # else
    #     echo "docker file ($cfile) replacing proxy info"

    #     sudo sed -i "/\[.*\]/h
    #     /HTTP_PROXY/{x;/\[Service\]/!{x;b;};x;c\
    #     HTTP_PROXY = \"${HTTP_PROXY}\"
    #     }
    #     /HTTPS_PROXY/{x;/\[Service\]/!{x;b;};x;c\
    #     HTTPS_PROXY = \"${HTTPS_PROXY}\"
    #     }
    #     /NO_PROXY/{x;/\[Service\]/!{x;b;};x;c\
    #     NO_PROXY = \"${NO_PROXY}\"
    #     }" $cfile
    fi
elif [ "$USE_PROXY" = false ] && [ -f "$cfile" ]; then
    echo "docker file ($cfile) clean proxy"
    #sed -i -r 's/("HTTP_PROXY=).*(".*)/\1\2/U' $cfile
    #sed -i -r 's/("HTTPS_PROXY=).*(".*)/\1\2/U' $cfile
    #sed -i -r 's/("NO_PROXY=).*(".*)/\1\2/U' $cfile

    # sudo perl -p -i -e 's/("HTTP_PROXY=).*(".*)/\1\2/ic' $cfile
    # sudo perl -p -i -e 's/("HTTPS_PROXY=).*(".*)/\1\2/ic' $cfile
    # sudo perl -p -i -e 's/("NO_PROXY=).*(".*)/\1\2/ic' $cfile

    # sudo sed -i "/\[.*\]/h
    #     /HTTP_PROXY/{x;/\[Service\]/!{x;b;};x;c\
    #     HTTP_PROXY = \"${HTTP_PROXY}\"
    #     }
    #     /HTTPS_PROXY/{x;/\[Service\]/!{x;b;};x;c\
    #     HTTPS_PROXY = \"${HTTPS_PROXY}\"
    #     }
    #     /NO_PROXY/{x;/\[Service\]/!{x;b;};x;c\
    #     NO_PROXY = \"${NO_PROXY}\"
    #     }" $cfile
fi

if [ -f "$cfile" ]; then
    cat $cfile
else
    echo "$cfile NOT EXIST"
fi

if [ "$DOCKER_PROXY" = "pepe" ]; then
    echo "RELOAD DOCKER"
    sudo systemctl daemon-reload
    sudo systemctl show --property=Environment docker
    sudo systemctl restart docker

    sudo docker rmi -f hello-world
    sudo docker pull hello-world
fi

