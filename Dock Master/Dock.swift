//
//  Dock.swift
//  Dock Master
//
//  Created by Michael Page on 27/05/2016.
//  Copyright © 2016 Error-free IT. All rights reserved.
//

import Foundation


class DockItem {
    
    // tile-type will either be directory-tile: local directory, file-tile: application, url-tile: URL or network share.
    var tileType: String? {
        get {
            func returnTileType(target: String) -> String {
                // If the path contains "://" (CFURL).
                if target.rangeOfString("://") != nil {
                    return "url-tile"
                // If the target has a file extension.
                } else if NSURL(fileURLWithPath: target).pathExtension != "" {
                    return "file-tile"
                } else {
                    return "directory-tile"
                }
            }
            if let unwrappedCfurlString = cfurlString {
                return returnTileType(unwrappedCfurlString)
            } else if let unwrappedHomeDirectoryRelative = homeDirectoryRelative {
                return returnTileType(unwrappedHomeDirectoryRelative)
            } else {
                return nil
            }
        }
    }
    
    // Application name without .app extension (e.g. Safari).
    var fileLabel: String? {
        get {
            // If dock item is an app.
            if tileType == "file-tile" {
                if let unwrappedCfurlString = cfurlString {
                    let path = NSString(string: unwrappedCfurlString)
                    // Remove .app and extract the last part of the file path (e.g. Safari).
                    let appName = path.lastPathComponent
                    return appName
                }
            }
            return nil
        }
    }
    
    // If the dock items cfurlString starts with ~ this key will be set to the value of cfurlString,
    private var _homeDirectoryRelative: String = ""
    var homeDirectoryRelative: String? {
        get {
            if _homeDirectoryRelative != "" {
                return _homeDirectoryRelative
            } else {
                return nil
            }
        }
        set {
            // If newValue is not nil.
            if let unwrappedNewValue = newValue {
                // Store the new value in _displayAs.
                _homeDirectoryRelative = unwrappedNewValue
            } else {
                // Set _homeDirectoryRelative to "" to reflect no preference.
                _homeDirectoryRelative = ""
            }
        }
    }
    
    // Path to resource (e.g. /Applications/App Store.app, smb://server/staffresources, http://www.google.com),
    private var _cfurlString: String = ""
    var cfurlString: String? {
        get {
            if _cfurlString.hasPrefix("~") {
                // Dock item is home directory relative.
                self.homeDirectoryRelative = _cfurlString
                return nil
                // If _cfurlString is no longer it's inital value ("").
            } else if _cfurlString != "" {
                // Return the value it has been set to.
                return _cfurlString
            } else {
                return nil
            }
        }
        set {
            // If newValue is not nil.
            if let unwrappedNewValue = newValue {
                // Store the new value in _displayAs.
                _cfurlString = unwrappedNewValue
            } else {
                // Set _cfurlString to "" to reflect no preference.
                _cfurlString = ""
            }
        }
    }
    
    // cfurlStringType depends on the path style: 0: /Applications/Safari.app, 15: file:///Applications/Safari.app/.
    var cfurlStringType: Int? {
        get {
            if let unwrappedCfurlString = cfurlString {
                // If dock item is not home directory relative, as they do not have a _CFURLStringType key.
                if !unwrappedCfurlString.hasPrefix("~") {
                    // If the path contains :// it's a CFURL string type 15.
                    if unwrappedCfurlString.rangeOfString("://") != nil {
                        return 15
                    } else {
                        return 0
                    }
                }
            }
            return nil
        }
    }
    
    // arrangement (sort by) will be 1: name, 2: date added, 3: date modified, 4: date created or 5: kind.
    // _arrangement is used to backup the computed property.
    private var _arrangement: Int = 0
    var arrangement: Int? {
        get {
            // If _arrangement is no longer it's inital value (0).
            if _arrangement != 0 {
                // Return the value it has been set to.
                return _arrangement
            } else if tileType == "directory-tile" && _arrangement == 0 {
                // It hasn't been set, but is a directory, return the default value (sort by name).
                return 1
            } else {
                return nil
            }
        }
        set {
            // If newValue is not nil.
            if let unwrappedNewValue = newValue {
                // Store the new value in _arrangement.
                _arrangement = unwrappedNewValue
            } else {
                // Set _arrangement to 0 to reflect no preference.
                _arrangement = 0
            }
        }
    }
    
    // showAs (view content as) will be 1: fan, 2: grid, 3: list or 4: automatic.
    // _showAs is used to backup the computed property.
    private var _showAs: Int = 0
    var showAs: Int? {
        get {
            // If _showAs is no longer it's inital value (0).
            if _showAs != 0 {
                // Return the value it has been set to.
                return _showAs
            } else if tileType == "directory-tile" && _showAs == 0 {
                // It hasn't been set, but is a directory, return the default value (view content as automatic).
                return 4
            } else {
                return nil
            }
        }
        set {
            // If newValue is not nil.
            if let unwrappedNewValue = newValue {
                // Store the new value in _showAs.
                _showAs = unwrappedNewValue
            } else {
                // Set _showAs to 0 to reflect no preference.
                _showAs = 0
            }
        }
    }
    
    // displayAs will either be 1: folder or 2: stack.
    // _displayAs is used to backup the computed property.
    private var _displayAs: Int = 0
    var displayAs: Int? {
        get {
            // If _displayAs is no longer it's inital value (0).
            if _displayAs != 0 {
                // Return the value it has been set to.
                return _displayAs
            } else if tileType == "directory-tile" && _displayAs == 0 {
                // It hasn't been set, but is a directory, return the default value (display as a stack).
                return 2
            } else {
                return nil
            }
        }
        set {
            // If newValue is not nil.
            if let unwrappedNewValue = newValue {
                // Store the new value in _displayAs.
                _displayAs = unwrappedNewValue
            } else {
                // Set _displayAs to 0 to reflect no preference.
                _displayAs = 0
            }
        }
    }
    
    // Optional dock item label applied to URLs, shares and home directory relative paths.
    // _label is used to backup the computed property.
    private var _label: String = ""
    var label: String? {
        get {
            // If _label is no longer it's inital value ("").
            if _label != "" {
                // Return the value it has been set to.
                return _label
            } else if tileType == "url-tile" && _label == "" {
                // It hasn't been set. A url-tile (share path) MUST include a label, otherwise it will not be displayed.
                if let unwrappedCfurlString = cfurlString {
                    let path = NSString(string: unwrappedCfurlString)
                    // Remove any extension and extract the last part of the path (e.g. Shared).
                    let extractedLabel = path.lastPathComponent
                    return extractedLabel
                }
            }
            // It's not a url/share.
            return nil
        }
        set {
            // If newValue is not nil.
            if let unwrappedNewValue = newValue {
                // Store the new value in _displayAs.
                _label = unwrappedNewValue
            } else {
                // Set _label to "" to reflect no preference.
                _label = ""
            }
        }
    }
    
    // If removable is set in make the dock item removable. Note: this only applies to plist output, profiles do not support opt.
    var removable: Bool = false
    
    // Note: making an argument optional will allow input to be nil.
    init(cfurlString: String, arrangement: Int? = nil, showAs: Int? = nil, displayAs: Int? = nil, label: String? = nil, removable: Bool? = false) {
        self.cfurlString = cfurlString
    }
    
    func generateDockItemXML() -> [String: AnyObject] {
        
        /*
         let appStructure = ["mcx_typehint":mcxTypeHint!,
                             "tile-type":tileType!,
                             "tile-data":
                                 ["file-label":fileLabel!,
                                  "file-data":
                                     ["_CFURLString":cfurlString!,
                                      "_CFURLStringType":cfurlStringType!
                                     ]
                                 ]
                             ]
         
         let shareStructure = ["mcx_typehint":mcxTypeHint!,
                               "tile-type":tileType!,
                               "tile-data":
                                   ["label":label!,
                                    "url":
                                        ["_CFURLString":cfurlString!,
                                         "_CFURLStringType":cfurlStringType!
                                        ]
                                    ]
                               ]
         
         
         let directoryStructure = ["mcx_typehint":mcxTypeHint!,
                                   "tile-type":tileType!,
                                   "tile-data":
                                       ["file-label":fileLabel!,
                                        "home directory relative":homeDirectoryRelative!,
                                        "arrangement":arrangement!,
                                        "displayas":displayAs!,
                                        "showas":showAs!
                                       ]
                                   ]
         */
        
        var dockItemXML = [String: AnyObject]()
        var tileData = [String: AnyObject]()
        var fileData = [String: AnyObject]()
        
        //dockItemXML["mcx_typehint"] = mcxTypeHint
        
        dockItemXML["tile-type"] = tileType
        
        // ["tile-data"]
        if let unwrappedFileLabel = fileLabel {
            tileData["file-label"] = unwrappedFileLabel
        }
        if let unwrappedhomeDirectoryRelative = homeDirectoryRelative {
            tileData["home directory relative"] = unwrappedhomeDirectoryRelative
        }
        if let unwrappedArrangement = arrangement {
            tileData["arrangement"] = unwrappedArrangement
        }
        if let unwrappedDisplayAs = displayAs {
            tileData["displayas"] = unwrappedDisplayAs
        }
        if let unwrappedShowAs = showAs {
            tileData["showas"] = unwrappedShowAs
        }
        if let unwrappedLabel = label {
            tileData["label"] = unwrappedLabel
        }
        
        // ["file-data"]/["url"]
        if let unwrappedCFURLString = cfurlString {
            fileData["_CFURLString"] = unwrappedCFURLString
        }
        if let unwrappedCFURLStringType = cfurlStringType {
            fileData["_CFURLStringType"] = unwrappedCFURLStringType
        }
        
        
        // If fileData is not empty insert ["file-data"]/["url"] into ["tile-data"].
        if !fileData.isEmpty {
            if let tileType = dockItemXML["tile-type"] as? String {
                // If dock item is a URL use "url" as key instead of "file-data"
                if tileType == "url-tile" {
                    tileData["url"] = fileData
                } else {
                    tileData["file-data"] = fileData
                }
            }
        }
        
        dockItemXML["tile-data"] = tileData
        
        return dockItemXML
    }
    
    
    func convertAppCFURLStringType15ToCFURLStringType0(cfurlStringType15: String) -> String? {
        // Convert file:///Applications/Safari.app/ to /Applications/Safari.app/.
        let pathWithoutScheme = cfurlStringType15.stringByReplacingOccurrencesOfString("file://", withString: "")
        // Convert /Applications/Safari.app/ to /Applications/Safari.app.
        let cfurlStringType0 = NSURL(fileURLWithPath: pathWithoutScheme).path
        return cfurlStringType0
    }

}




class Dock {
    
    // Becomes dockmaster.lowercaseSpacelessDisplayName. Profiles with the same identifier are overwritten.
    var payloadIdentifier: String {
        get {
            let lowercaseSpacelessDisplayName = payloadDisplayName.lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "")
            return lowercaseSpacelessDisplayName
        }
    }
    // Defines whether the profile can be removed.
    // With PayloadRemovalDisallowed set to true, profiles installed manually can only be removed using administrative authority. However if the profile is installed by an MDM, only the MDM can remove the profile (applies to 10.10 and later).
    var payloadRemovalDisallowed: Bool = true
    // Determines if this profile be applied to all users (System) or just the current user (User)?
    var payloadScope: String
    // Currently, a profile payload type can only be Configuration.
    let payloadType = "Configuration"
    // Generates a random Universal Unique Identifier.
    let payloadUUID = NSUUID().UUIDString
    // The version number of the profile format. Currently, this should be 1.
    let payloadVersion = 1
    // Pretty name displayed to users (e.g. Student Dock).
    var payloadDisplayName: String
    // Organization name display to users (e.g. Error-free IT).
    var payloadOrganization: String?
    // Description of the profile (e.g. "Music Lab dock profile").
    var payloadDescription: String?
    
    let dockPayloadType = "com.apple.dock"
    // Currently, all dock payloads are version 1, but Apple may release a new payload version to support additional features.
    let dockPayloadVersion = 1
    // Becomes lowercaseSpacelessDisplayName.
    var dockPayloadIdentifier: String {
        get {
            return "dockmaster.\(payloadIdentifier)"
        }
    }
    // Whether payload should be acted upon.
    let dockPayloadEnabled = true
    // Generates a random Universal Unique Identifier.
    let dockPayloadUUID = NSUUID().UUIDString
    // Payload display name presented to the user during profile install.
    let dockPayloadDisplayName = "Dock"
    // Prevents the dock from being modified.
    var dockContentsImmutable: Bool
    // Removes any existing dock items before adding the dock items in the profile.
    var dockStaticOnly: Bool
    // Arrays of dock applications.
    var dockStaticApps = [DockItem]()
    var dockPersistentApps = [DockItem]()
    // Arrays of dock others (directories, shares and bookmarks).
    var dockStaticOthers = [DockItem]()
    var dockPersistentOthers = [DockItem]()
    // Adds the user's network home folder to the dock. Note: This will add a duplicate if the directory services plugin is also set to add the network home folder to the dock.
    var dockAddNetworkHome: Bool?
    // Sets the tile size (maximum icon size). The value can be anywhere between 1 and 256, (larger number = larger tiles). 68 is OS X's default value.
    var dockTileSize: Int?
    var dockTileSizeImmutable: Bool?
    // Enable magnification when hovering over dock items. OS X disables this feature by default.
    var dockMagnification: Bool?
    var dockMagnificationImmutable: Bool?
    // Sets the level of magnification when hovering over dock items. The value can be anywhere between 1 and 256, (larger number = larger magnification).
    var dockMagnificationSize: Int?
    var dockMagnificationSizeImmutable: Bool?
    // Sets the position of the dock. It can either be left, bottom (default) or right.
    var dockPosition: String?
    var dockPositionImmutable: Bool?
    // Sets the dock minimize effect, it can either be genie (default) or scale.
    var dockMinimizeEffect: String?
    var dockMinimizeEffectImmutable: Bool?
    // Whether applications animate (bounce) on open.
    var dockAnimateAppLaunch: Bool?
    var dockAnimateAppLaunchImmutable: Bool?
    // Whether the dock hides and only appears on hover.
    var dockAutoHide: Bool?
    // Displays a light or black dot (depending on OS X version) to indicate the application is running. OS X enables this feature by default.
    var dockShowProcessIndicators: Bool?
    var dockShowProcessIndicatorsImmutable: Bool?
    // Sets application windows to minimize into their respective application icon. OS X disables this feature by default.
    var dockMinimizeIntoApp: Bool?
    var dockMinimizeIntoAppImmutable: Bool?
    
    init(payloadScope: String = "System", payloadDisplayName: String = "Custom Dock", dockContentsImmutable: Bool = false, dockStaticOnly: Bool = false) {
        
        self.payloadScope = payloadScope
        self.payloadDisplayName = payloadDisplayName
        
        self.dockContentsImmutable = dockContentsImmutable
        self.dockStaticOnly = dockStaticOnly
        
    }
    
    // Add a new dock item to dock array.
    func addNewDockItem(dockItem: DockItem) {
        if dockItem.tileType == "file-tile" {
            if dockItem.removable {
                self.dockPersistentApps.append(dockItem)
            } else {
                self.dockStaticApps.append(dockItem)
            }
        } else {
            if dockItem.removable {
                self.dockPersistentOthers.append(dockItem)
            } else {
                self.dockStaticOthers.append(dockItem)
            }
        }
    }
    
    func generateProfileXML() -> [String: AnyObject] {
        
        var profileXML = [String: AnyObject]()
        var dockPayloadContent = [String: AnyObject]()
        
        profileXML["PayloadIdentifier"] = payloadIdentifier
        profileXML["PayloadRemovalDisallowed"] = payloadRemovalDisallowed
        profileXML["PayloadScope"] = payloadScope
        profileXML["PayloadType"] = payloadType
        profileXML["PayloadUUID"] = payloadUUID
        profileXML["PayloadVersion"] = payloadVersion
        profileXML["PayloadDisplayName"] = payloadDisplayName
        
        if let unwrappedPayloadDescription = payloadDescription {
            profileXML["PayloadDescription"] = unwrappedPayloadDescription
        }
        
        if let unwrappedPayloadOrganization = payloadOrganization {
            profileXML["PayloadOrganization"] = unwrappedPayloadOrganization
        }
        
        dockPayloadContent["PayloadType"] = dockPayloadType
        dockPayloadContent["PayloadVersion"] = dockPayloadVersion
        dockPayloadContent["PayloadIdentifier"] = dockPayloadIdentifier
        dockPayloadContent["PayloadEnabled"] = dockPayloadEnabled
        dockPayloadContent["PayloadUUID"] = dockPayloadUUID
        dockPayloadContent["PayloadDisplayName"] = dockPayloadDisplayName
        dockPayloadContent["contents-immutable"] = dockContentsImmutable
        dockPayloadContent["static-only"] = dockStaticOnly
        
        if let unwrappedDockAddNetworkHome = dockAddNetworkHome {
            if unwrappedDockAddNetworkHome {
                dockPayloadContent["MCXDockSpecialFolders"] = ["AddDockMCXOriginalNetworkHomeFolder"]
            }
        }
        
        if let unwrappedDockTileSize = dockTileSize {
            dockPayloadContent["tilesize"] = unwrappedDockTileSize
        }
        if let unwrappedDockTileSizeImmutable = dockTileSizeImmutable {
            dockPayloadContent["size-immutable"] = unwrappedDockTileSizeImmutable
        }
        
        if let unwrappedDockMagnification = dockMagnification {
            dockPayloadContent["magnification"] = unwrappedDockMagnification
        }
        if let unwrappedDockMagnificationImmutable = dockMagnificationImmutable {
            dockPayloadContent["magnify-immutable"] = unwrappedDockMagnificationImmutable
        }
        
        if let unwrappedDockMagnificationSize = dockMagnificationSize {
            dockPayloadContent["largesize"] = unwrappedDockMagnificationSize
        }
        if let unwrappedDockMagnificationSizeImmutable = dockMagnificationSizeImmutable {
            dockPayloadContent["magsize-immutable"] = unwrappedDockMagnificationSizeImmutable
        }
        
        if let unwrappedDockPosition = dockPosition {
            dockPayloadContent["orientation"] = unwrappedDockPosition
        }
        if let unwrappedDockPositionImmutable = dockPositionImmutable {
            dockPayloadContent["position-immutable"] = unwrappedDockPositionImmutable
        }
        
        if let unwrappedDockMinimizeEffect = dockMinimizeEffect {
            dockPayloadContent["mineffect"] = unwrappedDockMinimizeEffect
        }
        if let unwrappedDockMinimizeEffectImmutable = dockMinimizeEffectImmutable {
            dockPayloadContent["mineffect-immutable"] = unwrappedDockMinimizeEffectImmutable
        }
        
        if let unwrappedDockAnimateAppLaunch = dockAnimateAppLaunch {
            dockPayloadContent["launchanim"] = unwrappedDockAnimateAppLaunch
        }
        if let unwrappedDockAnimateAppLaunchImmutable = dockAnimateAppLaunchImmutable {
            dockPayloadContent["launchanim-immutable"] = unwrappedDockAnimateAppLaunchImmutable
        }
        
        if let unwrappedDockAutoHide = dockAutoHide {
            dockPayloadContent["autohide"] = unwrappedDockAutoHide
        }
        
        if let unwrappedDockShowProcessIndicators = dockShowProcessIndicators {
            dockPayloadContent["show-process-indicators"] = unwrappedDockShowProcessIndicators
        }
        if let unwrappedDockShowProcessIndicatorsImmutable = dockShowProcessIndicatorsImmutable {
            dockPayloadContent["show-process-indicators-immutable"] = unwrappedDockShowProcessIndicatorsImmutable
        }
        
        if let unwrappedDockMinimizeIntoApp = dockMinimizeIntoApp {
            dockPayloadContent["minimize-to-application"] = unwrappedDockMinimizeIntoApp
        }
        if let unwrappedDockMinimizeIntoAppImmutable = dockMinimizeIntoAppImmutable {
            dockPayloadContent["minimize-to-application-immutable"] = unwrappedDockMinimizeIntoAppImmutable
        }
        
        // If dockStaticApps is not empty.
        if !dockStaticApps.isEmpty {
            dockPayloadContent["static-apps"] = generateCombinedDockItemXML(dockStaticApps)
        }
        
        // If dockStaticOthers is not empty.
        if !dockStaticOthers.isEmpty {
            dockPayloadContent["static-others"] = generateCombinedDockItemXML(dockStaticOthers)
        }
        
        profileXML["PayloadContent"] = dockPayloadContent
        
        return profileXML
        
    }
    
    func generatePlistXML() -> [String: AnyObject] {
        
        var plistXML = [String: AnyObject]()
        
        if let unwrappedDockTileSize = dockTileSize {
            plistXML["tilesize"] = unwrappedDockTileSize
        }
        
        if let unwrappedDockMagnification = dockMagnification {
            plistXML["magnification"] = unwrappedDockMagnification
        }
        
        if let unwrappedDockMagnificationSize = dockMagnificationSize {
            plistXML["largesize"] = unwrappedDockMagnificationSize
        }
        
        if let unwrappedDockPosition = dockPosition {
            plistXML["orientation"] = unwrappedDockPosition
        }
        
        if let unwrappedDockMinimizeEffect = dockMinimizeEffect {
            plistXML["mineffect"] = unwrappedDockMinimizeEffect
        }
        
        if let unwrappedDockAnimateAppLaunch = dockAnimateAppLaunch {
            plistXML["launchanim"] = unwrappedDockAnimateAppLaunch
        }
        
        if let unwrappedDockAutoHide = dockAutoHide {
            plistXML["autohide"] = unwrappedDockAutoHide
        }
        
        if let unwrappedDockShowProcessIndicators = dockShowProcessIndicators {
            plistXML["show-process-indicators"] = unwrappedDockShowProcessIndicators
        }
        
        if let unwrappedDockMinimizeIntoApp = dockMinimizeIntoApp {
            plistXML["minimize-to-application"] = unwrappedDockMinimizeIntoApp
        }
        
        // If dockStaticApps is not empty.
        if !dockStaticApps.isEmpty {
            plistXML["static-apps"] = generateCombinedDockItemXML(dockStaticApps)
        }
        
        // If dockPersistentApps is not empty.
        if !dockPersistentApps.isEmpty {
            plistXML["persistent-apps"] = generateCombinedDockItemXML(dockPersistentApps)
        }
        
        // If dockStaticOthers is not empty.
        if !dockStaticOthers.isEmpty {
            plistXML["static-others"] = generateCombinedDockItemXML(dockStaticOthers)
        }
        
        // If dockPersistentOthers is not empty.
        if !dockPersistentOthers.isEmpty {
            plistXML["persistent-others"] = generateCombinedDockItemXML(dockPersistentOthers)
        }
        
        plistXML["version"] = 1
        
        return plistXML
        
    }
    
    private func generateCombinedDockItemXML(dockItems: [DockItem]) -> [[String: AnyObject]] {
        
        var combinedDockItemsXML = [[String: AnyObject]]()
        
        for dockItem in dockItems {
            combinedDockItemsXML.append(dockItem.generateDockItemXML())
        }
        
        return combinedDockItemsXML
        
    }
    
    // Function to load a dock template from file, into a Dock object.
    func loadDockTemplate(templateDockFile: String) -> Dock {
        
        let templateDock = Dock()
        
        if let loadedPlist = FileOperation().readDictionaryFromFile(templateDockFile) {
            
            if let displayName = loadedPlist["display_name"] as? String {
                templateDock.payloadDisplayName = displayName
            }
            
            if let organization = loadedPlist["organization"] as? String {
                templateDock.payloadOrganization = organization
            }
            
            if let description = loadedPlist["description"] as? String {
                templateDock.payloadDescription = description
            }
            
            if let scope = loadedPlist["scope"] as? String {
                templateDock.payloadScope = scope
            }
            
            if let contentsImmutable = loadedPlist["contents_immutable"] as? Bool {
                templateDock.dockContentsImmutable = contentsImmutable
            }
            
            if let mergeWithExistingDock = loadedPlist["merge_with_existing_dock"] as? Bool {
                let staticOnly = !mergeWithExistingDock
                templateDock.dockStaticOnly = staticOnly
            }
            
            if let addNetworkHome = loadedPlist["add_network_home"] as? Bool {
                templateDock.dockAddNetworkHome = addNetworkHome
            }
            
            if let tileSize = loadedPlist["tile_size"] as? Int {
                templateDock.dockTileSize = tileSize
            }
            if let tileSizeImmutable = loadedPlist["tile_size_immutable"] as? Bool {
                templateDock.dockTileSizeImmutable = tileSizeImmutable
            }
            
            if let magnification = loadedPlist["magnification"] as? Bool {
                templateDock.dockMagnification = magnification
            }
            if let magnificationImmutable = loadedPlist["magnification_immutable"] as? Bool {
                templateDock.dockMagnificationImmutable = magnificationImmutable
            }
            
            if let magnificationSize = loadedPlist["magnification_size"] as? Int {
                templateDock.dockMagnificationSize = magnificationSize
            }
            if let magnificationSizeImmutable = loadedPlist["magnification_size_immutable"] as? Bool {
                templateDock.dockMagnificationSizeImmutable = magnificationSizeImmutable
            }
            
            if let position = loadedPlist["position"] as? String {
                templateDock.dockPosition = position
            }
            if let positionImmutable = loadedPlist["position_immutable"] as? Bool {
                templateDock.dockPositionImmutable = positionImmutable
            }
            
            if let minimizeEffect = loadedPlist["minimize_effect"] as? String {
                templateDock.dockMinimizeEffect = minimizeEffect
            }
            if let minimizeEffectImmutable = loadedPlist["minimize_effect_immutable"] as? Bool {
                templateDock.dockMinimizeEffectImmutable = minimizeEffectImmutable
            }
            
            if let animateAppLaunch = loadedPlist["animate_app_launch"] as? Bool {
                templateDock.dockAnimateAppLaunch = animateAppLaunch
            }
            if let animateAppLaunchImmutable = loadedPlist["animate_app_launch_immutable"] as? Bool {
                templateDock.dockAnimateAppLaunchImmutable = animateAppLaunchImmutable
            }
            
            if let autoHide = loadedPlist["auto_hide"] as? Bool {
                templateDock.dockAutoHide = autoHide
            }
            
            if let showProcessIndicators = loadedPlist["show_process_indicators"] as? Bool {
                templateDock.dockShowProcessIndicators = showProcessIndicators
            }
            if let showProcessIndicatorsImmutable = loadedPlist["show_process_indicators_immutable"] as? Bool {
                templateDock.dockShowProcessIndicatorsImmutable = showProcessIndicatorsImmutable
            }
            
            if let minimizeIntoApp = loadedPlist["minimize_into_app"] as? Bool {
                templateDock.dockMinimizeIntoApp = minimizeIntoApp
            }
            if let minimizeIntoAppImmutable = loadedPlist["minimize_into_app_immutable"] as? Bool {
                templateDock.dockMinimizeIntoAppImmutable = minimizeIntoAppImmutable
            }
            
            if let applications = loadedPlist["applications"] {
                for application in applications as! NSArray {
                    
                    if let cfurlString = application["cfurl_string"] as? String {
                        let dockItem = DockItem(cfurlString: cfurlString)
                        dockItem.removable = application["removable"] as? Bool ?? false
                        
                        templateDock.addNewDockItem(dockItem)
                    }
                    
                }
            }
            
            if let others = loadedPlist["others"] {
                for other in others as! NSArray {
                    
                    if let cfurlString = other["cfurl_string"] as? String {
                        let dockItem = DockItem(cfurlString: cfurlString)
                        
                        dockItem.arrangement = other["arrangement"] as? Int ?? nil
                        dockItem.showAs = other["show_as"] as? Int ?? nil
                        dockItem.displayAs = other["display_as"] as? Int ?? nil
                        dockItem.label = other["label"] as? String ?? nil
                        dockItem.removable = other["removable"] as? Bool ?? false
                        
                        templateDock.addNewDockItem(dockItem)
                    }
                    
                }
            }
            
        }
        
        return templateDock
    }
    
}