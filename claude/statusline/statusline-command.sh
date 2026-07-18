#!/bin/bash
# Claude Code status line — rate-limit windows (time left until reset + % used), context, model

input=$(cat)
now=$(date +%s)

# Compact "4h30m" / "6d12h" / "45m" remaining time from an epoch reset timestamp
time_left() {
  local secs=$(( $1 - now ))
  (( secs < 0 )) && secs=0
  local d=$(( secs / 86400 )) h=$(( secs % 86400 / 3600 )) m=$(( secs % 3600 / 60 ))
  if (( d > 0 )); then
    printf '%dd%dh' "$d" "$h"
  elif (( h > 0 )); then
    printf '%dh%dm' "$h" "$m"
  else
    printf '%dm' "$m"
  fi
}

five_used=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
week_used=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
week_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
ctx_used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')

parts=()

if [ -n "$five_used" ]; then
  label="5h"
  [ -n "$five_reset" ] && label=$(time_left "$five_reset")
  parts+=("${label} ${five_used%.*}%")
fi

if [ -n "$week_used" ]; then
  label="wk"
  [ -n "$week_reset" ] && label=$(time_left "$week_reset")
  parts+=("${label} ${week_used%.*}%")
fi

if [ -n "$ctx_used" ]; then
  parts+=("ctx ${ctx_used%.*}%")
fi

if [ -n "$model" ]; then
  case $model in
    Opus*)   model="Op${model#Opus}" ;;
    Sonnet*) model="Son${model#Sonnet}" ;;
    Haiku*)  model="Hk${model#Haiku}" ;;
  esac
  parts+=("$model")
fi

if [ ${#parts[@]} -gt 0 ]; then
  joined="${parts[0]}"
  for part in "${parts[@]:1}"; do
    joined+="  $part"
  done
  printf "%s" "$joined"
fi
