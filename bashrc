# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
HISTTIMEFORMAT="%Y-%m-%d-%T "
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\W\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \W\a\]\$ "
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -lFh --time-style=long-iso'
alias lla='ls -AlFh --time-style=long-iso'
alias la='ls -AF'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

#########

# ZhangXu Sun Dec 27 00:30:18 CST 2015

#########


alias ..='cd ..'
alias j='jobs -l'
alias d='date +%F-%u-%R'
alias top='top -d 1'
alias temp='watch -n 1 vcgencmd measure_temp'

# systemctl alias
alias scl='sudo systemctl'
alias scls='scl status'
alias jl='journalctl'

alias ls='ls --color=auto'
alias ll='ls -lFh --time-style=long-iso'
alias lla='ls -AlFh --time-style=long-iso'
alias la='ls -AF'
alias l='ls -CF'

alias grep='grep --color=auto'

## docker command

alias dk='docker'
alias di='dk images'
alias dp='dk ps'
alias dh='dk history'
alias da='dk attach'
alias ds='dk start'
alias dt='dk stop'
alias dl='dk logs'
alias dlf='dl --tail 30 -f'
alias dn='dk network'
alias dnl='dk network ls'

recode(){
	local ok='☺ ' err='☹ ' prompt='☘ ' returncode
	if [ $1 -eq 0 ];then
		returncode="$ok"
	else
		returncode="$err"
	fi
	echo "$returncode"
}

PS1='${?:NO}-\u@\h:\W\$ '
PS1='\[\033[01;32m\]$(recode $?)-\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]☘ '

p(){ ps -ef |grep -v grep |grep "$1"; }

pu(){ ps aux |awk '{if($5 != 0) print $0}'; }

pk(){ ps aux |awk '{if($5 == 0) print $0}'; }

mcd(){ mkdir -p "$1" && cd "$1"; }

cls(){ cd "$1" && ls -CF; }

bak(){ cp "$1"{,.bak}; }

mbak(){ mv "$1"{,.bak}; }

ubak(){ mv "$1" ${1%.bak}; }

hp(){ history |grep "$1"; }

duh(){ du -xmd 1 |sort -k 1 -nr |head -n 20; }

dfh(){ df -lh |grep '^/' |sort -k 1; }

mem(){ free -mhlt; }

listen(){ lsof -P -i -n; }

port(){ ss -tulanp |column -t; }

cpsync(){ cp "$1" "$2" && sync -d "$2"; }

weather(){ wget -qO- http://wttr.in; }

bcl(){
	if [ -n "$1" ];then
		echo "$1" |bc -l
	else
		echo "Using: bcl <expr>"
	fi
}

io(){ iostat -m 1; }

iop(){ pidstat --human -d 1; }

cpufreq(){
	watch -n 1 'grep "cpu MHz" /proc/cpuinfo'
}

battery(){
	upower -i $(upower -e |grep BAT)
}

tmuxnew(){
	tmux new -s "$(hostname)"
}

wifi(){
nmcli device wifi rescan
sleep 0.5
nmcli device wifi list
}


#校验合函数生成
for hashsum in md5sum sha1sum sha224dum sha256sum sha384sum sha512sum
do
	eval "${hashsum%sum}check"'(){ '"$hashsum"' "$1" | grep -i "$2" ; }'
done

unset hashsum


###  define fbterm
if [ "$TERM"x == "linux"x ];then
	alias fbterm='LANG=zh_CN.UTF-8 fbterm'
fi


export PYTHONSTARTUP=~/.pythonrc
export PIP_DOWNLOAD_CACHE=~/work/py3_library-cache

# added by Anaconda3 installer
#export PATH="/home/zx/anaconda3/bin:$PATH"
