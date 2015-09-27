//
//  ArchiveFunction.swift
//  CoreCerraduraServer
//
//  Created by Alsey Coleman Miller on 9/25/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import SwiftFoundation
import NetworkObjects
import CoreModel
import CoreCerradura

public protocol ServerArchivable: ServerModel {
    
    static func canArchive(resourceID: String, context: Server.RequestContext) throws -> Bool
    
    static func didArchive(resourceID: String, context: Server.RequestContext) throws
}

public func ArchiveFunction(resource: Resource, context: Server.RequestContext) throws -> Int {
    
    // check if entity can be archived
    guard let serverModelType = ServerModelForEntity(resource.entityName) as? ServerArchivable.Type
        else { fatalError("\(resource.entityName) doesnt conform to ServerArchivable") }
    
    guard try serverModelType.canArchive(resource.resourceID, context: context)
        else { return HTTP.StatusCode.Forbidden.rawValue }
    
    // set archived
    let changes: ValuesObject = [ArchivePropertyName: .Attribute(.Number(.Boolean(true)))]
    
    try context.store.edit(resource, changes: changes)
    
    try serverModelType.didArchive(resource.resourceID, context: context)
    
    return HTTP.StatusCode.OK.rawValue
}