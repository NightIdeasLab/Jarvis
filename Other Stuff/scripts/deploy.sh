#!/bin/bash

./build_release.sh

# move into place
rm -rf /Applications/Jarvis.app
cp -r ../build/Release/Jarvis.app /Applications/
