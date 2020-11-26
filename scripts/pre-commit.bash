#!/bin/bash
echo “Running pre-commit hook”
xcodebuild build-for-testing -project MoviesListing.xcodeproj -scheme MoviesListing -destination 'platform=iOS Simulator,name=iPhone 11 Pro,OS=14.2'
if [ $? -ne 0 ]; then
 echo “Tests must pass before commit!”
 exit 1
fi