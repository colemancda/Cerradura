//
//  User.swift
//  CoreCerraduraServer
//
//  Created by Alsey Coleman Miller on 9/21/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import SwiftFoundation
import CoreModel
import NetworkObjects
import CoreCerradura

extension CoreCerradura.Model.User: ServerModel {
    
    public static func validateAuthentication(context: Server.RequestContext) -> Bool {
        
        return true
    }
    
    public static func willCreate(initialValues: ValuesObject, resourceID: String, context: Server.RequestContext) -> Bool {
        
        return true
    }
    
    public static func initialValues(var initialValues: ValuesObject, resourceID: String, context: Server.RequestContext) -> ValuesObject {
        
        let dateCreated = Date()
        
        initialValues[CoreCerradura.Model.User.Attribute.Created.name] = Value.Attribute(.Date(dateCreated))
        
        return initialValues
    }
    
    public static func willEdit(changes: ValuesObject, resourceID: String, context: Server.RequestContext) -> Bool {
        
        return true
    }
    
    public static func omittedProperties(resourceID: String, context: Server.RequestContext) -> [String] {
        
        return []
    }
    
    public static func canPerformFetchRequest(fetchRequest: FetchRequest, context: Server.RequestContext) -> Bool {
        
        return true
    }
}