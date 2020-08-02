#!/bin/bash
#
# Title:      remove the old garbage files
# MOD from MrDoobPG
# fuck of all haters
# GNU:        General Public License v3.0
################################################################################
#pids="$(ps -ef | grep 'cleanup.sh' | head -n 1 | grep -v grep | awk '{print $1}')"
#if [ "$pids" == "" ]; then
#  cleaning
#  sleep 2
#fi
##### FUNCTIONS #####
downloadpath=/move
CLEANUPDOWN=${CLEANUPDOWN}

if [[ "${CLEANUPDOWN}" == 'null' ]]; then
   CLEANUPDOWN=7
else 
   CLEANUPDOWN=${CLEANUPDOWN}
fi

cleaning() {
 while true; do
    cleanup_start
    #find ${downloadpath}/{nzb,torrent,sabnzbd,nzbget,qbittorrent,rutorrent,deluge,jdownloader2} -mindepth 1 -type d -ctime +${CLEANUPDOWN} -exec rm -rf {} +
    #/app/cleanup/backpacker.sh
    garbage
    sleep 30
 done
}

function cleanup_start() {
TARGET_FOLDER="${downloadpath}/{nzb,torrent,sabnzbd,nzbget,qbittorrent,rutorrent,deluge,jdownloader2}" 
FIND=$(which find)
FIND_BASE='-mindepth 1 -type d'
FIND_TIME='-ctime +${CLEANUPDOWN}'
FIND_ACTION='-not -path "**_UNPACK_**" -exec rm -rf {} + > /dev/null 2>&1'
command="${FIND} ${TARGET_FOLDER} ${FIND_BASE} ${FIND_TIME} ${FIND_ACTION}"
eval "${command}"
###find ${downloadpath}/{nzb,torrent,sabnzbd,nzbget,qbittorrent,rutorrent,deluge,jdownloader2} -mindepth 1 -type d -ctime +${CLEANUPDOWN} -exec rm -rf {} +
}

function garbage() {
#####################################################
# script by pho
#####################################################
# basic settings
downloadpath=/move
TARGET_FOLDER="${downloadpath}/{nzb,torrent,sabnzbd,nzbget,qbittorrent,rutorrent,deluge,jdownloader2}" 
# find files in this folders
FIND_SAMPLE_SIZE='188M' # files smaller then this are seen as samples and get deleted

# advanced settings
FIND=$(which find)
FIND_BASE_CONDITION_WANTED='-type f -amin +600'
FIND_BASE_CONDITION_UNWANTED='-type f'
FIND_ADD_NAME='-o -iname'
FIND_DEL_NAME='! -iname'
FIND_ACTION='-not -path "**_UNPACK_**" -delete > /dev/null 2>&1'
command="${FIND} ${TARGET_FOLDER} -mindepth 1 ${FIND_BASE_CONDITION_WANTED} -size -${FIND_SAMPLE_SIZE} ${FIND_ACTION}"
eval "${command}"

WANTED_FILES=(
    '*.mkv'
    '*.mpg'
    '*.mpeg'
    '*.avi'
    '*.mp4'
    '*.mp3'
    '*.flac'
    '*.srt'
    '*.idx'
    '*.sub'
)
UNWANTED_FILES=(
    'abc.xyz.*'
    '*.m3u'
    'Top Usenet Provider*'
    'house-of-usenet.info'
    '*.html~'
    '*KLICK IT*'
    'Click.rar'
    '*.1'
    '*.2'
    '*.3'
    '*.4'
    '*.5'
    '*.6'
    '*.7'
    '*.8'
    '*.9'
    '*.0'
    '*.10'
    '*.11'
    '*.12'
    '*.13'
    '*.14'
    '*.15'
    '*.gif'
    '*sample.*'
    '*.sh'
    '*.pdf'
    '*.doc'
    '*.docx'
    '*.xls'
    '*.xlsx'
    '*.xml'
    '*.html'
    '*.htm'
    '*.exe'
    '*.nzb'
)
#Folder Setting
condition="-iname '${UNWANTED_FILES[0]}'"
for ((i = 1; i < ${#UNWANTED_FILES[@]}; i++))
do
    condition="${condition} ${FIND_ADD_NAME} '${UNWANTED_FILES[i]}'"
done
command="${FIND} ${TARGET_FOLDER} -mindepth 1 ${FIND_BASE_CONDITION_UNWANTED} \( ${condition} \) ${FIND_ACTION}"
#echo "Executing ${command}"
eval "${command}"

for ((i = 0; i < ${#WANTED_FILES[@]}-1; i++))
do
    condition2="${condition2} ${FIND_DEL_NAME} '${WANTED_FILES[i]}'"
done
command="${FIND} ${TARGET_FOLDER} -mindepth 1 ${FIND_BASE_CONDITION_WANTED} \( ${condition2} \) ${FIND_ACTION}"
#echo "Executing ${command}"
eval "${command}"
}

# keeps the function in a loop
cheeseballs=0
while [[ "$cheeseballs" == "0" ]]; do cleaning; done