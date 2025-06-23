#!/bin/bash

# phantom-dlp - A comprehensive yt-dlp wrapper
# Version: 1.0
# Description: User-friendly interface for yt-dlp with all major features

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Default values
DEFAULT_DOWNLOAD_PATH="$HOME/Downloads"
CONFIG_FILE="$HOME/.config/phantom-dlp/config"
HISTORY_FILE="$HOME/.config/phantom-dlp/history"

# Create config directory if it doesn't exist
mkdir -p "$(dirname "$CONFIG_FILE")"

# Load configuration
load_config() {
    if [[ -f "$CONFIG_FILE" ]]; then
        source "$CONFIG_FILE"
    fi
    DOWNLOAD_PATH="${DOWNLOAD_PATH:-$DEFAULT_DOWNLOAD_PATH}"
    PREFERRED_QUALITY="${PREFERRED_QUALITY:-best}"
    PREFERRED_FORMAT="${PREFERRED_FORMAT:-mp4}"
    PREFERRED_AUDIO_FORMAT="${PREFERRED_AUDIO_FORMAT:-mp3}"
}

# Save configuration
save_config() {
    cat > "$CONFIG_FILE" << EOF
DOWNLOAD_PATH="$DOWNLOAD_PATH"
PREFERRED_QUALITY="$PREFERRED_QUALITY"
PREFERRED_FORMAT="$PREFERRED_FORMAT"
PREFERRED_AUDIO_FORMAT="$PREFERRED_AUDIO_FORMAT"
EOF
}

# Logging function
log() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Check dependencies
check_dependencies() {
    local deps=("yt-dlp" "ffmpeg")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        error "Missing dependencies: ${missing[*]}"
        echo "Install with: sudo pacman -S ${missing[*]}"
        exit 1
    fi
}

# Add URL to history
add_to_history() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$HISTORY_FILE"
}

# Display banner
show_banner() {
    clear
    echo -e "${PURPLE}"
    echo "██████╗ ██╗  ██╗ █████╗ ███╗   ██╗████████╗ ██████╗ ███╗   ███╗"
    echo "██╔══██╗██║  ██║██╔══██╗████╗  ██║╚══██╔══╝██╔═══██╗████╗ ████║"
    echo "██████╔╝███████║███████║██╔██╗ ██║   ██║   ██║   ██║██╔████╔██║"
    echo "██╔═══╝ ██╔══██║██╔══██║██║╚██╗██║   ██║   ██║   ██║██║╚██╔╝██║"
    echo "██║     ██║  ██║██║  ██║██║ ╚████║   ██║   ╚██████╔╝██║ ╚═╝ ██║"
    echo "╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝    ╚═════╝ ╚═╝     ╚═╝"
    echo -e "${NC}"
    echo -e "${WHITE}                    -= PHANTOM-DLP v1.0 =-${NC}"
    echo -e "${CYAN}              Comprehensive yt-dlp Interface${NC}"
    echo
}


# Main menu
show_main_menu() {
    echo -e "\n${PURPLE}=== PHANTOM-DLP MAIN MENU ===${NC}"
    echo -e "${CYAN} 1) Quick Download (Video + Audio)"
    echo -e "${CYAN} 2) Audio Only Download"
    echo -e "${CYAN} 3) Video Only Download"
    echo -e "${CYAN} 4) Playlist Download"
    echo -e "${CYAN} 5) Quality Selection"
    echo -e "${CYAN} 6) Format Conversion"
    echo -e "${CYAN} 7) Subtitle Download"
    echo -e "${CYAN} 8) Live Stream Recording"
    echo -e "${CYAN} 9) Batch Download (URLs from file)"
    echo -e "${CYAN}10) Search and Download"
    echo -e "${CYAN}11) Update yt-dlp"
    echo -e "${CYAN}12) View Available Formats"
    echo -e "${CYAN}13) Configuration Settings"
    echo -e "${CYAN}14) Download History"
    echo -e "${CYAN}15) Advanced Options"
    echo -e "${CYAN} 0) Exit"
    echo -e "${CYAN}=================================${NC}"
}

# Get safe download path
get_safe_path() {
    local path="$1"
    mkdir -p "$path"
    if [[ ! -w "$path" ]]; then
        warning "Cannot write to $path, using $DEFAULT_DOWNLOAD_PATH"
        path="$DEFAULT_DOWNLOAD_PATH"
        mkdir -p "$path"
    fi
    echo "$path"
}

# Safe download function with error handling
safe_download() {
    local url="$1"
    local options="$2"
    local description="$3"
    
    info "Starting $description..."
    info "URL: $url"
    info "Options: $options"
    
    # Validate URL
    if ! yt-dlp --no-download --quiet "$url" 2>/dev/null; then
        error "Invalid URL or video not accessible: $url"
        return 1
    fi
    
    # Execute download with fallback options
    local cmd="yt-dlp $options \"$url\""
    
    if eval "$cmd"; then
        log "✓ Download completed successfully!"
        add_to_history "$url - $description"
        return 0
    else
        warning "Download failed with current settings. Trying fallback options..."
        
        # Fallback: try with lower quality
        local fallback_cmd="yt-dlp --format 'best[height<=720]/best' --merge-output-format mp4 -o \"$DOWNLOAD_PATH/%(title)s.%(ext)s\" \"$url\""
        
        if eval "$fallback_cmd"; then
            log "✓ Download completed with fallback settings!"
            add_to_history "$url - $description (fallback)"
            return 0
        else
            error "Download failed even with fallback settings"
            return 1
        fi
    fi
}

# Quick download
quick_download() {
    echo -e "\n${YELLOW}=== QUICK DOWNLOAD ===${NC}"
    read -p "Enter URL: " url
    [[ -z "$url" ]] && { error "URL cannot be empty"; return 1; }
    
    local safe_path
    safe_path=$(get_safe_path "$DOWNLOAD_PATH")
    
    local options="--format 'best[ext=mp4]/best' --merge-output-format mp4 -o \"$safe_path/%(title)s.%(ext)s\""
    safe_download "$url" "$options" "Quick Download"
}

# Audio only download
audio_download() {
    echo -e "\n${YELLOW}=== AUDIO DOWNLOAD ===${NC}"
    read -p "Enter URL: " url
    [[ -z "$url" ]] && { error "URL cannot be empty"; return 1; }
    
    echo "Select audio quality:"
    echo "1) Best quality"
    echo "2) 320k"
    echo "3) 256k"
    echo "4) 128k"
    read -p "Choice [1]: " quality_choice
    quality_choice=${quality_choice:-1}
    
    local audio_quality
    case $quality_choice in
        1) audio_quality="best" ;;
        2) audio_quality="320" ;;
        3) audio_quality="256" ;;
        4) audio_quality="128" ;;
        *) audio_quality="best" ;;
    esac
    
    local safe_path
    safe_path=$(get_safe_path "$DOWNLOAD_PATH")
    
    local options="--extract-audio --audio-format $PREFERRED_AUDIO_FORMAT --audio-quality $audio_quality -o \"$safe_path/%(title)s.%(ext)s\""
    safe_download "$url" "$options" "Audio Download"
}

# Video only download
video_download() {
    echo -e "\n${YELLOW}=== VIDEO DOWNLOAD ===${NC}"
    read -p "Enter URL: " url
    [[ -z "$url" ]] && { error "URL cannot be empty"; return 1; }
    
    echo "Select video quality:"
    echo "1) Best available"
    echo "2) 4K (2160p)"
    echo "3) 1440p"
    echo "4) 1080p"
    echo "5) 720p"
    echo "6) 480p"
    read -p "Choice [1]: " quality_choice
    quality_choice=${quality_choice:-1}
    
    local video_format
    case $quality_choice in
        1) video_format="best[ext=mp4]/best" ;;
        2) video_format="best[height<=2160][ext=mp4]/best[height<=2160]" ;;
        3) video_format="best[height<=1440][ext=mp4]/best[height<=1440]" ;;
        4) video_format="best[height<=1080][ext=mp4]/best[height<=1080]" ;;
        5) video_format="best[height<=720][ext=mp4]/best[height<=720]" ;;
        6) video_format="best[height<=480][ext=mp4]/best[height<=480]" ;;
        *) video_format="best[ext=mp4]/best" ;;
    esac
    
    local safe_path
    safe_path=$(get_safe_path "$DOWNLOAD_PATH")
    
    local options="--format '$video_format' --merge-output-format mp4 -o \"$safe_path/%(title)s.%(ext)s\""
    safe_download "$url" "$options" "Video Download"
}

# Playlist download
playlist_download() {
    echo -e "\n${YELLOW}=== PLAYLIST DOWNLOAD ===${NC}"
    read -p "Enter playlist URL: " url
    [[ -z "$url" ]] && { error "URL cannot be empty"; return 1; }
    
    echo "Playlist options:"
    echo "1) Download entire playlist"
    echo "2) Download specific range"
    echo "3) Download from start to specific item"
    echo "4) Download from specific item to end"
    read -p "Choice [1]: " playlist_choice
    playlist_choice=${playlist_choice:-1}
    
    local playlist_options=""
    case $playlist_choice in
        2)
            read -p "Start index: " start_idx
            read -p "End index: " end_idx
            playlist_options="--playlist-start $start_idx --playlist-end $end_idx"
            ;;
        3)
            read -p "End index: " end_idx
            playlist_options="--playlist-end $end_idx"
            ;;
        4)
            read -p "Start index: " start_idx
            playlist_options="--playlist-start $start_idx"
            ;;
    esac
    
    local safe_path
    safe_path=$(get_safe_path "$DOWNLOAD_PATH")
    
    local options="--format 'best[ext=mp4]/best' $playlist_options -o \"$safe_path/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s\""
    safe_download "$url" "$options" "Playlist Download"
}

# View available formats
view_formats() {
    echo -e "\n${YELLOW}=== VIEW AVAILABLE FORMATS ===${NC}"
    read -p "Enter URL: " url
    [[ -z "$url" ]] && { error "URL cannot be empty"; return 1; }
    
    info "Fetching available formats..."
    yt-dlp --list-formats "$url" || error "Failed to fetch formats"
}

# Subtitle download
subtitle_download() {
    echo -e "\n${YELLOW}=== SUBTITLE DOWNLOAD ===${NC}"
    read -p "Enter URL: " url
    [[ -z "$url" ]] && { error "URL cannot be empty"; return 1; }
    
    echo "Subtitle options:"
    echo "1) Download all available subtitles"
    echo "2) Download auto-generated subtitles"
    echo "3) Download specific language"
    echo "4) Download subtitles only (no video)"
    read -p "Choice [1]: " sub_choice
    sub_choice=${sub_choice:-1}
    
    local sub_options=""
    case $sub_choice in
        1) sub_options="--write-sub --write-auto-sub" ;;
        2) sub_options="--write-auto-sub" ;;
        3)
            read -p "Enter language code (e.g., en, es, fr): " lang
            sub_options="--write-sub --sub-lang $lang"
            ;;
        4) sub_options="--write-sub --write-auto-sub --skip-download" ;;
    esac
    
    local safe_path
    safe_path=$(get_safe_path "$DOWNLOAD_PATH")
    
    local options="$sub_options --sub-format srt -o \"$safe_path/%(title)s.%(ext)s\""
    safe_download "$url" "$options" "Subtitle Download"
}

# Live stream recording
live_stream() {
    echo -e "\n${YELLOW}=== LIVE STREAM RECORDING ===${NC}"
    read -p "Enter live stream URL: " url
    [[ -z "$url" ]] && { error "URL cannot be empty"; return 1; }
    
    read -p "Record duration in seconds (leave empty for unlimited): " duration
    
    local safe_path
    safe_path=$(get_safe_path "$DOWNLOAD_PATH")
    
    local options="--format 'best[ext=mp4]/best' -o \"$safe_path/LIVE_%(title)s_%(upload_date)s.%(ext)s\""
    
    if [[ -n "$duration" ]]; then
        options="$options --live-from-start --wait-for-video 10"
        timeout "$duration" yt-dlp $options "$url" || true
    else
        safe_download "$url" "$options" "Live Stream Recording"
    fi
}

# Batch download
batch_download() {
    echo -e "\n${YELLOW}=== BATCH DOWNLOAD ===${NC}"
    read -p "Enter path to file containing URLs: " file_path
    
    if [[ ! -f "$file_path" ]]; then
        error "File not found: $file_path"
        return 1
    fi
    
    local safe_path
    safe_path=$(get_safe_path "$DOWNLOAD_PATH")
    
    local options="--format 'best[ext=mp4]/best' -o \"$safe_path/%(title)s.%(ext)s\""
    
    info "Starting batch download..."
    yt-dlp $options --batch-file "$file_path" || error "Batch download failed"
}

# Search and download
search_download() {
    echo -e "\n${YELLOW}=== SEARCH AND DOWNLOAD ===${NC}"
    read -p "Enter search query: " query
    [[ -z "$query" ]] && { error "Query cannot be empty"; return 1; }
    
    read -p "Number of results to show [5]: " num_results
    num_results=${num_results:-5}
    
    info "Searching for: $query"
    
    # Use yt-dlp to search YouTube
    local search_url="ytsearch${num_results}:$query"
    
    echo "Available videos:"
    yt-dlp --get-title --get-id "$search_url" | paste - - | nl -w2 -s') '
    
    read -p "Select video number to download: " selection
    
    if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le "$num_results" ]; then
        local video_id
        video_id=$(yt-dlp --get-id "$search_url" | sed -n "${selection}p")
        local video_url="https://www.youtube.com/watch?v=$video_id"
        
        local safe_path
        safe_path=$(get_safe_path "$DOWNLOAD_PATH")
        
        local options="--format 'best[ext=mp4]/best' -o \"$safe_path/%(title)s.%(ext)s\""
        safe_download "$video_url" "$options" "Search Download"
    else
        error "Invalid selection"
    fi
}

# Update yt-dlp
update_ytdlp() {
    echo -e "\n${YELLOW}=== UPDATE YT-DLP ===${NC}"
    info "Updating yt-dlp..."
    
    if command -v pip &> /dev/null; then
        pip install --upgrade yt-dlp
    elif command -v pipx &> /dev/null; then
        pipx upgrade yt-dlp
    else
        warning "Please update yt-dlp manually using your package manager"
        echo "For Arch Linux: sudo pacman -Syu yt-dlp"
    fi
}

# Configuration settings
config_settings() {
    echo -e "\n${YELLOW}=== CONFIGURATION SETTINGS ===${NC}"
    echo "Current settings:"
    echo "Download path: $DOWNLOAD_PATH"
    echo "Preferred quality: $PREFERRED_QUALITY"
    echo "Preferred format: $PREFERRED_FORMAT"
    echo "Preferred audio format: $PREFERRED_AUDIO_FORMAT"
    echo
    
    echo "1) Change download path"
    echo "2) Change preferred quality"
    echo "3) Change preferred format"
    echo "4) Change preferred audio format"
    echo "5) Reset to defaults"
    echo "0) Back to main menu"
    
    read -p "Choice: " config_choice
    
    case $config_choice in
        1)
            read -p "Enter new download path [$DOWNLOAD_PATH]: " new_path
            if [[ -n "$new_path" ]]; then
                DOWNLOAD_PATH="$new_path"
                mkdir -p "$DOWNLOAD_PATH"
            fi
            ;;
        2)
            echo "Quality options: best, worst, 1080p, 720p, 480p"
            read -p "Enter preferred quality [$PREFERRED_QUALITY]: " new_quality
            [[ -n "$new_quality" ]] && PREFERRED_QUALITY="$new_quality"
            ;;
        3)
            echo "Format options: mp4, mkv, webm, avi"
            read -p "Enter preferred format [$PREFERRED_FORMAT]: " new_format
            [[ -n "$new_format" ]] && PREFERRED_FORMAT="$new_format"
            ;;
        4)
            echo "Audio format options: mp3, aac, opus, m4a"
            read -p "Enter preferred audio format [$PREFERRED_AUDIO_FORMAT]: " new_audio_format
            [[ -n "$new_audio_format" ]] && PREFERRED_AUDIO_FORMAT="$new_audio_format"
            ;;
        5)
            DOWNLOAD_PATH="$DEFAULT_DOWNLOAD_PATH"
            PREFERRED_QUALITY="best"
            PREFERRED_FORMAT="mp4"
            PREFERRED_AUDIO_FORMAT="mp3"
            info "Settings reset to defaults"
            ;;
    esac
    
    save_config
    log "Configuration saved"
}

# Download history
show_history() {
    echo -e "\n${YELLOW}=== DOWNLOAD HISTORY ===${NC}"
    if [[ -f "$HISTORY_FILE" ]]; then
        tail -20 "$HISTORY_FILE"
    else
        info "No download history found"
    fi
}

# Advanced options
advanced_options() {
    echo -e "\n${YELLOW}=== ADVANCED OPTIONS ===${NC}"
    read -p "Enter URL: " url
    [[ -z "$url" ]] && { error "URL cannot be empty"; return 1; }
    
    echo "Advanced options:"
    echo "1) Custom format string"
    echo "2) Extract metadata only"
    echo "3) Download with custom naming"
    echo "4) Proxy download"
    echo "5) Rate limiting"
    echo "6) Resume incomplete download"
    
    read -p "Choice: " adv_choice
    
    local safe_path
    safe_path=$(get_safe_path "$DOWNLOAD_PATH")
    local options=""
    
    case $adv_choice in
        1)
            read -p "Enter format string: " format_str
            options="--format '$format_str' -o \"$safe_path/%(title)s.%(ext)s\""
            ;;
        2)
            options="--write-info-json --write-description --write-thumbnail --skip-download -o \"$safe_path/%(title)s\""
            ;;
        3)
            read -p "Enter custom filename template: " filename_template
            options="--format 'best[ext=mp4]/best' -o \"$safe_path/$filename_template\""
            ;;
        4)
            read -p "Enter proxy URL (http://proxy:port): " proxy_url
            options="--proxy '$proxy_url' --format 'best[ext=mp4]/best' -o \"$safe_path/%(title)s.%(ext)s\""
            ;;
        5)
            read -p "Enter rate limit (e.g., 1M for 1MB/s): " rate_limit
            options="--limit-rate '$rate_limit' --format 'best[ext=mp4]/best' -o \"$safe_path/%(title)s.%(ext)s\""
            ;;
        6)
            options="--continue --format 'best[ext=mp4]/best' -o \"$safe_path/%(title)s.%(ext)s\""
            ;;
        *)
            error "Invalid choice"
            return 1
            ;;
    esac
    
    safe_download "$url" "$options" "Advanced Download"
}

# Main execution
main() {
    check_dependencies
    load_config
    show_banner
    
    while true; do
        show_main_menu
        read -p "Enter your choice: " choice
        
        case $choice in
            1) quick_download ;;
            2) audio_download ;;
            3) video_download ;;
            4) playlist_download ;;
            5) video_download ;;  # Quality selection is part of video download
            6) audio_download ;;  # Format conversion is part of audio download
            7) subtitle_download ;;
            8) live_stream ;;
            9) batch_download ;;
            10) search_download ;;
            11) update_ytdlp ;;
            12) view_formats ;;
            13) config_settings ;;
            14) show_history ;;
            15) advanced_options ;;
            0) 
                log "Thank you for using Phantom-DLP!"
                exit 0
                ;;
            *)
                error "Invalid choice. Please try again."
                ;;
        esac
        
        echo
        read -p "Press Enter to continue..."
    done
}

# Run the main function
main "$@"