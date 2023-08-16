#!/bin/bash
CUR_DIR=

get_cur_dir() {
        # Get the fully qualified path to the script
        case $0 in
        /*)
                SCRIPT="$0"
                ;;
        *)
                PWD_DIR=$(pwd);
                SCRIPT="${PWD_DIR}/$0"
                ;;
        esac
        # Resolve the true real path without any sym links.
        CHANGED=true
        while [ "X$CHANGED" != "X" ]
        do
        # Change spaces to ":" so the tokens can be parsed.
        SAFESCRIPT=`echo $SCRIPT | sed -e 's; ;:;g'`
        # Get the real path to this script, resolving any symbolic links
        TOKENS=`echo $SAFESCRIPT | sed -e 's;/; ;g'`
        REALPATH=
        for C in $TOKENS; do
                # Change any ":" in the token back to a space.
                C=`echo $C | sed -e 's;:; ;g'`
                REALPATH="$REALPATH/$C"
                # If REALPATH is a sym link, resolve it.  Loop for nested links.
                while [ -h "$REALPATH" ] ; do
                LS="`ls -ld "$REALPATH"`"
                LINK="`expr "$LS" : '.*-> \(.*\)$'`"
                if expr "$LINK" : '/.*' > /dev/null; then
                        # LINK is absolute.
                        REALPATH="$LINK"
                else
                        # LINK is relative.
                        REALPATH="`dirname "$REALPATH"`""/$LINK"
                fi
                done
        done


        if [ "$REALPATH" = "$SCRIPT" ]
        then
                CHANGED=""
        else
                SCRIPT="$REALPATH"
        fi
        done
        # Change the current directory to the location of the script
        CUR_DIR=$(dirname "${REALPATH}")
        echo "current dir $CUR_DIR"
}

install_docker(){
    get_cur_dir
    tar -xvf $CUR_DIR/docker-18.06.1-ce.tgz
    cp -rp $CUR_DIR/docker/* /usr/bin/
    cp -rp $CUR_DIR/docker.service /etc/systemd/system/
	mkdir -p /etc/docker/
	cp -rp $CUR_DIR/daemon.json /etc/docker/
    mkdir -p /home/docker-data
    chmod +x /etc/systemd/system/docker.service
    systemctl daemon-reload
    systemctl start docker
    systemctl enable docker.service
    systemctl status docker
    docker -v
    cp $CUR_DIR/docker-compose /usr/local/bin/
    chmod 777 /usr/local/bin/docker-compose
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    docker-compose --version
}

case $1 in
        install)
                install_docker
                ;;
        *)
                install_docker
                ;;
esac