node=$(which node)
if [ "$node" == '' ];
then
    echo Please install node.js first
    exit
fi;

cordova=$(which cordova)
if [ "$cordova" == '' ];
then
    echo Please install cordova first
    exit
fi;

VLC=$(which vlc)
if [ "$VLC" == '' ];
then
    echo Please install vlc player first
    exit
fi;

[ ! -d "server-backups" ] && mkdir server-backups

read -p "You may lose your data, please backup your server json files. Do you want to continue [N/y]?" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo 
    cd ./command-prompt-utilities
    ./init.sh
    cd ../mini-audio-player-server
    ./init.sh rebuild
    cd ../mini-audio-player
    ./init.sh
    cd ../mini-audio-player-cordova
    ./init.sh    
fi

