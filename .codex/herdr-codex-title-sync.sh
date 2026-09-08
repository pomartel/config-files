#!/bin/bash
# Keep Herdr's displayed Codex agent name synchronized with Codex's terminal title.

set -u

pane_id=${HERDR_PANE_ID:-}
herdr_socket=${HERDR_SOCKET_PATH:-}

[[ ${HERDR_ENV:-} == 1 && -n $pane_id && -n $herdr_socket ]] || exit 0

source_id="user:codex-title"
last_title=""

while [[ -S $herdr_socket ]]; do
    pane_json=$(herdr pane get "$pane_id" 2>/dev/null || true)
    title=$(jq -r '.result.pane.terminal_title_stripped // empty' <<<"$pane_json" 2>/dev/null || true)

    # Codex prefixes its title with a spinner and the cwd; keep the actual title.
    title=${title#* | }
    title=${title#* | }

    if [[ -n $title && $title != "$last_title" ]]; then
        herdr pane report-metadata "$pane_id" \
            --source "$source_id" \
            --agent codex \
            --display-agent "$title" >/dev/null 2>&1 || true
        last_title=$title
    fi

    sleep 2
done
