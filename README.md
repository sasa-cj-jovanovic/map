# Mini Audio Player

MAP is raspberry pi server written in node.js, with web/mobile client written in angular/cordova for playing local audio/video collections on raspberry pi.
Development is planned to be run on Linux, preferably using gnome desktop environment.

### Development Installation

To install app for development purpose please run these commands from the terminal (in the folder you wish to install app to):

    ```
    git clone https://github.com/sasa-cj-jovanovic/map.git
    cd map
    git clone https://github.com/sasa-cj-jovanovic/mini-audio-player.git
    git clone https://github.com/sasa-cj-jovanovic/mini-audio-player-server.git
    git clone https://github.com/sasa-cj-jovanovic/mini-audio-player-cordova.git
    git clone https://github.com/sasa-cj-jovanovic/command-prompt-utilities.git

    ```

### Quick development start

To quickly run app in development mode, please run this in the terminal from the folder where mini audio player is installed:

    ```
    ./dev-demo.sh
    ```

After running above command all libraries should be installed, folders installed and configuration updated. Also if you run gnome 2 terminals should be open with node server running server and client app, also 2 web tabs should be engaged running info and client app.

## Steps to build the server

1.  Install node.js. For your particular system please visit https://nodejs.org/en/download/

2.  Install angular client. On the development machine, where you have source files, please run in the terminal:

    ```
    npm install -g @angular/cli
    ```

3.  Edit file `configuration.json` located in `mini-audio-player-server\bin` folder following lines to suit your needs, and make sure production is set to true

4.  Compile 'mini auto player server' project. From the `mini-auto-player-server` folder please run in the terminal:

    ```
    npm install
    npm run compile-once
    ```

5.  Compile the gui. From the `mini-audio-player` folder run in the terminal:

    ```
    npm install
    ng build --prog
    ```

    Clean server's `bin\gui` folder. Please note that you can find in that folder file named `lists-db.json`, that will
    contain your playlists so it is good idea to backup it up.

    Copy content of the gui `dist\mini-audio-player` folder in the server's `bin\gui` folder

    NOTE: previous step may be accomplished by running `build.sh` from the same folder.

6.  Delete the file named `lists-db.json` if you want to start with new play lists or replace it with the existing file from the backup.

7.  Copy folder `bin` to somewhere at the production server

8.  On the production server in order to have player on the server side:

    - install node as described in step #1 if necessary
    - on the production `server` folder please run in the terminal:

    ```
    npm install
    ```

    then create folder `movies` and make it read/write for anyone

    ```
    mkdir movies
    chmod 777 movies
    ```

9.  Install vlc player with all recent codecs. `https://wiki.videolan.org/`

10. Install sox `http://sox.sourceforge.net/`

11. Install equalizer. For installation instruction please visit this page:
    Content on that page is correct except they missed to tell you that you need to authorize all users to use mixer file `/home/pi/.alsaequal.bin`. To do so please run in terminal a following:

    ```
    sudo chmod 666 /home/pi/.alsaequal.bin
    ```

12. Edit `start.sh` form the `mini-audio-player-server` in the `bin` folder and edit line

    ```
    cd /map/server
    ```

    to point to your server folder. There are some additional lines in there e.g. to set master volume to desirable level after restart, so if you do not need them fell free to delete them.

13. To run a server you need to execute from from the terminal:

    ```
    node index.js
    ```

    or

    ```
    ./start.sh
    ```

    **NOTE: if you are running into a problems using prot 80 on a server do this:**

    ```
      sudo apt-get install libcap2-bin
    ```

    ```
      sudo setcap cap_net_bind_service=+ep `readlink -f \`which node\``
    ```

14. If you are installing on the raspbian open file manager open menu `Edit->Preferences` then tab `Volume Management` and un tick checkbox `Show available options for removable media when they are inserted`

15. Mini audio player is using vlc as a backend player and node.js as web server so you can run to some issues with file/folder naming. To avoid issues please do not use dots.

    If you plan to have central audio library with names that comply with dots you can use `copy-tracks.js` located in the `mini-audio-player-server\bin` folder to safely copy files over the internet or locally by running from the terminal:

    ```
    node copy-tracks.js
    ```

16. If you have issues with building lists/external media/media DBs you can safely delete all `*-db.json` files located in the `mini-audio-player-server\bin`.

    NOTE: do NOT delete `configuration.json` file.

17. To deploy all compiled parts you can use `deploy.js` located at root by running from the terminal:

    ```
    deploy.ts
    ```

    be sure that these lines in the above file, comply with your network configuration:

    ```
    const HOST = '192.168.0.80';
    const USER_NAME = 'pi';
    const SERVER_FOLDER = '/map/server/';
    const SERVER_FOLDER_UP = '/map/';
    ```

18. To do backup execute in the terminal this command

    ```
    wget 192.168.0.84/backup
    ```

    Please use your server IP. After command have finish you will backup file with all backup data as json.

## Fix to set flac files seekable

Please note that that flac files may missing seek table. So to relax server as much as possible, and to have files seekable this needs to be done once not dynamically on the server side, especially if your server machine is raspberry pi, to which originally this software was written to.

So to fix flac files to be seekable you need to:

1. first you need to install flac pacakge for
   ```
   sudo apt-get install flac
   ```
2. then you need to use metaflac like this

   ```
   metaflac --add-seekpoint=1s filename.flac
   ```

   or fro all files in the folder

   ```
   metaflac --add-seekpoint=1s *
   ```

   that will add 1s seek table to the file. You can automate above the job in bulk by issuing the command:

   ```
      node add-flac-seek-table-1s.js /folder/folder
   ```

   from the `command-prompt-utilities` folder where `/folder/folder` must point to your audio collection.

   Not that a very fast machine is needed, or be prepared prepare to wait a lot.

### NOTE: Mini audio player can be used on any other OS with possible a little modification

#### That's all folks CJ
