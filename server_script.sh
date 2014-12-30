#!/bin/sh
#made by denellum 2014-11-07#
#v1.1#

#DEFINABLE VARIABLES#
#(You most likely will need to change these)#

#The ABSOLUTE path to your backup directory#
BACKUPpath="/home/minecraft/backups/"
#How many backups do you want#
BACKUPcount="36"
#The ABSOLUTE path to your minecraft directory#
MINECRAFTpath="/home/minecraft/vanilla/"
#What you called your screen session#
SCREENname="minecraft"
#Minecraft world name#
WORLDname="minecraft"
#Max Amount of RAM Java will use#
MAXram="3G"
#RAM Java will start off using#
STARTINGram="3G"
#Jar file name#
JARname="minecraft_server.jar"


#STATIC VARIABLES#
#(Only change these if you know what you're doing)#
#(The stuff in the quotes)#

#Variable for starting a screen with the screen defined name#
STARTscreen="screen -dmS $SCREENname"
#Variable for sending a screen command to the defined screen#
SCREENcommand="screen -S $SCREENname -p 0 -X stuff"
#Variable for starting Minecraft with the defined stats#
JAVAstart="java -Xmx$MAXram -Xms$STARTINGram -jar $JARname -o true nogui"
#Variable for the log path#
LOGpath="$MINECRAFTpath/logs/latest.log"
#Variable for a screen command to press enter#
SCREENenter="$(printf \\r)"
#Variable for the backups file name#
BACKUPname="$(date +%Y%m%d-%H%M).tar"


while [ "$1" != "" ]; do
    case $1 in
        #Starts the server on the defined screen#
        -start )
			$STARTscreen
			sleep 5
                        $SCREENcommand "cd $MINECRAFTpath$SCREENenter"
			sleep 5
                        $SCREENcommand "$JAVAstart$SCREENenter"
                        sleep 15
                        tail -n1 $LOGpath
                        ;;
        #Stops the server on the defined screen#
        -stop )
                        $SCREENcommand "stop$SCREENenter"
                        ;;
        #Saves the server on the defined screen#
        -save )
                        $SCREENcommand "say §a---Saving §aServer---$SCREENenter"
                        $SCREENcommand "save-all$SCREENenter"
                        sleep 5
                        $SCREENcommand "say §a---Save §aCompleted---$SCREENenter"
                                ;;
                #Backs up the server on the defined screen#
        -backup )
                        $SCREENcommand "say Â§a---Beginning Â§aBackup---$SCREENenter"
                        $SCREENcommand "say Â§b---Please Â§bWait---$SCREENenter"
                        sleep 5
                        cd $BACKUPpath
                        sleep 5
                        (ls -t|head -n 36;ls)|sort|uniq -u|sed -e 's,.*,"&",g'|xargs rm
                        sleep 10
                        cd $MINECRAFTpath
                        tar -cf "$BACKUPpath$BACKUPname" $WORLDname/
                        sleep 10
                        $SCREENcommand "say Â§a---Backup Â§aCompleted---$SCREENenter"
                        ;;
        #Restarts the server on the defined screen#
        -restart )
                        $SCREENcommand "say Â§a---Server Â§aWill Â§aReboot Â§aIn Â§a5 Â§aMinutes---$SCREENenter"
                        sleep 295
                        $SCREENcommand "say Â§a---Server Â§aWill Â§aReboot Â§aIn Â§a5 Â§aSeconds---$SCREENenter"
                        $SCREENcommand "say Â§b---Please Â§bWait Â§bAbout Â§b2 Â§bMinutes$SCREENenter"
                        sleep 5
                        $SCREENcommand "stop$SCREENenter"
                        sleep 60
                        $SCREENcommand "cd $MINECRAFTpath$SCREENenter"
                        sleep 5
                        $SCREENcommand "$JAVAstart$SCREENenter"
                        sleep 15
                        tail -n1 $LOGpath
                        ;;
        #Saves the server on the defined screen#
        -save )
                        $SCREENcommand "say Â§a---Saving Â§aServer---$SCREENenter"
                        $SCREENcommand "save-all$SCREENenter"
                        sleep 5
                        $SCREENcommand "say Â§a---Save Â§aCompleted---$SCREENenter"
                        ;;
        #Sends the map updater warning# 
        -minecraftoverviewer )
                        $SCREENcommand "say Â§a---Server Â§aMay Â§aLag Â§aCurrently Â§aUpdating Â§aMap---$SCREENenter"
                        exit
                        ;;
        #Lists all the commands in this script#
        -help )
                        echo "Valid commands :";
                        echo "-start ~ starts the world with predefined settings.";
                        echo "-stop ~ stops the world.";
                        echo "-backup ~ backs up the world to backup directory";
                        echo "-restart ~ restarts the world with predefined settings";
                        echo "-minecraftoverviewer ~ submits the message for the map updating";
                       echo "-save ~ simply saves the world";
                        exit
                        ;;
	#If you ran a command that wasn't here... lets give you help#
        * )
                        echo "try -help"
                        exit 1
        esac
        shift
done
