#!/usr/bin/env bash
# Claude Code status line: model, tokens, 5h and 7d rate limits with reset times.
input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name')
effort=$(echo "$input" | jq -r '.effort.level // empty')
[ -n "$effort" ] && model="$model $effort"
it=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
ot=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
total=$((it+ot))
tfmt=$(awk -v n="$total" 'BEGIN{ if (n<1000) printf "%d", n
else printf "%.1fK", n/1000 }')
tokens=$(printf '\033[1;33m%s\033[0m' "$tfmt")
pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
wpct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
wresets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
ratestr=""
[ -n "$pct" ] && ratestr=$(printf '%.0f%% 5h' "$pct")
resetstr=""
if [ -n "$resets" ]
then now=$(date +%s)
diff=$((resets-now))
[ "$diff" -lt 0 ] && diff=0
h=$((diff/3600))
m=$(((diff%3600)/60))
if [ "$h" -gt 0 ]
then resetstr="↻ ${h}h ${m}m"
else resetstr="↻ ${m}m"
fi
fi
wratestr=""
[ -n "$wpct" ] && wratestr=$(printf '%.0f%% 7d' "$wpct")
wresetstr=""
if [ -n "$wresets" ]
then now=$(date +%s)
diff=$((wresets-now))
[ "$diff" -lt 0 ] && diff=0
d=$((diff/86400))
h=$(((diff%86400)/3600))
m=$(((diff%3600)/60))
if [ "$d" -gt 0 ]
then wresetstr="↻ ${d}d ${h}h"
elif [ "$h" -gt 0 ]
then wresetstr="↻ ${h}h ${m}m"
else wresetstr="↻ ${m}m"
fi
fi
out="$model | $tokens"
[ -n "$ratestr" ] && out="$out | $ratestr"
[ -n "$resetstr" ] && out="$out | $resetstr"
[ -n "$wratestr" ] && out="$out | $wratestr"
[ -n "$wresetstr" ] && out="$out | $wresetstr"
printf '%s\n' "$out"
