#!/bin/bash

sudo -iu postgres initdb -D /var/lib/postgres/data
sudo -iu postgres createuser --superuser po"
