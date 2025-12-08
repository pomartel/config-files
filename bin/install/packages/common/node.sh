#!/bin/bash
if ! command -v node >/dev/null 2>&1; then
	omarchy-install-dev-env node
fi

if ! command -v heroku >/dev/null 2>&1; then
	npm install -g heroku
fi
