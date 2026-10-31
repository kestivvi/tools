#!/usr/bin/env bash
# Claude Code status line: model, tokens, and a block for each rate limit window.
# Window block: label, used %, difference from linear use, time to reset.

# format_duration <seconds>: prints one unit. The limits are at 2 units, not 1,
# because "1d" for 1d 20h or "1h" for 1h 50m would hide almost half of the time.
format_duration() {
  if [ "$1" -ge 172800 ]; then
    echo "$(($1 / 86400))d"
  elif [ "$1" -ge 7200 ]; then
    echo "$(($1 / 3600))h"
  else
    echo "$(($1 / 60))m"
  fi
}

# pace <used_pct> <resets_at> <window_seconds>
# Prints the difference between real use and linear use, as time.
# Negative = behind linear use (budget left, green). Positive = ahead (red).
pace() {
  local minutes
  minutes=$(awk -v used="$1" -v resets="$2" -v win="$3" -v now="$(date +%s)" 'BEGIN {
    elapsed = win - (resets - now)
    if (elapsed < 0) elapsed = 0
    if (elapsed > win) elapsed = win
    printf "%d", (used - elapsed / win * 100) / 100 * win / 60
  }')
  if [ "$minutes" -lt 0 ]; then
    printf '\033[32m-%s\033[0m' "$(format_duration $((-minutes * 60)))"
  elif [ "$minutes" -gt 0 ]; then
    printf '\033[1;91m+%s\033[0m' "$(format_duration $((minutes * 60)))"
  else
    printf '\033[0m0m\033[0m'
  fi
}

# add_window <label> <rate_limits_key> <window_seconds>
# Appends one block for a rate limit window. Parts without data are left out.
add_window() {
  local used resets remaining block="$1"
  used=$(echo "$input" | jq -r ".rate_limits.$2.used_percentage // empty")
  resets=$(echo "$input" | jq -r ".rate_limits.$2.resets_at // empty")
  [ -z "$used" ] && [ -z "$resets" ] && return

  # awk, because printf in bash rejects "12.5" in locales with a decimal comma.
  [ -n "$used" ] && block="$block $(awk -v used="$used" 'BEGIN { printf "%.0f%%", used }')"
  [ -n "$used" ] && [ -n "$resets" ] && block="$block $(pace "$used" "$resets" "$3")"
  if [ -n "$resets" ]; then
    remaining=$((resets - $(date +%s)))
    [ "$remaining" -lt 0 ] && remaining=0
    block="$block ↻$(format_duration "$remaining")"
  fi
  out="$out │ $block"
}

input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name')
effort=$(echo "$input" | jq -r '.effort.level // empty')
[ -n "$effort" ] && model="$model $effort"
total_tokens=$(echo "$input" | jq -r '(.context_window.total_input_tokens // 0) + (.context_window.total_output_tokens // 0)')
tokens=$(awk -v n="$total_tokens" 'BEGIN{ if (n<1000) printf "%d", n; else printf "%.1fK", n/1000 }')
out=$(printf '%s │ \033[1;33m%s\033[0m' "$model" "$tokens")
add_window 5h five_hour 18000
add_window 7d seven_day 604800
printf '%s\n' "$out"
