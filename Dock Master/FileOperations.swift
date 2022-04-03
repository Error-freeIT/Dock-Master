//
//  FileOperations.swift
//  Dock Master
//
//  Created by Michael Page on 27/05/2016.
//  Copyright © 2016 Error-free IT. All rights reserved.
//

import Foundation


// This class is primarily for loading and saving plist/mobileconfig files.
class FileOperation {
    
    func readDictionaryFromFile(filename: String) -> NSDictionary? {
        
        let fileManager = NSFileManager.defaultManager()
        
        // If file exists return the contents as a dictionary.
        if fileManager.fileExistsAtPath(filename) {
            return NSDictionary(contentsOfFile: filename)
        } else {
            print("Error: \"\(filename)\" could not be opened!")
            return nil
        }
        
    }
    
    func writeDictionaryToFile(dictionary: NSDictionary, filename: String) {
        
        // Write dictionary into plist file.
        dictionary.writeToFile(filename, atomically: false)
        
    }

    func writeStringToFile(string: String, filename: String, makeExecutable: Bool = false) {
        
        do {
            // Write dictionary into plist file.
            try string.writeToFile(filename, atomically: false, encoding: NSUTF8StringEncoding)
            
            if makeExecutable {
                let fileManager = NSFileManager.defaultManager()
                // A decimal value of 493 is equal to an octal value of 755 (rwxr-xr-x).
                let attributes = ["NSFilePosixPermissions":493]
                try fileManager.setAttributes(attributes, ofItemAtPath: filename)
            }
            
        } catch let error as NSError {
            print(error.description)
        }

    }
    
    func writePackageTemplate(dock: Dock, directory: String) {
        
        let makePackageScript = "#!/bin/bash\n\n" +
            
            "# Name of the package.\n" +
            "NAME=\"\(dock.payloadIdentifier)\"\n\n" +
            
            "# Once installed the identifier is used as the filename for a receipt files in /var/db/receipts/.\n" +
            "IDENTIFIER=\"au.com.errorfreeit.dockmaster.${NAME}\"\n\n" +
            
            "# Package version.\n" +
            "VERSION=\"\(dock.packageVersion)\"\n\n" +

            "# The User Template directory is applied to new user accounts. The dock plist placed in this directory will be copied into new accounts.\n" +
            "INSTALL_LOCATION=\"/System/Library/User Template/English.lproj/Library/Preferences/\"\n\n" +
            
            "# Change into the same directory as this script.\n" +
            "cd \"$(/usr/bin/dirname \"$0\")\"\n\n" +
            
            "# Store the path containing this script.\n" +
            "SCRIPT_PATH=\"$(pwd)\"\n\n" +
            
            "# Build the package.\n" +
            "/usr/bin/pkgbuild \\\n" +
            "    --root \"${SCRIPT_PATH}/payload/\" \\\n" +
            "    --install-location \"$INSTALL_LOCATION\" \\\n" +
            "    --scripts \"$SCRIPT_PATH/scripts/\" \\\n" +
            "    --identifier \"$IDENTIFIER\" \\\n" +
            "    --version \"$VERSION\" \\\n" +
            "    \"${SCRIPT_PATH}/package/${NAME}-${VERSION}.pkg\""
        
        
        let applyDockToExisitingUsers = dock.packageAppliesToExistingUsers ? "true" : "false"

        let postInstallScript = "#!/bin/bash\n\n" +
        
            "# Apply dock to existing user accounts.\n" +
            "APPLY_DOCK_TO_EXISTING_USERS=\(applyDockToExisitingUsers)\n\n" +
        
            "### NOTHING BELOW THIS LINE NEEDS TO CHANGE ###\n\n" +

            "# A dock plist placed in the User Template directory is applied to new user accounts.\n" +
            "USER_TEMPLATE_DOCK_PLIST=\"/System/Library/User Template/English.lproj/Library/Preferences/com.apple.dock.plist\"\n\n" +

            "# Currently logged in user.\n" +
            "CURRENTLY_LOGGED_IN_USER=$(/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }')\n\n" +

            "if [[ \"$APPLY_DOCK_TO_EXISTING_USERS\" == \"true\" ]]\n" +
            "then\n" +
            "    # Output local home directory path (/Users/username).\n" +
            "    for USER_HOME in /Users/*\n" +
            "    do\n" +
            "        # Extract account name (a.k.a. username) from home directory path.\n" +
            "        ACCOUNT_NAME=$(/usr/bin/basename \"${USER_HOME}\")\n\n" +
        
            "        # If account name is not \"Shared\".\n" +
            "        if [[ \"$ACCOUNT_NAME\" != \"Shared\" ]]\n" +
            "        then\n" +
            "            USER_DOCK_PLIST=\"${USER_HOME}/Library/Preferences/com.apple.dock.plist\"\n\n" +

            "            # If the account already contains a dock plist.\n" +
            "            if [[ -f \"$USER_DOCK_PLIST\" ]]\n" +
            "            then\n" +
            "                echo \"Removing existing user dock plist.\"\n" +
            "                /usr/bin/defaults delete \"$USER_DOCK_PLIST\"\n" +
            "           fi\n\n" +

            "            echo \"Copying the latest dock plist into place.\"\n" +
            "            cp \"$USER_TEMPLATE_DOCK_PLIST\" \"$USER_DOCK_PLIST\"\n\n" +
        
            "            echo \"Updating permissions to match user (${ACCOUNT_NAME}).\"\n" +
            "            /usr/sbin/chown -R \"$ACCOUNT_NAME\" \"$USER_DOCK_PLIST\"\n\n" +
        
            "            # Reboot the dock if a user is currently logged in.\n" +
            "            if [[ \"$CURRENTLY_LOGGED_IN_USER\" == \"$ACCOUNT_NAME\" ]]\n" +
            "            then\n" +
            "                # Update cached dock plist.\n" +
            "                /usr/bin/sudo -u \"$ACCOUNT_NAME\" /usr/bin/defaults read \"$USER_DOCK_PLIST\"\n" +
            "                # Relaunch the dock process.\n" +
            "                /usr/bin/killall Dock\n" +
            "            fi\n" +
            "        fi\n" +
            "    done\n" +
            "fi"
        
        
        let fileManager = NSFileManager.defaultManager()
        
        do {
            // Create package, plist and script directories.
            try fileManager.createDirectoryAtPath("\(directory)/package", withIntermediateDirectories: true, attributes: nil)
            try fileManager.createDirectoryAtPath("\(directory)/payload", withIntermediateDirectories: true, attributes: nil)
            try fileManager.createDirectoryAtPath("\(directory)/scripts", withIntermediateDirectories: true, attributes: nil)
            
            // Generate dock plist.
            FileOperation().writeDictionaryToFile(dock.generatePlistXML(),filename: "\(directory)/payload/com.apple.dock.plist")

            // Write makepackage.command into root of directory.
            FileOperation().writeStringToFile(makePackageScript, filename: "\(directory)/makepackage.command", makeExecutable: true)

            // Write postinstall into script directory.
            FileOperation().writeStringToFile(postInstallScript, filename: "\(directory)/scripts/postinstall", makeExecutable: true)
            
        } catch let error as NSError {
            print(error.description)
        }
        
    }
    
}
