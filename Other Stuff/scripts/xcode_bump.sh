#OS X Yosemite v10.10.4	Build 14E46
#OS X Yosemite v10.10.3 Build 14D136
#OS X Yosemite v10.10.2	Build 14C109
#OS X Yosemite v10.10.1	Build 14B25
#OS X Yosemite v10.10	Build 14A389


# xcode-version-bump.sh
# @desc Auto-increment the version number (only) when a project is archived for export.
# @usage
# 1. Select: your Target in Xcode
# 2. Select: Build Phases Tab
# 3. Select: Add Build Phase -> Add Run Script
# 4. Paste code below in to new "Run Script" section
# 5. Check the checkbox "Run script only when installing"
# 6. Drag the "Run Script" below "Link Binaries With Libraries"
# 7. Insure your starting version number is in SemVer format (e.g. 1.0.0)

# This splits a two-decimal version string, such as "0.45.123", allowing us to increment the third position.
VERSIONNUM=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "${PROJECT_DIR}/${INFOPLIST_FILE}")
NEWSUBVERSION=`echo $VERSIONNUM | awk -F "." '{print $3}'`
NEWSUBVERSION=$(($NEWSUBVERSION + 1))
NEWVERSIONSTRING=`echo $VERSIONNUM | awk -F "." '{print $1 "." $2 ".'$NEWSUBVERSION'" }'`
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $NEWVERSIONSTRING" "${PROJECT_DIR}/${INFOPLIST_FILE}"





# xcode-build-bump.sh
# @desc Auto-increment the build number every time the project is run.
# @usage
# 1. Select: your Target in Xcode
# 2. Select: Build Phases Tab
# 3. Select: Add Build Phase -> Add Run Script
# 4. Paste code below in to new "Run Script" section
# 5. Drag the "Run Script" below "Link Binaries With Libraries"
# 6. Insure that your starting build number is set to a whole integer and not a float (e.g. 1, not 1.0)

if [ $CONFIGURATION != "Release" ]; then
    buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${PROJECT_DIR}/${INFOPLIST_FILE}")
    buildNumber=$(($buildNumber + 1))
    /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "${PROJECT_DIR}/${INFOPLIST_FILE}"
fi