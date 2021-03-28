#!/bin/bash

local_path_to_upload=/home/sup/code/valheim/valheim/backups
remote_host_to_upload=ovh.bnowakowski.pl
remote_path_to_upload=/home/sup/web/valheim.bnowakowski.pl/public_html

rsync --partial --progress --rsh=ssh -r $local_path_to_upload $remote_host_to_upload:$remote_path_to_upload

