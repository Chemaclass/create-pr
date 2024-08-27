#!/bin/bash
function format_title() {
    input="$1"

    # Initialize prefix and parts as empty
    prefix=""
    part1=""
    part2=""
    part3=""

    # Remove the prefix if it starts with any prefix followed by '/'
    if [[ "$input" =~ ^[^/]+/ ]]; then
        prefix=$(echo "$input" | cut -d'/' -f1)
        input="${input#*/}"

         case "$prefix" in
            fix|bug|bugfix) prefix="Fix" ;;
            *)              prefix="" ;;
        esac
    fi
    # Extract and format parts of the input
    part1=$(echo "$input" | cut -d'-' -f1 | tr '[:lower:]' '[:upper:]')
    part2=$(echo "$input" | cut -d'-' -f2)
    part3=$(echo "$input" | cut -d'-' -f3- | tr '_' ' ' | awk '
    {
        for (i = 1; i <= NF; i++) {
            $i = toupper(substr($i, 1, 1)) tolower(substr($i, 2))
        }
        gsub(/-/, " ", $0)  # Replace remaining hyphens with spaces
        print
    }' | sed 's/ $//')

    # Ensure there is no duplicated "Fix"
    if [[ "$part3" =~ Fix ]]; then
        prefix=""
    fi

    # Construct the final formatted title
    if [[ -n "$prefix" ]]; then
        part3="$(echo "$part3" | tr '[:upper:]' '[:lower:]')"
        echo "$part1-$part2 $prefix $part3"
    else
        echo "$part1-$part2 $part3"
    fi
}

# Extract the TICKET_KEY-[number] from the branch name
function get_ticket_number() {
    branch_name=$1
    echo "$branch_name" | grep -oE "[A-Z]+-[0-9]+" | sed "s~.*-~~"
}

# Find the default label based on the branch prefix
function find_default_label() {
    local branch_name=$1

    # Extract the prefix (the part before the first slash or dash)
    # shellcheck disable=SC2155
    local prefix=$(echo "$branch_name" | sed -E 's@^([^/-]+).*@\1@')

    case "$prefix" in
        feat|feature)
            echo "enhancement"
            ;;
        fix|bug|bugfix)
            echo "bug"
            ;;
        refactor|refactoring)
            echo "refactoring"
            ;;
        docs|documentation)
            echo "documentation"
            ;;
        *)
            echo "enhancement"
            ;;
    esac
}
