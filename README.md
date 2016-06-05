# Dock Master

_An Extensive OS X Dock Profile/Package Tool_

#### Introduction

Dock Master is a tool for generating dock profiles and dock packages.

Originally Dock Master was written in PHP and hosted on the [Error-free IT website](http://errorfreeit.com.au). Due to the surprising demand for an offline tool I have rewritten Dock Master in Apple's new programming language [Swift](https://github.com/apple/swift).

#### Usage

In its current form, Dock Master is a command line tool.

1. Install the [latest Dock Master.pkg](https://github.com/Error-freeIT/Dock-Master/releases/latest).

2. Customise the [dockmastertemplate.plist](https://github.com/Error-freeIT/Dock-Master/releases/download/v0.7/dockmastertemplate.plist) in Xcode or your favourite text editor. See the Dock Master Template Options table below for further details.

3. Open Terminal:

* To generate a profile: `dockmaster -m -t dockmastertemplate.plist /destination/profile.mobileconfig`
* To generate a package template: `dockmaster -p -t dockmastertemplate.plist /destination/`

##### Packages vs Profiles
* Profiles are the standard approach for enforcing preferences in OS X.
* Dock Master packages are great for deploying an inital base dock that allows users to further customise as desired. 

#### Dock Master Template Options

|                                   |                                                                                 |                    |                              | 
|-----------------------------------|---------------------------------------------------------------------------------|--------------------|------------------------------| 
| Option                            | Description                                                                     | Applies to Package | Default                      | 
| display_name                      | Name of the profile displayed to the end user                                   | TRUE               | Custom Dock                  | 
| organization                      | Organisation name (e.g. Error-free IT)                                          | FALSE              |                              | 
| description                       | Package description                                                             | FALSE              |                              | 
| scope                             | System or User                                                                  | FALSE              | System                       | 
| contents_immutable                | Prevent dock from being modified                                                |                    | FALSE                        | 
| merge_with_existing_dock          | Merge with any existing dock items                                              | FALSE              | FALSE                        | 
| add_network_home                  | Adds the user's network home folder to the dock                                 |                    | FALSE                        | 
| tile_size                         | Maximum icon size. Value: 1-256                                                 | TRUE               | 68                           | 
| tile_size_immutable               | Lock tile_size                                                                  | FALSE              | FALSE                        | 
| magnification                     | Magnification when hovering over items                                          | TRUE               | FALSE                        | 
| magnification_immutable           | Lock magnification                                                              | FALSE              | FALSE                        | 
| magnification_size                | The level of magnification when hovering over items. Value: 1-256               | TRUE               | 0                            | 
| magnification_size_immutable      | Lock magnification_size                                                         | FALSE              | FALSE                        | 
| position                          | Position of the dock. Value: left, bottom or right                              | TRUE               | bottom                       | 
| position_immutable                | Lock position                                                                   | FALSE              | FALSE                        | 
| minimize_effect                   | Minimise effect. Value: genie or scale                                          | TRUE               | genie                        | 
| animate_app_launch                | Applications animate (bounce) on open                                           |                    | TRUE                         | 
| animate_app_launch_immutable      | Lock animate_app_launch                                                         | FALSE              | FALSE                        | 
| auto_hide                         | Dock hides and only appears on hover                                            | TRUE               | FALSE                        | 
| show_process_indicators           | Display a dot to indicate the application is running                            |                    | TRUE                         | 
| show_process_indicators_immutable | Lock show_process_indicators                                                    | FALSE              | FALSE                        | 
| minimize_into_app                 | Windows minimise into their respective app icon                                 |                    | FALSE                        | 
| minimize_into_app_immutable       | Lock minimize_into_app                                                          | FALSE              | FALSE                        | 
| cfurl_string                      | Path to App or resource                                                         | TRUE               |                              | 
| removable                         | Dock item can be removed                                                        | TRUE               | FALSE                        | 
| label                             | Specify a label (e.g. Network Resources)                                        | TRUE               | Extracted from cfurl_string  | 
| arrangement                       | Sort by. Value: 1=Name, 2=Date Added, 3=Date Modified, 4=Date Created or 5=Kind | TRUE               | 1                            | 
| show_as                           | View content as. Value: 1=Fan, 2=Grid, 3=List or 4=Automatic                    | TRUE               | 4                            | 
| display_as                        | Display as. Value: 1=Folder or 2=Stack                                          | TRUE               | 2                            | 





#### To Do

User Interface
