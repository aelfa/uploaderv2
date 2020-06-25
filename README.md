# DOCKER UPLOADER

----

## INITIAL SETUP

```
mkdir -p /opt/uploader/keys
```

Copy your rclone file to ``/opt/uploader``
Use the following to fix the service file paths
```
(( RUNNING PLEX SERVER SAME HOST ))
```
Copy your PLEX - Preference.xml file to ```/opt/uploader/plex```
```sh
(( RUNNING PLEX SERVER SAME HOST ))
```


```sh
OLDPATH=/youroldpath/keys/
sed -i "s#${OLDPATH}#/config/keys/#g" /opt/uploader/rclone.conf
```
-----

## ENVS FOR THE SETUP

```
UPLOADS = can be used from 1 - 20
BWLIMITSET = 10 - 100
GCE = true or false for maxout the upload speed 
PLEX = true or false
TZ = for local timezone 
DISCORD_WEBHOOK_URL = for using Discord to track the Uploads
DISCORD_ICON_OVERRIDE = Discord Avatar 
DISCORD_NAME_OVERRIDE = Name for the Discord Webhook User
LOGHOLDUI = When Diacord-Webhook is not used, the Complete Uploads will stay there for the minutes you setup
PLEX_SERVER_IP="plex" = you can use IP and localhost and traefik_proxy part 
PLEX_SERVER_PORT="32400" = the plex port (! local accesible !)

```

-----

## SAMPLE FOR BWLIMITSET AND UPLOADS

```

BWLIMITSET  is set to 100
UPLOADS     is set to 10 

BWLIMITSET  / UPLOADS  = REAL UPLOADSPEED PER FILE

```

## IF PLEX AND DOCKER UPLOADER ARE ON THE SAME HOST

> **1. WHEN PLEX STREAMS ARE RUNNING :**

```

BWLIMITSET = see above 
PLEX_PLAYS = inside running command

BWLIMITSET / PLEX_PLAYS = UPLOADSPEED per file

```

> **2. NO PLEX STREAMS ARE RUNNING OR PLEX STREAMS < 2 :**

```

BWLIMITSET = see above
UPLOADS = see above 

BWLIMITSET / UPLOADS = UPLOADSPEED per file

```

-----


## VOLUMES


```

Folder for uploads              =  - /mnt/move:/move
Folder for config               =  - /opt/uploader:/config
Dolder for merged contest       =  - /mnt/<pathofmergerfsrootfolder>:/unionfs

```

-----


## PORTS


```

PORT A ( HOST )      = 7777
PORT B ( CONTAINER ) = 8080

```

-----


## UPLOADER

Uploader will look for remotes in the ``*rclone.conf*``
starting with ``PG``, ``GD``, ``GS`` to upload with

> **DEFAULT FILES TO BE IGNORED BY UPLOADER:**

```

! -name '*partial~'
! -name '*_HIDDEN~'
! -name '*.fuse_hidden*'
! -name '*.lck'
! -name '*.version'

```

> **DEFAULT PATHS TO BE IGNORED BY UPLOADER:**

```

! -path '.unionfs-fuse/*'
! -path '.unionfs/*'
! -path '*.inProgress/*'
! -path '**torrent/**' 
! -path '**nzb/**' 
! -path '**backup/**' 
! -path '**nzbget/**' 
! -path '**jdownloader2/**' 
! -path '**sabnzbd/**' 
! -path '**rutorrent/**' 
! -path '**deluge/**' 
! -path '**qbittorrent/**')

```

> **SIMILARLY ADDITIONAL IGNORES CAN BE SET USING ENV ``ADDITIONAL_IGNORES`` EXAMPLE:**

```

-e "ADDITIONAL_IGNORES=! -path '*/SocialMediaDumper/*' ! -path '*/test/*'"

```

-----

## CHANGELOG

> - WebUI is colored 
> - s6-overlay:latest version 
> - alpine-docker-image:latest version
> - Additional ENV variables added
> - WEB-UI is optimized for Cellphones 
> - Automatic Bandwidth Throttling whilst two or more than two Plex streams are running
> - Upload speed throtlling
> - Preference.xml (used for bandwidth throtlling whilst a plex stream is running) is now automatically copied and named docker-preferences.xml
> - 2 failsafe mods added reading/edit the docker-preferences.xml and /app/plex folder. 





- NEW FEATURES COMING !! 

-----

## BUGS/FEATURE-REQUESTS  

> **The repo is maintained privatley for any bug or feature requests:**
https://github.com/doob187/uploader-bug-tracker/issues


-----

## TRAEFIK v1.7

```
    labels:
      - "traefik.enable=true"
      - "traefik.frontend.redirect.entryPoint=https"
      - "traefik.frontend.rule=Host:uploader.example.com"
      - "traefik.frontend.headers.SSLHost=example.com"
      - "traefik.frontend.headers.SSLRedirect=true"
      - "traefik.frontend.headers.STSIncludeSubdomains=true"
      - "traefik.frontend.headers.STSPreload=true"
      - "traefik.frontend.headers.STSSeconds=315360000"
      - "traefik.frontend.headers.browserXSSFilter=true"
      - "traefik.frontend.headers.contentTypeNosniff=true"
      - "traefik.frontend.headers.customResponseHeaders=X-Robots-Tag:noindex,nofollow,nosnippet,noarchive,notranslate,noimageindex"
      - "traefik.frontend.headers.forceSTSHeader=true"
      - "traefik.port=8080"
    networks:
      - traefik_proxy_sample_network

```

-----

## ORIGINAL CODER \ CREDITS

> Original coder is ```physk/rclone-mergerfs``` on gitlab

-----

docker-composer.yml 

```

version: "3"
services:
  uploader:
    container_name: uploader
    image: mrdoob/rccup:latest
    privileged: true
    cap_add:
      - SYS_ADMIN
    devices:
      - "/dev/fuse"
    security_opt:
      - "apparmor:unconfined"
    environment:
      - "ADDITIONAL_IGNORES=null'
      - "UPLOADS=4"
      - "BWLIMITSET=80"
      - "CHUNK=32"
      - "PLEX=false"
      - "GCE=false"
      - "TZ=Europe/Berlin"
      - "DISCORD_WEBHOOK_URL=null"
      - "DISCORD_ICON_OVERRIDE=https://i.imgur.com/MZYwA1I.png"
      - "DISCORD_NAME_OVERRIDE=UPLOADER"
      - "LOGHOLDUI=5m"
      - "PUID=${PUID}"
      - "PGID=${PUID}"
    volumes:
      - "/mnt/move:/move"
      - "/opt/uploader:/config"
      - "/mnt/unionfs:/unionfs:shared"
    ports:
      - "7777:8080"
    restart: always

```
-----

(c) 2020 MrDoob 
