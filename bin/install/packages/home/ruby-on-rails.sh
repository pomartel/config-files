#!/bin/bash
if ! command -v rails >/dev/null 2>&1; then
    omarchy-install-dev-env ruby
fi