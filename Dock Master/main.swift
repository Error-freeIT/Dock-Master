//
//  main.swift
//  Dock Master
//
//  Created by Michael Page on 2/06/2016.
//  Copyright © 2016 Error-free IT. All rights reserved.
//

import Foundation

var generateProfile = Bool()
var generatePackageTemplate = Bool()
var templateFile = String()
var target = String()

func displayHelp() {
    print("Dock Master v0.8\n" +
        "Created by Michael Page on 15/06/2016.\n" +
        "Copyright © 2016 Error-free IT. All rights reserved.\n\n" +

        "Dock Master is a tool for generating dock profiles and dock packages.\n\n" +
        
        "Synopsis: dockmaster [-m | -p] -t template_file target\n\n" +
        
        "Arguments:\n" +
        "    -h, --help          Display this help.\n" +
        "    -m, --mobileconfig  Output dock profile (mobileconfig) file.\n" +
        "    -p, --package       Output dock package template.\n" +
        "    -t, --template      Path to a Dock Master template file.\n\n" +
        
        "Examples:\n" +
        "    Generate a profile:\n" +
        "    dockmaster -m -t dockmastertemplate.plist profile.mobileconfig\n\n" +
        
        "    Generate a package template:\n" +
        "    dockmaster -p -t dockmastertemplate.plist /destination/")
}


if Process.arguments.count < 2 {
    // No arguments were provided.
    displayHelp()
} else {
    var input = Process.arguments
    input.removeFirst()
    var arguments = input
    
    if let lastArgument = arguments.last {
        target = lastArgument
    }
        
    for (index,argument) in arguments.enumerate() {
        
        switch argument {
        case "-h", "--help":
            displayHelp()
        case "-m", "--mobileconfig":
            generateProfile = true
        case "-p", "--package":
            generatePackageTemplate = true
        case "-t", "--template":
            // Assign the argument after -t or --template to templateFile.
            var templateFileIndex = index+1
            // Ensure next index is within arguments array.
            if arguments.count > templateFileIndex {
                templateFile = arguments[templateFileIndex]
            }
        default: break
        }
        
    }
}

if templateFile.isEmpty {
    print("Error: No Dock Master template file specified!")
} else if !generateProfile && !generatePackageTemplate {
    print("Error: An output type (--mobileconfig or --package) was not specified!")
}else {
    let loadedDock = Dock().loadDockTemplate(templateFile)

    if generateProfile {
        FileOperation().writeDictionaryToFile(loadedDock.generateProfileXML(), filename: target)
    } else if generatePackageTemplate {
        FileOperation().writePackageTemplate(loadedDock, directory: target)
    }
}
