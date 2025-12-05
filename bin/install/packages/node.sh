#!/bin/bash
echo "Installing Node.js development environment..."

omarchy-install-dev-env node

npm install -g @marp-team/marp-cli
npm install -g chokidar-cli
npm install -g heroku