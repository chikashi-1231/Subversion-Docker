#!/bin/bash

# 'already pid is running'というエラーを避けるために、pidファイルを削除
rm -f /run/apache2/httpd.pid

# httpd（Apache）をフォアグラウンドで起動
exec /etc/init.d/httpd -DFOREGROUND;