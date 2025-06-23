# Phantom-DLP

<div align="center">

```
██████╗ ██╗  ██╗ █████╗ ███╗   ██╗████████╗ ██████╗ ███╗   ███╗
██╔══██╗██║  ██║██╔══██╗████╗  ██║╚══██╔══╝██╔═══██╗████╗ ████║
██████╔╝███████║███████║██╔██╗ ██║   ██║   ██║   ██║██╔████╔██║
██╔═══╝ ██╔══██║██╔══██║██║╚██╗██║   ██║   ██║   ██║██║╚██╔╝██║
██║     ██║  ██║██║  ██║██║ ╚████║   ██║   ╚██████╔╝██║ ╚═╝ ██║
╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝    ╚═════╝ ╚═╝     ╚═╝
```

**Professional yt-dlp Wrapper with Advanced Features**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Shell Script](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)
[![Version](https://img.shields.io/badge/Version-1.0.0-blue.svg)](https://github.com/Ishan0121/phantom-dlp/releases)
[![Platform](https://img.shields.io/badge/Platform-Linux-orange.svg)](https://www.linux.org/)

[Installation](#installation) • [Usage](#usage) • [Features](#features) • [Contributing](#contributing)

</div>

## 🚀 Overview

**Phantom-DLP** is a comprehensive, user-friendly wrapper for `yt-dlp` that transforms the command-line experience into an intuitive, menu-driven interface. Perfect for both beginners and power users who want maximum control over their media downloads.

### 🎯 Why Choose Phantom-DLP?

- **🎮 Interactive Interface** - No more memorizing complex command-line arguments
- **🛡️ Built-in Safety** - Robust error handling and automatic quality fallbacks
- **⚡ Optimized Downloads** - Smart quality selection and resume capabilities
- **🎨 Beautiful Output** - Colorized interface with clear progress indicators
- **🔧 Highly Configurable** - Persistent settings and customizable workflows
- **📱 Universal Support** - Works with 1000+ video platforms

## ✨ Features

### 🎬 Core Download Modes
- **Quick Download** - One-click optimal quality video + audio
- **Audio Extraction** - High-quality audio-only downloads (MP3, AAC, OPUS)
- **Video Downloads** - Quality-specific downloads (4K, 1080p, 720p, 480p)
- **Smart Playlists** - Full or selective range playlist downloads
- **Live Streaming** - Real-time stream capture with duration controls

### 🎯 Advanced Capabilities
- **Built-in Search** - Find and download directly from YouTube search
- **Batch Processing** - Download multiple URLs from file input
- **Subtitle Support** - Multi-language subtitle download and embedding
- **Format Analysis** - Preview available qualities before download
- **Custom Templates** - Flexible file naming and organization
- **Proxy Support** - Download through proxy servers
- **Rate Limiting** - Bandwidth control for network management

### 🔧 Smart Features
- **Auto-Fallbacks** - Retry with alternative qualities on failure
- **Path Validation** - Intelligent directory handling
- **URL Verification** - Pre-download accessibility checks
- **Download History** - Complete logging with timestamps
- **Resume Downloads** - Continue interrupted transfers
- **Configuration Persistence** - Save and restore preferences

## 📋 Prerequisites

### Required Dependencies
```bash
# Arch Linux
sudo pacman -S yt-dlp ffmpeg bash

# Ubuntu/Debian
sudo apt install yt-dlp ffmpeg bash

# CentOS/RHEL/Fedora
sudo dnf install yt-dlp ffmpeg bash
```

### Verification
```bash
yt-dlp --version    # Should show version info
ffmpeg -version     # Should show version info
bash --version      # Should be 4.0+
```

## 📦 Installation

### Quick Install (Recommended)
```bash
curl -fsSL https://raw.githubusercontent.com/Ishan0121/phantom-dlp/main/install.sh | bash
```

### Manual Installation

#### Option 1: System-wide Installation
```bash
# Download the script
curl -O https://raw.githubusercontent.com/Ishan0121/phantom-dlp/main/phantom-dlp.sh

# Install system-wide
sudo cp phantom-dlp.sh /usr/local/bin/phantom-dlp
sudo chmod +x /usr/local/bin/phantom-dlp

# Verify
phantom-dlp
```

#### Option 2: User Installation
```bash
# Create user bin directory
mkdir -p ~/.local/bin

# Download and install
curl -o ~/.local/bin/phantom-dlp https://raw.githubusercontent.com/Ishan0121/phantom-dlp/main/phantom-dlp.sh
chmod +x ~/.local/bin/phantom-dlp

# Add to PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

#### Option 3: Clone Repository
```bash
git clone https://github.com/Ishan0121/phantom-dlp.git
cd phantom-dlp
chmod +x phantom-dlp.sh

# Optional: Create system link
sudo ln -sf "$(pwd)/phantom-dlp.sh" /usr/local/bin/phantom-dlp
```

## 🎮 Usage

### Launch Interactive Menu
```bash
phantom-dlp
```

### Main Menu Options
```
=== PHANTOM-DLP MAIN MENU ===
 1) Quick Download (Video + Audio)
 2) Audio Only Download  
 3) Video Only Download
 4) Playlist Download
 5) Quality Selection
 6) Format Conversion
 7) Subtitle Download
 8) Live Stream Recording
 9) Batch Download (URLs from file)
10) Search and Download
11) Update yt-dlp
12) View Available Formats
13) Configuration Settings
14) Download History
15) Advanced Options
 0) Exit
```

### Quick Examples

#### Download a Single Video
1. Run `phantom-dlp`
2. Select `1` (Quick Download)
3. Paste video URL
4. Press Enter and wait

#### Extract Audio Only
1. Select `2` (Audio Only Download)
2. Choose quality (Best/320k/256k/128k)
3. Enter URL

#### Download Entire Playlist
1. Select `4` (Playlist Download)
2. Choose `1` (Download entire playlist)
3. Enter playlist URL

#### Search and Download
1. Select `10` (Search and Download)
2. Enter search terms
3. Select from results
4. Download automatically

## ⚙️ Configuration

### Default Settings
- **Download Path**: `~/Downloads`
- **Video Quality**: `best`
- **Video Format**: `mp4`
- **Audio Format**: `mp3`

### Configuration Files
- **Settings**: `~/.config/phantom-dlp/config`
- **History**: `~/.config/phantom-dlp/history`

### Customization
Access settings via menu option `13`:

1. **Download Path** - Change default location
2. **Quality Preferences** - Set default quality
3. **Format Preferences** - Set output formats
4. **Reset Defaults** - Restore original settings

## 🔧 Advanced Usage

### Batch Downloads
Create a text file with URLs (one per line):
```
https://www.youtube.com/watch?v=VIDEO1
https://www.youtube.com/watch?v=VIDEO2
https://www.youtube.com/playlist?list=PLAYLIST
```

Use menu option `9` and select your file.

### Custom Format Strings
Advanced users can specify custom yt-dlp format strings:
```bash
# Best MP4 under 1080p
'best[height<=1080][ext=mp4]'

# Best audio under 128kbps
'bestaudio[abr<=128]'
```

### Proxy Configuration
For restricted networks:
```bash
# HTTP proxy
http://proxy.example.com:8080

# SOCKS5 proxy  
socks5://proxy.example.com:1080
```

## 🌐 Supported Platforms

Phantom-DLP supports all yt-dlp compatible sites (1000+):

**Popular Platforms:**
- YouTube (videos, playlists, live streams)
- Twitch (videos, clips, live streams)
- Twitter/X (videos, spaces)
- Facebook (videos, live streams)
- Instagram (videos, reels, stories)
- TikTok (videos)
- Vimeo (videos)
- Reddit (videos)
- And many more...

**Check Platform Support:**
```bash
yt-dlp --list-extractors | grep -i "platform_name"
```

## 🔍 Troubleshooting

### Common Issues

#### "Command not found: phantom-dlp"
```bash
# Check if PATH includes installation directory
echo $PATH

# Reinstall to system location
sudo cp phantom-dlp.sh /usr/local/bin/phantom-dlp
sudo chmod +x /usr/local/bin/phantom-dlp
```

#### "Permission denied" errors
```bash
# Fix download directory permissions
chmod 755 ~/Downloads

# Create directory if missing
mkdir -p ~/Downloads
```

#### Download failures
```bash
# Update yt-dlp to latest version
pip install --upgrade yt-dlp
# or
sudo pacman -Syu yt-dlp
```

#### Network/proxy issues
```bash
# Try different user agent
--user-agent "Mozilla/5.0 (compatible)"

# Use proxy for region restrictions
--proxy "socks5://proxy:1080"
```

### Debug Mode
Enable debug output by editing the script:
```bash
#!/bin/bash -x  # Add -x for debug mode
```

### Getting Help
- Check the [Issues](https://github.com/Ishan0121/phantom-dlp/issues) page
- Review [yt-dlp documentation](https://github.com/yt-dlp/yt-dlp)
- Join our community discussions

## 🤝 Contributing

We welcome contributions! Here's how to get started:

### Development Setup
```bash
# Fork the repository on GitHub
git clone https://github.com/Ishan0121/phantom-dlp.git
cd phantom-dlp

# Create feature branch
git checkout -b feature/awesome-feature

# Make your changes
# Test thoroughly
# Commit and push
git commit -m "Add awesome feature"
git push origin feature/awesome-feature

# Create Pull Request
```

### Code Guidelines
- Follow existing code style and structure
- Add comments for complex logic
- Test with multiple platforms and URLs
- Ensure error handling for new features
- Update documentation as needed

### Bug Reports
Include the following in bug reports:
- Operating system and version
- yt-dlp version (`yt-dlp --version`)
- Complete error message/log
- Steps to reproduce
- Example URLs (if not sensitive)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [yt-dlp](https://github.com/yt-dlp/yt-dlp) - The powerful download engine
- [FFmpeg](https://ffmpeg.org/) - Media processing framework
- Community contributors and testers
- Arch Linux community for inspiration

## 📊 Statistics

<div align="center">

![GitHub stars](https://img.shields.io/github/stars/Ishan0121/phantom-dlp?style=social)
![GitHub forks](https://img.shields.io/github/forks/Ishan0121/phantom-dlp?style=social)
![GitHub issues](https://img.shields.io/github/issues/Ishan0121/phantom-dlp)
![GitHub license](https://img.shields.io/github/license/Ishan0121/phantom-dlp)

</div>

---

<div align="center">

**Made with ❤️ for the Linux community**

[⭐ Star this project](https://github.com/Ishan0121/phantom-dlp) • [🐛 Report Bug](https://github.com/Ishan0121/phantom-dlp/issues) • [💡 Request Feature](https://github.com/Ishan0121/phantom-dlp/issues)

</div>