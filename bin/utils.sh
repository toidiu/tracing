#!/usr/bin/env bash
export WIDTH=12

err() {
    echo -e "\e[31m\e[1merror:\e[0m $*" 1>&2;
}

status() {
    printf "\e[32m\e[1m%${WIDTH}s\e[0m %s\n" "$1" "$2"
}

show_changes() {
    status "Since" "$2"

    local pretty
    if [[ "$VERBOSE" == "--verbose" ]]; then
        pretty="format:%Cgreen%C(bold)%>($WIDTH)%h%Creset %C(bold)%s%Creset%+b"
    else
        pretty="format:%Cgreen%C(bold)%>($WIDTH)%h%Creset %s"
    fi

    git --no-pager log --pretty="$pretty" "$2" -- "$1"
}
