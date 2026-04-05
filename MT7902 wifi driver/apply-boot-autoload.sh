#!/bin/bash
sudo cp mt7902.conf /etc/modules-load.d/
sudo depmod -a
echo "Boot configuration applied! The mt7902 network driver should now load automatically when your PC starts up."
