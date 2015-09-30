//
//  Define.swift
//  CoreCerradura
//
//  Created by Alsey Coleman Miller on 12/7/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import CoreData

/** The managed object model for the CoreCerradura framework. */
public func ManagedObjectModel() -> NSManagedObjectModel {
    
    let managedObjectModel = NSManagedObjectModel(contentsOfURL: NSBundle(identifier: CoreCerradura.BundleIdentifier)!.URLForResource("Model", withExtension: "momd")!)!
    
    // Temporary fix for Momc
    do {
        
        let permissionEntity = managedObjectModel.entitiesByName["Per"]!
        
        permissionEntity.name = Model.Permission.entityName
    }
    
    return managedObjectModel
}

// MARK: - Internal

/** The bundle identifier of CoreCerradura. */
public let BundleIdentifier = "com.colemancda.CoreCerradura"

public let CoreDataResourceIDAttributeName = "id"