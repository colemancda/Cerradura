//
//  Lock.swift
//  CoreCerraduraServer
//
//  Created by Alsey Coleman Miller on 9/21/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import SwiftFoundation
import CoreModel
import NetworkObjects
import CoreCerradura

extension CoreCerradura.Model.Lock: ServerModel {
    
    public static func canGet(resourceID: String, context: Server.RequestContext) -> Bool {
        
        return true
    }
    
    public static func canCreate(initialValues: ValuesObject, resourceID: String, context: Server.RequestContext) -> Bool {
        
        return true
    }
    
    public static func canEdit(changes: ValuesObject, resourceID: String, context: Server.RequestContext) -> Bool {
        
        return true
    }
    
    public static func canPerformFetchRequest(fetchRequest: FetchRequest, context: Server.RequestContext) -> Bool {
        
        return true
    }
    
    public static func initialValues(var initialValues: ValuesObject, resourceID: String, context: Server.RequestContext) -> ValuesObject {
        
        let dateCreated = Date()
        
        initialValues[CoreCerradura.Model.Lock.Attribute.Created.name] = Value.Attribute(.Date(dateCreated))
        
        return initialValues
    }
    
    public static func omittedProperties(resourceID: String, context: Server.RequestContext) -> [String] {
        
        return []
    }
}