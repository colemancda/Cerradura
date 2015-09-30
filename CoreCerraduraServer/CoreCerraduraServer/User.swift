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
    
    public static func canGet(resourceID: String, context: Server.RequestContext) throws -> Int   {
        
        return HTTP.StatusCode.OK.rawValue
    }
    
    public static func canDelete(resourceID: String, context: Server.RequestContext) throws -> Int {
        
        return HTTP.StatusCode.Forbidden.rawValue
    }
    
    public static func canCreate(initialValues: ValuesObject, context: Server.RequestContext) throws -> Int   {
        
        // dont allow same usernames
        guard let username = initialValues[Model.User.Attribute.Username.name]?.rawValue as? String
            else { return HTTP.StatusCode.BadRequest.rawValue }
        
        do {
            
            var fetchRequest = FetchRequest(entityName: Model.User.entityName)
            
            fetchRequest.predicate = Predicate.Comparison(ComparisonPredicate(propertyName: Model.User.Attribute.Username.name, value: Value.Attribute(AttributeValue.String(username))))
            
            try context.store.fetch(fetchRequest)
        }
        
        return HTTP.StatusCode.OK.rawValue
    }
    
    public static func canEdit(changes: ValuesObject, resourceID: String, context: Server.RequestContext) throws -> Int   {
        
        return HTTP.StatusCode.OK.rawValue
    }
    
    public static func canPerformFetchRequest(fetchRequest: FetchRequest, context: Server.RequestContext) throws -> Int   {
        
        guard let _ = context.userInfo[ServerUserInfoKey.AuthenticatedUser.rawValue] as? Resource
            else { return HTTP.StatusCode.Unauthorized.rawValue }
        
        return HTTP.StatusCode.OK.rawValue
    }
    
    public static func initialValues(var initialValues: ValuesObject, resourceID: String, context: Server.RequestContext) -> ValuesObject {
        
        let dateCreated = Date()
        
        initialValues[Model.User.Attribute.Created.name] = .Attribute(.Date(dateCreated))
        
        return initialValues
    }
    
    public static func omittedProperties(resourceID: String, context: Server.RequestContext) -> [String] {
        
        return []
    }
}