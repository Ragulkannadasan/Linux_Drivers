#!/bin/bash
sudo cp mt7902-unload.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable mt7902-unload.service
echo "Fix applied! The driver will now unload before shutdown."
