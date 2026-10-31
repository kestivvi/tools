#!/usr/bin/env bash
# Claude Code status line: model, tokens, 5h and 7d rate limits with reset times and pace.

# format_duration <seconds>: prints "Xd Yh", "Xh Ym" or "Ym".
format_duration() {
  local days=$(($1 / 86400)) hours=$(($1 % 86400 / 3600)) minutes=$(($1 % 3600 / 60))
  if [ "$days" -gt 0 ]; then
    echo "${days}d ${hours}h"
  elif [ "$hours" -gt 0 ]; then
    echo "${hours}h ${minutes}m"
  else
    echo "${minutes}m"
  fi
}

# pace <used_pct> <resets_at> <window_seconds>
# Prints the difference between real usage and linear (even) usage, as % and as time.
# Negative = behind the linear pace (budget left, green). Positive = ahead (red).
pace() {
  local color sign percent seconds
  read -r color sign percent seconds < <(
    awk -v used="$1" -v resets="$2" -v win="$3" -v now="$(date +%s)" 'BEGIN{
      elapsed = win - (resets - now)
      if (elapsed < 0) elapsed = 0
      if (elapsed > win) elapsed = win
      delta = used - elapsed / win * 100
      behind = delta < 0
      if (behind) delta = -delta
      printf "%s %s %.0f %d\n", (behind ? "32" : "1;91"), (behind ? "-" : "+"), delta, int(delta / 100 * win / 60) * 60
    }'
  )
  printf '\033[%sm%s%s%% %s%s\033[0m' "$color" "$sign" "$percent" "$sign" "$(format_duration "$seconds")"
}

# add_window <label> <rate_limits_key> <window_seconds>
# Appends one "|"-separated block for a rate limit window. Parts without data are left out.
add_window() {
  local used resets remaining block=""
  used=$(echo "$input" | jq -r ".rate_limits.$2.used_percentage // empty")
  resets=$(echo "$input" | jq -r ".rate_limits.$2.resets_at // empty")
  [ -n "$used" ] && block=$(printf '%.0f%% %s' "$used" "$1")
  if [ -n "$resets" ]; then
    remaining=$((resets - $(date +%s)))
    [ "$remaining" -lt 0 ] && remaining=0
    block="$block${block:+ }↻ $(format_duration "$remaining")"
  fi
  [ -n "$used" ] && [ -n "$resets" ] && block="$block $(pace "$used" "$resets" "$3")"
  [ -n "$block" ] && out="$out | $block"
}

input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name')
effort=$(echo "$input" | jq -r '.effort.level // empty')
[ -n "$effort" ] && model="$model $effort"
total_tokens=$(echo "$input" | jq -r '(.context_window.total_input_tokens // 0) + (.context_window.total_output_tokens // 0)')
tokens=$(awk -v n="$total_tokens" 'BEGIN{ if (n<1000) printf "%d", n; else printf "%.1fK", n/1000 }')
out=$(printf '%s | \033[1;33m%s\033[0m' "$model" "$tokens")
add_window 5h five_hour 18000
add_window 7d seven_day 604800
printf '%s\n' "$out"
