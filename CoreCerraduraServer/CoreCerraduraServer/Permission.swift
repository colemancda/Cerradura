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
    
    public static func authenticationRequired(context: Server.RequestContext) -> Bool {
        
        return true
    }
    
    public static func willCreate(initialValues: ValuesObject, resourceID: String, context: Server.RequestContext) -> Bool {
        
        return true
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