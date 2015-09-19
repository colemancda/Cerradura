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
public func CoreCerraduraManagedObjectModel() -> NSManagedObjectModel {
    
    return NSManagedObjectModel(contentsOfURL: NSBundle(identifier: CoreCerraduraBundleIdentifier)!.URLForResource("Model", withExtension: "momd")!)!
}

/** Whether the model objects should behave as they are in server mode. */
public var CoreCerraduraServerMode = false

// MARK: - Internal

/** The bundle identifier of CoreCerradura. */
public let CoreCerraduraBundleIdentifier = "com.colemancda.CoreCerradura"