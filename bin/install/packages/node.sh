#!/bin/bash
omarchy-install-dev-env node

if ! npm list -g @marp-team/marp-cli >/dev/null 2>&1; then
    npm install -g @marp-team/marp-cli
fi

if ! npm list -g chokidar-cli >/dev/null 2>&1; then
    npm install -g chokidar-cli
fi

if ! npm list -g heroku >/dev/null 2>&1; then
    npm install -g heroku
fi