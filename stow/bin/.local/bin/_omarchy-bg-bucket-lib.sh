# Sourceable library for background bucket resolution.
# Used by omarchy-theme-bg-auto, omarchy-theme-bg-next-period, omarchy-bg-mode.
#
# Buckets: MORNING AFTERNOON DUSK NIGHT CLEAR CLOUDY RAINY
#   - DUSK/NIGHT use the like-named config var directly.
#   - MORNING/AFTERNOON use CLEAR/CLOUDY/RAINY when weather is available,
#     else fall back to MORNING/AFTERNOON.
#
# Override file format (two lines):
#   bucket=NIGHT
#   set_at_period=AFTERNOON
# Override expires (file deleted) when current period != set_at_period.

BG_CONFIG_FILE="$HOME/.config/omarchy/current/theme/backgrounds.conf"
BG_OVERRIDE_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/omarchy/bg-override"
BG_WEATHER_CACHE="/tmp/omarchy-weather-cache"

LATITUDE="38.23N"
LONGITUDE="122.64W"

[[ -f "$BG_CONFIG_FILE" ]] && source "$BG_CONFIG_FILE"

bg_period() {
    if ! command -v sunwait &> /dev/null; then
        echo "UNKNOWN"
        return 1
    fi
    local now sunrise sunset noon=720 dusk_start dusk_end
    now=$(date +%H%M | awk '{h=int($1/100); m=$1%100; print h*60+m}')
    sunrise=$(sunwait list civil "$LATITUDE" "$LONGITUDE" | awk -F', ' '{print $1}' | awk -F: '{print $1*60+$2}')
    sunset=$(sunwait list civil "$LATITUDE" "$LONGITUDE" | awk -F', ' '{print $2}' | awk -F: '{print $1*60+$2}')
    dusk_start=$((sunset - 60))
    dusk_end=$((sunset + 30))

    if [[ $now -ge $sunrise && $now -lt $noon ]]; then
        echo "MORNING"
    elif [[ $now -ge $noon && $now -lt $dusk_start ]]; then
        echo "AFTERNOON"
    elif [[ $now -ge $dusk_start && $now -lt $dusk_end ]]; then
        echo "DUSK"
    else
        echo "NIGHT"
    fi
}

bg_weather() {
    local cache_age=1800
    if [[ -f "$BG_WEATHER_CACHE" ]] && [[ $(($(date +%s) - $(stat -c %Y "$BG_WEATHER_CACHE"))) -lt $cache_age ]]; then
        cat "$BG_WEATHER_CACHE"
        return 0
    fi

    local code
    code=$(curl -fsS --max-time 3 "https://wttr.in/${CITY:-Petaluma}?format=j1" 2>/dev/null \
        | jq -er '.current_condition[0].weatherCode' 2>/dev/null)

    if [[ ! $code =~ ^[0-9]+$ ]]; then
        echo "default"
        return 1
    fi

    case $code in
        113|116)              echo "clear" ;;
        119|122|143|248|260)  echo "cloudy" ;;
        *)                    echo "rainy" ;;
    esac | tee "$BG_WEATHER_CACHE"
}

# Echoes the bucket the system would naturally pick for the current period+weather.
bg_natural_bucket() {
    local period weather bucket
    period=$(bg_period)

    if [[ "$period" == "DUSK" ]] || [[ "$period" == "NIGHT" ]]; then
        echo "$period"
        return 0
    fi

    weather=$(bg_weather)
    if [[ -n "$weather" && "$weather" != "default" ]]; then
        bucket="${weather^^}"
        if [[ -n "${!bucket}" ]]; then
            echo "$bucket"
            return 0
        fi
        if [[ "$weather" == "rainy" && -n "$CLOUDY" ]]; then
            echo "CLOUDY"
            return 0
        fi
    fi

    echo "$period"
}

# Echoes "bucket|set_at_period" if an override is active, else empty.
# Side effect: deletes the override file if expired (period changed).
bg_active_override() {
    [[ -f "$BG_OVERRIDE_FILE" ]] || return 0

    local bucket="" set_at_period=""
    while IFS='=' read -r key value; do
        case "$key" in
            bucket) bucket="$value" ;;
            set_at_period) set_at_period="$value" ;;
        esac
    done < "$BG_OVERRIDE_FILE"

    if [[ -z "$bucket" || -z "$set_at_period" ]]; then
        rm -f "$BG_OVERRIDE_FILE"
        return 0
    fi

    if [[ "$set_at_period" != "$(bg_period)" ]]; then
        rm -f "$BG_OVERRIDE_FILE"
        return 0
    fi

    echo "$bucket|$set_at_period"
}

# Echoes the effective bucket: override if active, otherwise natural.
bg_effective_bucket() {
    local override
    override=$(bg_active_override)
    if [[ -n "$override" ]]; then
        echo "${override%%|*}"
        return 0
    fi
    bg_natural_bucket
}

bg_set_override() {
    local bucket="$1"
    [[ -z "$bucket" ]] && return 1
    mkdir -p "$(dirname "$BG_OVERRIDE_FILE")"
    cat > "$BG_OVERRIDE_FILE" <<EOF
bucket=$bucket
set_at_period=$(bg_period)
EOF
}

bg_clear_override() {
    rm -f "$BG_OVERRIDE_FILE"
}

# Lists buckets that are defined (have at least one wallpaper) in current theme.
bg_available_buckets() {
    local b
    for b in MORNING AFTERNOON DUSK NIGHT CLEAR CLOUDY RAINY; do
        [[ -n "${!b}" ]] && echo "$b"
    done
    return 0
}
