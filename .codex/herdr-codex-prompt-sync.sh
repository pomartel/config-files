#!/bin/bash
# Show an abbreviated version of the latest Codex prompt in Herdr.

set -u

pane_id=${HERDR_PANE_ID:-}
herdr_socket=${HERDR_SOCKET_PATH:-}
[[ ${HERDR_ENV:-} == 1 && -n $pane_id && -n $herdr_socket ]] || exit 0

prompt_json=$(cat)
prompt=$(jq -r '(.prompt // .user_prompt // .input // .event.prompt // empty)' <<<"$prompt_json" 2>/dev/null || true)

# Collapse whitespace and keep the label compact enough for the pane header.
prompt=$(tr '\n\r\t' '   ' <<<"$prompt" | sed -E 's/[[:space:]]+/ /g; s/^ //; s/ $//')
[[ -n $prompt ]] || exit 0

max_length=60
if (( ${#prompt} > max_length )); then
    prompt="${prompt:0:max_length-1}…"
fi

herdr pane report-metadata "$pane_id" \
    --source "user:codex-prompt" \
    --agent codex \
    --display-agent "$prompt" >/dev/null 2>&1 || true
