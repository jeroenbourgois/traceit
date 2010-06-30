#!/bin/sh
#!/bin/bash
# Auto Increment Version Script
buildPlist="Info.plist"
CFBuildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBuildNumber" $buildPlist)
CFBuildNumber=$(($CFBuildNumber + 1))
/usr/libexec/PlistBuddy -c "Set :CFBuildNumber $CFBuildNumber" $buildPlist
CFBuildDate=$(date)
/usr/libexec/PlistBuddy -c "Set :CFBuildDate $CFBuildDate" $buildPlist

