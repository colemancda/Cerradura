//
//  ServerModel.swift
//  CoreCerraduraServer
//
//  Created by Alsey Coleman Miller on 9/20/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import SwiftFoundation
import CoreModel
import NetworkObjects
import CoreCerradura

public protocol ServerModel {
    
    // MARK: - Authentication Validation
    
    /// Whether authentication is required to access the entity. 
    static func canGet(resourceID: String, context: Server.RequestContext) -> Bool
    
    /// Whether authentication is required to delete the entity.
    static func canDelete(resourceID: String, context: Server.RequestContext) -> Bool
    
    /// Asks the reciever whether the initial values are valid.
    static func canCreate(initialValues: ValuesObject, resourceID: String, context: Server.RequestContext) -> Bool
    
    /// Asks the reciever whether the changed values are valid.
    static func canEdit(changes: ValuesObject, resourceID: String, context: Server.RequestContext) -> Bool
    
    /// Asks the reciever whether the fetch request can be performed.
    static func canPerformFetchRequest(fetchRequest: FetchRequest, context: Server.RequestContext) -> Bool
    
    // MARK: - Modify Request / Response
    
    /// Asks the reciever to modify / set the initial values.
    static func initialValues(initialValues: ValuesObject, resourceID: String, context: Server.RequestContext) -> ValuesObject
    
    /// Ommited values for a request. (GET, PUT, POST)
    static func omittedProperties(resourceID: String, context: Server.RequestContext) -> [String]
}

public func ServerModelForEntity(entityName: String) -> ServerModel.Type {
    
    switch entityName {
        
    case CoreCerradura.Model.Lock.entityName:
        return CoreCerradura.Model.Lock.self
        
    case CoreCerradura.Model.User.entityName:
        return CoreCerradura.Model.User.self
        
    case CoreCerradura.Model.Permission.entityName:
        return CoreCerradura.Model.Permission.self
        
    case CoreCerradura.Model.Action.entityName:
        return CoreCerradura.Model.Action.self
        
    default: fatalError("Invalid entity name: \(entityName)")
    }
}
