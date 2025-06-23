#!/bin/bash

# ╔═══════════════════════════════════╗
# ║      🕸️ Phantom-dlp v2 by          ║
# ╚═══════════════════════════════════╝

# 🎨 Terminal Color Codes
red='\e[31m'
green='\e[32m'
yellow='\e[33m'
blue='\e[34m'
magenta='\e[35m'
cyan='\e[36m'
bold='\e[1m'
reset='\e[0m'

# 🛡️ Check for required commands
require_command() {
    command -v "$1" >/dev/null 2>&1 || {
        echo -e "${yellow}[!] $1 not found. Installing...${reset}"
        if command -v pacman >/dev/null; then sudo pacman -Sy --noconfirm "$1"
        elif command -v apt >/dev/null; then sudo apt update && sudo apt install -y "$1"
        elif command -v dnf >/dev/null; then sudo dnf install -y "$1"
        else
            echo -e "${red}[✖] Unsupported package manager. Install $1 manually.${reset}"
            exit 1
        fi
    }
}

require_command yt-dlp
require_command ffmpeg
require_command jq

# ⚡ Spinner
spinner() {
    local pid=$1
    local spin='-\|/'
    local i=0
    while kill -0 "$pid" 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf "\r${cyan}[~] Downloading... ${spin:$i:1}${reset}"
        sleep 0.2
    done
    echo -ne "\r"
}

# 🧙 Show banner
clear
echo -e "${magenta}${bold}
╔═══════════════════════════════╗
║    🕸️ Phantom-dlp v2 by        ║
╚═══════════════════════════════╝
${reset}"

# 🔗 Ask for the URL
read -p "$(echo -e "${cyan}[?] Enter the video/playlist/channel URL: ${reset}")" URL
if [[ -z "$URL" ]]; then echo -e "${red}[✖] URL is required.${reset}"; exit 1; fi

# 🔍 Preview info
echo -e "${yellow}[i] Fetching video info...${reset}"
META=$(yt-dlp --dump-json "$URL" | jq -r '.title, .uploader, .duration_string, .webpage_url' 2>/dev/null)

TITLE=$(echo "$META" | sed -n '1p')
AUTHOR=$(echo "$META" | sed -n '2p')
DURATION=$(echo "$META" | sed -n '3p')
PAGEURL=$(echo "$META" | sed -n '4p')

echo -e "${green}▶️  Title   : $TITLE"
echo -e "👤 Uploader: $AUTHOR"
echo -e "⏱️  Duration: $DURATION"
echo -e "🔗 Link    : $PAGEURL${reset}"

# 🎧 Select type
echo -e "${yellow}[>] Choose download type:
1) Video
2) Audio only
3) Playlist
4) Channel${reset}"
read -p "$(echo -e "${blue}[*] Your choice: ${reset}")" TYPE

# 🧠 Output folder
read -p "$(echo -e "${cyan}[?] Enter download folder (default: ~/Downloads): ${reset}")" OUTDIR
OUTDIR=${OUTDIR:-"$HOME/Downloads"}

mkdir -p "$OUTDIR"

OPTIONS=("-P" "$OUTDIR" "--embed-thumbnail" "--embed-metadata" "--add-metadata")
TEMPLATE=""

# 🎛 Format selection
case $TYPE in
    1)
        echo -e "${yellow}[>] Choose video resolution: (best/1080p/720p)${reset}"
        read -p "$(echo -e "${blue}[*] Quality: ${reset}")" VQUALITY
        FORMAT="bestvideo[height<=${VQUALITY:-1080}]+bestaudio/best"
        TEMPLATE="%(title)s.%(ext)s"
        ;;
    2)
        echo -e "${yellow}[>] Choose audio format: (mp3/m4a/opus)${reset}"
        read -p "$(echo -e "${blue}[*] Format: ${reset}")" AFORMAT
        OPTIONS+=("-x" "--audio-format" "${AFORMAT:-mp3}")
        TEMPLATE="%(title)s.%(ext)s"
        ;;
    3)
        OPTIONS+=("--yes-playlist")
        TEMPLATE="%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s"
        ;;
    4)
        OPTIONS+=("--yes-playlist" "--flat-playlist")
        TEMPLATE="%(uploader)s/%(title)s.%(ext)s"
        ;;
    *)
        echo -e "${red}[✖] Invalid selection.${reset}"
        exit 1
        ;;
esac

OPTIONS+=("-f" "${FORMAT:-best}" "-o" "$OUTDIR/$TEMPLATE")

# 🌀 Begin download
echo -e "${green}[+] Starting download...${reset}"
yt-dlp "${OPTIONS[@]}" "$URL" > "$OUTDIR/phantom-dlp.log" 2>&1 &
spinner $!

# 🎉 Done
echo -e "\n${green}✔️ Done! Saved to: ${bold}$OUTDIR${reset}"
