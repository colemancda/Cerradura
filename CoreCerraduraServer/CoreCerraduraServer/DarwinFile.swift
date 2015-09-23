//
//  File.swift
//  CoreCerraduraServer
//
//  Created by Alsey Coleman Miller on 12/9/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation

public let ServerApplicationSupportFolderURL: NSURL = {
    
    let folderURL = try! NSFileManager.defaultManager().URLForDirectory(.ApplicationSupportDirectory, inDomain: NSSearchPathDomainMask.LocalDomainMask, appropriateForURL: nil, create: false).URLByAppendingPathComponent("CerraduraServer")
    
    let fileExists = NSFileManager.defaultManager().fileExistsAtPath(folderURL.path!, isDirectory: nil)
    
    if fileExists == false {
        
        // create directory
        try! NSFileManager.defaultManager().createDirectoryAtURL(folderURL, withIntermediateDirectories: true, attributes: nil)
    }
    
    return folderURL
}()

public let ServerSQLiteFileURL = ServerApplicationSupportFolderURL.URLByAppendingPathComponent("data.sqlite")

public let ServerSettingsFilePath = ServerApplicationSupportFolderURL.URLByAppendingPathComponent("serverSettings.json").path!