//
//  Permission.swift
//  CoreCerraduraServer
//
//  Created by Alsey Coleman Miller on 9/21/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import SwiftFoundation
import CoreModel
import NetworkObjects
import CoreCerradura

extension CoreCerradura.Model.Permission: ServerModel {
    
    public static func canGet(resourceID: String, context: Server.RequestContext) throws -> Int   {
        
        return HTTP.StatusCode.OK.rawValue
    }
    
    public static func canDelete(resourceID: String, context: Server.RequestContext) throws -> Int {
        
        return HTTP.StatusCode.Forbidden.rawValue
    }
    
    public static func canCreate(initialValues: ValuesObject, context: Server.RequestContext) throws -> Int   {
        
        return HTTP.StatusCode.OK.rawValue
    }
    
    public static func canEdit(changes: ValuesObject, resourceID: String, context: Server.RequestContext) throws -> Int   {
        
        return HTTP.StatusCode.OK.rawValue
    }
    
    public static func canPerformFetchRequest(fetchRequest: FetchRequest, context: Server.RequestContext) throws -> Int   {
        
        return HTTP.StatusCode.OK.rawValue
    }
    
    public static func initialValues(var initialValues: ValuesObject, resourceID: String, context: Server.RequestContext) -> ValuesObject {
        
        let dateCreated = Date()
        
        initialValues[CoreCerradura.Model.Permission.Attribute.Created.name] = Value.Attribute(.Date(dateCreated))
        
        return initialValues
    }
    
    public static func omittedProperties(resourceID: String, context: Server.RequestContext) -> [String] {
        
        return []
    }
    
}