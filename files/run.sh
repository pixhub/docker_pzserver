#!/bin/bash

SERVER_FILES="/home/zomboid/Zomboid/Server"
DB="/home/zomboid/Zomboid/db"
START_SERVER="/home/zomboid/pz-server/start-server.sh"
PARAMS="-adminpassword $ADMIN_PASSWD -servername $SRV_NAME"
STEAMCMD="/home/zomboid/steamcmd/steamcmd.sh"
INSTALL_DIR="/home/zomboid/pz-server"
CONFIG_FILE="/home/zomboid/Zomboid/Server/servertest.ini"

fn_checkupdates () {
              $STEAMCMD +login anonymous \
                        +force_install_dir $INSTALL_DIR \
                        +app_update 380870 \
                        +quit
}

fn_setvars () {
              if [ ! -d $SERVER_FILES ]
                 then
                     mkdir /home/zomboid/Zomboid/Server
                     mv /servertest.ini /home/zomboid/Zomboid/Server/
              fi

              if [ ! -z $PORT ]
                 then
                     sed -i -e "s/DefaultPort=16261/DefaultPort=$PORT/g" $CONFIG_FILE
                     echo "$(cat $CONFIG_FILE | grep -IE '^DefaultPort=')"
                 else
                     echo "$(cat $CONFIG_FILE | grep -IE '^DefaultPort=')"
              fi

              if [ ! -z $PVP ]
                 then
                     sed -i -e "s/PVP=true/PVP=$PVP/g" $CONFIG_FILE
                     echo "$(cat $CONFIG_FILE | grep -IE '^PVP=')"
                 else
                     echo "$(cat $CONFIG_FILE | grep -IE '^PVP=')"
              fi

              if [ ! -z $MODS -a ! -z $MODS_ID ]
                 then
                     sed -i -e "s/Mods=/Mods=$MODS/g" $CONFIG_FILE
                     sed -i -e "s/WorkshopItems=/WorkshopItems=$MODS_ID/g" $CONFIG_FILE
                     echo "$(cat $CONFIG_FILE | grep -IE '^Mods=|^WorkshopItems=')"
                 else
                     echo "[WARNING]:Both MODS & MODS_ID must be specified. No MODS will be installed..."
                     echo "$(cat $CONFIG_FILE | grep -IE '^Mods=|^WorkshopItems=')"
              fi

              if [ -z $ADMIN_PASSWD ]
                 then
                     ADMIN_PASSWD="admin"
                 fi

              if [ -z $SRV_NAME ]
                 then
                     SRV_NAME="pz-server"
              fi
}

fn_startserver () {
              if [ ! -d $DB ]
                 then
                     $START_SERVER $PARAMS
                 else
                     $START_SERVER
              fi
}

echo "==> Checking for Updates"
fn_checkupdates
if [ $? = 0 ]
   then
       echo "==> The Server is Up to Date"
   else
       echo "==> An error occured, please resart the service"
       exit 1
fi

echo "==> Applying Server Settings"
fn_setvars
if [ $? = 0 ]
   then
       echo "==> Server Settings succefully applied"
   else
       echo "==> An error occured applying Server Settings"
       exit 1
fi

echo "==> Starting Server"
fn_startserver
if [ $? = 0 ]
   then
       echo "==> Server Started Succefully"
   else
       echo "==> Fail Starting Server"
       exit 1
fi
