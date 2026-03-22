#!/bin/bash
# Claude Code status line — shows rate limit and context usage

input=$(cat)

five_hour_used=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week_used=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
ctx_used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

parts=()

if [ -n "$five_hour_used" ]; then
  five_hour_int=${five_hour_used%.*}
  parts+=("5h: ${five_hour_int}%")
fi

if [ -n "$week_used" ]; then
  week_int=${week_used%.*}
  parts+=("week: ${week_int}%")
fi

if [ -n "$ctx_used" ]; then
  ctx_int=${ctx_used%.*}
  parts+=("ctx: ${ctx_int}%")
fi

if [ ${#parts[@]} -gt 0 ]; then
  printf "%s" "$(IFS=' | '; echo "${parts[*]}")"
fi
