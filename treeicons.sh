#!/bin/sh

myname=${0##*/}

# if ran as a preview for fzf use the fzf previe lines
if [ -z "$FZF_PREVIEW_LINES" ] ; then
    lines=$(tput lines)
    lines=$(( lines -2 ))
else
    lines=$FZF_PREVIEW_LINES
fi

get_icon () {
    icon=""
    ext=$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')
    # echo "-$ext-"
    case "$ext" in
        *"zsh"*|*"ksh"*|*"bash"*|*"fish"*|*"sh"*)
            icon=""
            ;;
        is|init|sysd|service)
            icon=""
            ;;
        c|cpp)
            icon=""
            ;;
        d)
            icon=""
            ;;
        dart)
            icon=""
            ;; 
        db|dump|img|sql)
            icon="" 
            ;;
        iso)
            icon="󰀥"
            ;;
        h|hpp|hxx)
            icon=""
            ;;
        godot|gd|tscn)
            icon=""
            ;;
        *"patch"*|*"diff"*)
            icon=""
            ;;
        editorconfig)
            icon=""
            ;;
        gitconfig)
            icon=""
            ;;
        gitignore)
            icon=""
            ;;
        license|copying)
            icon=""
            ;;
        eula)
            icon=""
            ;;
        hs)
            icon=""
            ;;
        rb)
            icon=""
            ;;
        cbr|cbz|cb7)
            icon=""
            ;;
        rlib|rs)
            icon=""
            ;;
        go)
            icon=""
            ;;
        zig)
            icon=""
            ;;
        py|py*)
            icon=""
            ;;
        lua)
            icon=""
            ;;
        md|rmd)
            icon=""
            ;;
        json)
            icon=""
            ;;
        js)
            icon=""
            ;;
        ts)
            icon=""
            ;;
        java|jar|class)
            icon=""
            ;;
        php)
            icon=""
            ;;
        psd)
            icon=""
            ;;
        ai)
            icon=""
            ;;
        doc|docx)
            icon=""
            ;;
        xls|xls[mx])
            icon=""
            ;;
        ppt|pptx)
            icon=""
            ;;
        *"pdf"*)
            icon=""
            ;;
        exe|msi|dll)
            icon=""
            ;;
        b|bak)
            icon=""
            ;;
        htm|htmx|html|xml)
            icon=""
            ;;
        *"png"*|*"jpg"*|*"jpeg"*|*"webp"*|*"gif"*|*"svg"*|*"ico"*)
            icon=""
            ;;
        *"scss"*|*"css"*)
            icon=""
            ;;
        *"7z"*|*"zip"*|*"rar"*|*"deb"*|*"xz"*)
            icon=""
            ;;
        *"mp4"*|*"mkv"*|*"webm"*|*"flv"*|*"mov"*)
            icon=""
            ;;
        *"mk"*|*"makefile"*)
            icon=""
            ;;
        *"mp3"*|*"m2a"*|*"m4a"*|*"ogg"*|*"wma"*|*"wav"*|*"aac"*|*"flac"*|*"midi"*)
            icon=""
            ;;
        *'git'*'/')
            icon=""
            ;;
        **'/')
            icon=""
            ;;
        *'*')
            icon=""
            ;;
        *"rc"*|*"ini"*|*"conf"*|*"profile"*)
            icon=""
            ;;
        *"vim"*|*"vifm"*)
            icon=""
            ;;
        *"log"*)
            icon=""
            ;;
    esac
    printf '%s' "$icon"
}

add_icon() {
    num=0
    while IFS= read -r REPLY; do
        if [ "${REPLY}" = '' ]; then
            num=-1
        fi
        if [ "$num" -gt "0" ]; then
            prefix="${REPLY%%─ *}─"
            filename="${REPLY##*─ }"
            extension="${filename##*.}"
            icon=$(get_icon "$extension")
            printf '%s %s %s\n' "$prefix" "$icon" "${filename}"
        else
            if [ "$num" -eq "0" ]; then
                printf '┌  [%s]\n' "${REPLY%/*}"
            else
                printf '%s\n' "${REPLY%/*}"
            fi
        fi
        if [ "$num" -ge "0" ]; then
            num=$((num+1))
        fi
    done
}

# usage: is_num "value"
is_num() {
    printf %d "$1" >/dev/null 2>&1
}

show_usage () {
    printf 'usage: %s [-lh] [DIRECTORY]\n' "${myname}"
}

show_help () {
  printf '%s\n'   "${myname}: tree now with icons"
  show_usage
  printf '\n%s\n' "Options:"
  printf '%s\n'   "-l N"
  printf '\t%s\n' "where 'N' is the line height of the display area."
  printf '\t%s\n' "if not provided tput cols will be used to determine the display area"
  printf '\t%s\n' "when called from fzf the \$FZF_PREVIEW_LINES variable is used instead."
  printf '%s\n'   "-h"
  printf '\t%s\n' "show this message"
}

while getopts "l:h" opt; do case "${opt}" in
    l)
        if is_num "$OPTARG"; then
            lines=$OPTARG
        else
            printf '%s: argument for -%s "%s" is not a number\n' "${myname}" "$opt" "$OPTARG" >&2
            exit 1
        fi
    ;;
    h) show_help ; exit 0 ;;
    *)
        printf '%s: invalid option %s\n' "${myname}" "$opt" >&2
        show_usage
        exit 1
        ;;
esac done
shift $(( OPTIND -1 ))

if [ "$#" -gt "0" ]; then
    tree -CFa --filesfirst "$@" | head -n "$lines" | add_icon
else
    tree -CFa --filesfirst "$PWD" | head -n "$lines" | add_icon
fi

