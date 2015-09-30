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

internal let Store: NetworkObjects.CoreDataClient<Client.HTTP> = CreateCoreDataStore()

private func CreateCoreDataStore() -> NetworkObjects.CoreDataClient<Client.HTTP> {
    
    guard let serverURL = Preference.ServerURL.value as? String
        else { fatalError("ServerURL Preference is nil") }
    
    let client = Client.HTTP(serverURL: serverURL, model: Model.entities, HTTPClient: HTTP.Client())
    
    // add authentication handler
    
    client.willSendRequest = { (request) in
        
        var headers = [String: String]()
        
        if let credentials = Authentication.sharedAuthentication.credentials {
            
            let authenticationContext = RequestAuthenticationContext(request: request)
            
            headers[RequestHeader.Date.rawValue] = authenticationContext.dateString
            
            let token = authenticationContext.generateToken(credentials.username, secret: credentials.password)
            
            headers[RequestHeader.Authorization.rawValue] = token
        }
        
        return headers
    }
    
    let model = NSManagedObjectModel(contentsOfURL: NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")!)!
    
    let store = CoreDataClient(managedObjectModel: model, client: client)
    
    return store
}

private var SQLiteStore: NSPersistentStore?

/** Loads the persistent store for use with the Cerradura App. */
func LoadPersistentStore(username: String) throws {
    
    let url = SQLiteStoreFileURL(username)
    
    // load SQLite store
    
    SQLiteStore = try Store.managedObjectContext.persistentStoreCoordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
}

func RemovePersistentStore(username: String) throws {
    
    let url = SQLiteStoreFileURL(username)
    
    if NSFileManager.defaultManager().fileExistsAtPath(url.path!) {
        
        // delete file
        
        try NSFileManager.defaultManager().removeItemAtURL(url)
    }
    
    SQLiteStore = nil
}

internal func SQLiteStoreFileURL(username: String) -> NSURL {
    
    let cacheURL = try! NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.CachesDirectory,
        inDomain: NSSearchPathDomainMask.UserDomainMask,
        appropriateForURL: nil,
        create: false)
    
    let fileURL = cacheURL.URLByAppendingPathComponent(username + ".sqlite")
    
    return fileURL
}
