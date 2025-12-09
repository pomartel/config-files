#!/bin/bash

if [ "$(omarchy-theme-current)" != "Kanagawa" ]; then
	omarchy-theme-set "Kanagawa"
fi

if [ "$(omarchy-font-current)" != "JetBrainsMonoNL Nerd Font" ]; then
	omarchy-font-set "JetBrainsMonoNL Nerd Font"
fi
