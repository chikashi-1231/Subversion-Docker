#!/bin/bash

exec /usr/bin/svnserve -d --foreground -r /home/svn/repos --listen-port 3690;