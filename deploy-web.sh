#!/bin/bash

set -e

FLAVOR="prod"
SERVER="root@dev.easyhour.app"
WEBAPP_PATH="/var/www/myopinionrocks.mauriziopinotti.it/"

# Build
flutter clean
flutter pub get
flutter build web --dart-define="flavor=$FLAVOR" --base-href "/"

# Deploy
rsync -avz "build/web/" "$SERVER:$WEBAPP_PATH"
