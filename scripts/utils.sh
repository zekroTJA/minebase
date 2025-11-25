
CYAN="\033[0;36m"
PURPLE="\033[0;35m"
ORANGE="\033[38;5;214m"
HOTPINK="\033[38;5;205m"
RESET="\033[0m"

is_true() {
    local val=${1,,} # convert to lower case
    case "$val" in
        "true" | "t" | "yes" | "1") return 0 ;;
        *) return 1 ;;
    esac
}

notify() {
  script="$1"

  if [ -n "$script" ]; then
    export MESSAGE="$2"
    bash -c "$script"
  fi
}

debug() {
    printf "[ ${HOTPINK}DEBUG${RESET} ] %s\n" "$@"
}

info() {
    printf "[ ${CYAN}INFO${RESET} ] %s\n" "$@"
}

warn() {
    printf "[ ${ORANGE}WARN${RESET} ] %s\n" "$@"
}

error() {
    printf "[ ${PURPLE}ERROR${RESET} ] %s\n" "$@" >&2
}
