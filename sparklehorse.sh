#!/bin/bash

# for file in $(find /Applications/ -name 'Info.plist')
locate Info.plist | grep /Applications/ | while IFS= read -r file;
do
	if grep -q SUFeedURL "${file}"; then
		echo "PLIST: ${file}"
		feed=$(defaults read "${file}" SUFeedURL)
		version=$(defaults read "${file}" CFBundleVersion)
		echo "CURRENT: ${version}"

		echo "FEED: ${feed}"
		curl -s -m 10 "${feed}" > /tmp/feed.xml # max time 10s
		latest=$(grep sparkle:version /tmp/feed.xml | head -n 1 | sed 's/^.*sparkle:version="\([^"]*\)".*$/\1/')
		echo "LATEST: ${latest}"
		echo 
	fi
done
