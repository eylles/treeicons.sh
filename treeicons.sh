#!/bin/sh

myname=${0##*/}

# if ran as a preview for fzf use the fzf preview lines
if [ -z "$FZF_PREVIEW_LINES" ] ; then
    lines=$(tput lines)
    lines=$(( lines -2 ))
else
    lines=$FZF_PREVIEW_LINES
fi

# if ran as a preview for fzf use the fzf preview columns
if [ -z "$FZF_PREVIEW_COLUMNS" ] ; then
    columns=$(tput cols)
    columns=$(( columns -1 ))
else
    columns=$FZF_PREVIEW_COLUMNS
fi

get_icon () {
    ext=$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')
    # echo "-$ext-"
    case "$ext" in
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
        *"license"*|*"copying"*)
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
        "md"*|rmd)
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
            icon="󰈬"
            ;;
        xls|xls[mx])
            icon="󰈛"
            ;;
        ppt|pptx)
            icon="󰈧"
            ;;
        *"pdf"*)
            icon=""
            ;;
        exe|msi|dll)
            icon=""
            ;;
        b|bak)
            icon=""
            ;;
        htm|htmx|html|xml)
            icon="󰈮"
            ;;
        *"png"*|*"jpg"*|*"jpeg"*|*"webp"*|*"gif"*|*"svg"*|*"ico"*)
            icon="󰋩"
            ;;
        *"scss"*|*"css"*)
            icon=""
            ;;
        *"7z"*|*"zip"*|*"rar"*|*"deb"*|*"xz"*|*"jar"*|*"gz"*|*"tar"*)
            icon=""
            ;;
        *"mp4"*|*"mkv"*|*"webm"*|*"flv"*|*"mov"*)
            icon=""
            ;;
        *"mp3"*|*"m2a"*|*"m4a"*|*"ogg"*|*"wma"*|*"wav"*|*"aac"*|*"flac"*|*"midi"*)
            icon=""
            ;;
        *'git'*'/')
            icon=""
            ;;
        *'/')
            icon=""
            ;;
        *"makefile"*)
            icon=""
            ;;
        *"mk"*)
            icon=""
            ;;
        *"zsh"*|*"ksh"*|*"bash"*|*"fish"*|*"sh"*)
            icon=""
            ;;
        *'*')
            icon=""
            ;;
        *"rc"*|*"ini"|*"conf"|*"profile"*)
            icon=""
            ;;
        *"vim"*|*"vifm"*)
            icon=""
            ;;
        *"log"*)
            icon=""
            ;;
        *)
            icon=""
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
        if [ "$num" -ge "0" ]; then
            prefix="${REPLY%%─ *}"
            # echo "$prefix"
            filename="${REPLY##*─ }"
            if [ "$prefix" = "$filename" ]; then
                printf '┌  [%s]\n' "${REPLY%/*}"
            else
                extension="${filename##*.}"
                icon=$(get_icon "$extension")
                prefix="${prefix}─"
                printf '%s %s %s\n' "$prefix" "$icon" "${filename}"
            fi
        else
            if [ "$num" -lt "0" ]; then
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
    printf 'usage: %s [-afCh] [-l LINES] [-c COLS] [DIRECTORY]\n' "${myname}"
}

show_help () {
  printf '%s\n'   "${myname}: tree now with icons"
  show_usage
  printf '%s\n' "Options:"
  printf '\t%s'   "-l Num"
  printf '\t%s\n' "where 'Num' is the line height of the display area."
  printf '\t\t%s\n' "if not provided tput lines will be used to determine the display area"
  printf '\t\t%s\n' "when called from fzf the \$FZF_PREVIEW_LINES variable is used instead."
  printf '\t%s'   "-c Num"
  printf '\t%s\n' "where 'Num' is the column width of the display area."
  printf '\t\t%s\n' "if not provided tput cols will be used to determine the display area"
  printf '\t\t%s\n' "when called from fzf the \$FZF_PREVIEW_COLUMNS variable is used instead."
  printf '\t%s'   "-a"
  printf '\t%s\n' "show all files (shows hidden files)"
  printf '\t%s'   "-f"
  printf '\t%s\n' "show files first"
  printf '\t%s'   "-C"
  printf '\t%s\n' "do not constrain output width, this makes '-c' useless"
  printf '\t%s'   "-L"
  printf '\t%s\n' "do not constrain output height, this makes '-l' useless"
  printf '\t%s'   "-h"
  printf '\t%s\n' "show this message"
}

flags=""
noconstrain=""
if [ -n "$NO_CONSTRAIN_TREEICONS" ] ; then
    noconstrain="$NO_CONSTRAIN_TREEICONS"
fi

while getopts "l:c:afhCL" opt; do case "${opt}" in
    l)
        if is_num "$OPTARG"; then
            lines=$OPTARG
        else
            printf '%s: argument for -%s "%s" is not a number\n' "${myname}" "$opt" "$OPTARG" >&2
            exit 1
        fi
    ;;
    c)
        if is_num "$OPTARG"; then
            columns=$OPTARG
        else
            printf '%s: argument for -%s "%s" is not a number\n' "${myname}" "$opt" "$OPTARG" >&2
            exit 1
        fi
    ;;
    h) show_help ; exit 0 ;;
    C) noconstrain="${noconstrain}cols" ;;
    L) noconstrain="${noconstrain}rows" ;;
    a) flags="${flags} -a" ;;
    f) flags="${flags} --filesfirst";;
    *)
        printf '%s: invalid option %s\n' "${myname}" "$opt" >&2
        show_usage
        exit 1
        ;;
esac done
shift $(( OPTIND -1 ))

show_tree () {
    case "$noconstrain" in
        rows)
            tree -CF ${flags} "$@" | add_icon | colrm "$columns"
            ;;
        cols)
            tree -CF ${flags} "$@" | head -n "$lines" | add_icon
            ;;
        rowscols|colsrows)
            tree -CF ${flags} "$@" | add_icon
            ;;
        *)
            tree -CF ${flags} "$@" | head -n "$lines" | add_icon | colrm "$columns"
            ;;
    esac
}

if [ "$#" -gt "0" ]; then
    show_tree "$@"
else
    show_tree "$PWD"
fi

