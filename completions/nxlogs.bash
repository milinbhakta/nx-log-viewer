#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════════
# NX Log Viewer - Bash Completion
# ═══════════════════════════════════════════════════════════════════════════════
# Installation:
#   Source this file in your ~/.bashrc:
#     source /path/to/nxlogs.bash
#   
#   Or copy to bash-completion directory:
#     cp nxlogs.bash /etc/bash_completion.d/nxlogs
# ═══════════════════════════════════════════════════════════════════════════════

_nxlogs_get_apps() {
    local log_dir="${LOG_DIR:-logs/nx}"
    local project_root="$PWD"
    
    # Find project root
    while [[ "$project_root" != "/" ]]; do
        if [[ -f "$project_root/nx.json" ]]; then
            break
        fi
        project_root="$(dirname "$project_root")"
    done
    
    # Get apps from log files
    if [[ -d "$project_root/$log_dir" ]]; then
        find "$project_root/$log_dir" -name "*.log" -type f 2>/dev/null | \
            xargs -I{} basename {} .log 2>/dev/null
    fi
}

_nxlogs_completions() {
    local cur prev opts apps
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    # All options
    opts="-h --help -v --version -f --follow -n --lines -a --all -s --search -e --errors"
    opts+=" --since --until --rotate --max-lines --trim-to"
    opts+=" --json --export --quiet"
    opts+=" --stats --apps --clean --init --config --demo"
    opts+=" --no-color --theme"
    
    # Handle option arguments
    case "$prev" in
        -n|--lines|--max-lines|--trim-to)
            # Suggest some common line counts
            COMPREPLY=($(compgen -W "10 25 50 100 200 500 1000 5000 10000" -- "$cur"))
            return 0
            ;;
        -s|--search)
            # No completion for search terms
            return 0
            ;;
        --since|--until)
            # Suggest time expressions
            local time_opts='"1 hour ago" "2 hours ago" "30 minutes ago" "1 day ago" "7 days ago" "1 week ago"'
            COMPREPLY=($(compgen -W "$time_opts" -- "$cur"))
            return 0
            ;;
        --theme)
            COMPREPLY=($(compgen -W "default dark light minimal cyberpunk" -- "$cur"))
            return 0
            ;;
        --export)
            # File completion
            COMPREPLY=($(compgen -f -- "$cur"))
            return 0
            ;;
        --rotate|--demo)
            # App names
            apps=$(_nxlogs_get_apps)
            COMPREPLY=($(compgen -W "$apps all" -- "$cur"))
            return 0
            ;;
    esac
    
    # Complete options if starting with -
    if [[ "$cur" == -* ]]; then
        COMPREPLY=($(compgen -W "$opts" -- "$cur"))
        return 0
    fi
    
    # Complete app names
    apps=$(_nxlogs_get_apps)
    if [[ -n "$apps" ]]; then
        COMPREPLY=($(compgen -W "$apps" -- "$cur"))
    fi
    
    return 0
}

complete -F _nxlogs_completions nxlogs
