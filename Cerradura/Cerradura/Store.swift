//
//  SharedStore.swift
//  Cerradura
//
//  Created by Alsey Coleman Miller on 6/4/15.
//  Copyright (c) 2015 ColemanCDA. All rights reserved.
//

import Foundation
import SwiftFoundation
import CoreModel
import NetworkObjects
import CoreCerradura
import CoreData

internal let Store: NetworkObjects.CoreDataClient<Client.HTTP> = {
    
    guard let serverURL = Preference.ServerURL.value as? String
        else { fatalError("ServerURL Preference is nil") }
    
    let client = Client.HTTP(serverURL: serverURL, model: Model.entities, HTTPClient: HTTP.Client())
    
    let store = CoreDataClient(managedObjectModel: CoreCerradura.ManagedObjectModel(), client: client)
    
    // add authentication handler
    
    
    
    return store
}()

private var SQLiteStore: NSPersistentStore?

/** Loads the persistent store for use with the Cerradura App. */
func LoadPersistentStore() {
    
    // load SQLite
    
    do { SQLiteStore = try Store.managedObjectContext.persistentStoreCoordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: SQLiteStoreFileURL, options: nil) }
        
    catch {
        
        // Log error, try to delete file, and crash
        
        print("Failed to load SQLite file. \(error)")
        
        RemovePersistentStore()
        
        fatalError()
    }
}

func RemovePersistentStore() {
    
    if NSFileManager.defaultManager().fileExistsAtPath(SQLiteStoreFileURL.path!) {
        
        // delete file
        
        try! NSFileManager.defaultManager().removeItemAtURL(SQLiteStoreFileURL)
    }
    
    SQLiteStore = nil
}

internal let SQLiteStoreFileURL: NSURL = {
    
    let cacheURL = try! NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.CachesDirectory,
        inDomain: NSSearchPathDomainMask.UserDomainMask,
        appropriateForURL: nil,
        create: false)
    
    let fileURL = cacheURL.URLByAppendingPathComponent("data.sqlite")
    
    return fileURL
    }()
