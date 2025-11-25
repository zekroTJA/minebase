#!/usr/bin/env bash

WDIR=/tmp/backup

set -e

source ./scripts/utils.sh

if is_true "$DEBUG_MODE"; then
  set -x
fi

backup_location="${BACKUP_LOCATION:-/var/mcserver/}"

if [[ -f /run/secrets/rcloneconfig ]]; then
    if [[ -d $backup_location ]]; then
        info "Starting backup"
        mkdir -p "$WDIR"

        FILENAME="$1-$(date +"$(eval echo "${BACKUP_FILE_FORMAT}")").zip"

        # Start zipping server
        zip -9rq "${WDIR}/$FILENAME" "$backup_location"

        # Rclone move
        info "Start uploading of backup ${FILENAME}"
        rclone --config /run/secrets/rcloneconfig move "${WDIR}/${FILENAME}" "${BACKUP_TARGET}" -v

        info "Cleaning up old backups"
        rclone --config /run/secrets/rcloneconfig --min-age "${MAX_AGE_BACKUP_FILES}" delete "${BACKUP_TARGET}" -v

        # Delete WDIR
        rm -rf "$WDIR"
        info "Finished backup"
    else
        info "Minecraft server is not initialized"
    fi

else
    info "Backup is disabled"
fi

exit 0
