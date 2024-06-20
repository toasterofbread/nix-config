function fish_command_not_found
    __fish_default_command_not_found_handler $argv
end

#source /opt/asdf-vm/asdf.fish

# NixOS
alias rebuild="sudo nixos-rebuild switch --flake /etc/nixos"
alias dev="clear && nix develop -c fish"
alias killnix="sudo systemctl restart nix-daemon.service && sudo nix-store --gc"
alias fixnix="sudo nix-store --verify --check-contents --repair"
alias locate="nix-locate --top-level -w"

alias dollama="sudo docker start -d -v ollama:/root/.ollama -p 11434:11434 --name ollama -e HSA_OVERRIDE_GFX_VERSION='10.3.0' -e OLLAMA_KEEP_ALIVE=-1 --group-add=video --ipc=host  --privileged --cap-add=SYS_PTRACE --security-opt seccomp=unconfined  ollama/ollama:rocm"
alias audiorelay="NIXPKGS_ALLOW_UNFREE=1 nix run github:JamesReynolds/audiorelay-flake --impure --"

alias anime="cd /mnt/jedi/Movies/Series/[Anime]"
alias vpn="sudo openvpn --config ~/.vpn/default.ovpn"
alias releasenotes="git log --reverse --pretty=format:'- %s%b%n' "

# I cannot fucking find where this sigsegv happens
#alias spms="gdb -ex run spms"

#alias spmplog="adb logcat | grep --color=never -F (adb shell ps | grep com.toasterofbread.spmp.debug | tr -s [:space:] ' ' | cut -d' ' -f2)"
#alias spmplogrelease="adb logcat | grep --color=never -F (adb shell ps | grep com.toasterofbread.spmp | tr -s [:space:] ' ' | cut -d' ' -f2)"
alias song="cd ~/Desktop/曲 && ~/bin/song"
alias fleet="JAVA_HOME=/usr/lib/jvm/java-17-openjdk jetbrains-fleet"

#alias code="/opt/visual-studio-code-insiders/bin/code-insiders"
alias obsreplay="env QT_QPA_PLATFORM=wayland OBS_VKCAPTURE_LINEAR=1 OBS_VKCAPTURE=1 VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/amd_pro_icd64.json obs --enable-feature=UseOzonePlatform --ozone-platform=wayland --startreplaybuffer --minimize-to-tray"
alias ppsspp="PPSSPPSDL"
alias gitnuro="/usr/lib/jvm/java-17-openjdk/bin/java -jar ~/Programs/applications/bin/Gitnuro-linux-x86_64-1.3.1.jar"

#alias clean="sudo pacman -Rcns (pacman -Qdtq) ; sudo pacman -Sc ; flatpak uninstall --unused ; pip cache purge"
#alias cacheclean="sudo pacman -Sc ; "

alias fishrc="nano /etc/nixos/modules/configs/fish/config.fish"
alias protontricks="flatpak run com.github.Matoking.protontricks"
alias clone="git clone"
alias clone1="git clone --depth 1"
alias cloneb="git clone --single-branch -b "
alias g=git
alias gs="git status"
alias gits="git status"
alias c="clear ; printf '\033[2J\033[3J\033[1;1H'"
#alias aur="sudo pacman -Sy && mkdir -p /home/toaster/Downloads/AUR && env --chdir=/home/toaster/Downloads/AUR pkgbuilder"
#alias aurclean="rm -rf /home/toaster/Downloads/AUR"
alias myip="curl ipinfo.io/ip; echo"
alias untar="tar -zxvf"
alias creeper='echo "Aw man"'
alias se=sudo nano
#alias pacr="sudo pacman -R "
#alias pacd="sudo pacman -S --asdeps "
#alias pacs="pacman -Qet"
#alias pacu="sudo pacman -Syu"
alias history="nano /home/toaster/.local/share/fish/fish_history"
#alias winedesktop="wine explorer /desktop=Ex,1920x1080 "
#alias pip3.8="python3.11 -m pip"
#alias http="python -m http.server"
alias copy="wl-copy"
alias calc="gnome-calculator"
alias size="du -sh"
alias windows="sudo grub-reboot 'Windows 10 (on /dev/sda1)' && reboot"
alias rebootwindows=windows
alias yesterdaycommit="git commit --date='Yesterday at 23:00'"
alias daybeforeyesterdaycommit="git commit --date='Two days ago at 23:00'"
alias lite-xl="SDL_VIDEODRIVER=wayland /usr/bin/lite-xl"
alias lite="SDL_VIDEODRIVER=wayland /usr/bin/lite-xl"
alias commit="SDL_VIDEODRIVER=wayland /usr/bin/lite-xl ~/Desktop/Commit"
alias amen="git add . && git status && gitsummary"
alias gedit="gedit -s"

#alias python=python3.11
#alias python3=python3.8

#alias pip="python3.11 -m pip"
#alias pip3="python3.8 -m pip"

alias protontricks="flatpak run com.github.Matoking.protontricks"
alias flatseal="flatpak run com.github.tchx84.Flatseal"

alias cfg="nano ~/.config/hypr/hyprland.conf"
alias mono "pacmd unload-module module-remap-sink > /dev/null ; pacmd load-module module-remap-sink sink_name=mono master=(pacmd list-sinks | grep -m 1 -oP 'name:\s<\K.*(?=>)') channels=2 channel_map=mono,mono && echo 'Mono sink created'"

alias t=tree
alias link=ln
alias n=nano
alias display=cat
alias find="fzf -e"
alias unlock="sudo loginctl unlock-sessions && exit"
alias rm="rm-safe"
alias bat="bat --theme='Catppuccin-mocha'"

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Applications
#alias discord="~/Programs/applications/Discord/Discord"
#alias discord-flatpak="flatpak run com.discordapp.Discord"
alias todo="nano ~/Documents/TODO"
alias ctl="hyprctl"
alias container="hyprcontainer"

#alias sudo="echo '$USER is not in the sudoers file. This incident will be reported.' ||"

# Rpi
alias driveman-mount "ssh -t rpi@192.168.1.222 'sudo driveman mount'"
alias driveman-restartminidlna "ssh -t rpi@192.168.1.222 'sudo systemctl restart minidlna.service'"
alias driveman-status "ssh -t rpi@192.168.1.222 'sudo driveman status'"

# Mount MTP device
alias androidmount "umount ~/AndroidMount/ ; jmtpfs ~/AndroidMount/"

set QT_QPA_PLATFORMTHEME qt5ct

#set fish_greeting (shuf -n 1 ~/Data/fish-greetings.txt)
set fish_greeting ""

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /mnt/ext/LOCALAI/miniconda3/bin/conda
    eval /mnt/ext/LOCALAI/miniconda3/bin/conda "shell.fish" "hook" $argv | source
end
# <<< conda initialize <<<


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/toaster/Downloads/google-cloud-cli-447.0.0-linux-x86_64/google-cloud-sdk/path.fish.inc' ]; . '/home/toaster/Downloads/google-cloud-cli-447.0.0-linux-x86_64/google-cloud-sdk/path.fish.inc'; end

