//
//  UnlockFunction.swift
//  CoreCerraduraServer
//
//  Created by Alsey Coleman Miller on 9/25/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import SwiftFoundation
import CoreModel
import NetworkObjects
import CoreCerradura

/// Unlock Function
public func UnlockFunction(lock: Resource, context: Server.RequestContext) throws -> Int {
    
    guard let authenticatedUser = context.userInfo[ServerUserInfoKey.AuthenticatedUser.rawValue] as? Resource
        else { return HTTP.StatusCode.Unauthorized.rawValue }
    
    var permissionFetchRequest = FetchRequest(entityName: Model.Permission.entityName, sortDescriptors: [])
    
    permissionFetchRequest.fetchLimit = 1
    
    let lockComparison = Predicate.Comparison(ComparisonPredicate(propertyName: Model.Permission.Relationship.Lock.name, value: .Relationship(.ToOne(lock.resourceID))))
    
    let userComparison = Predicate.Comparison(ComparisonPredicate(propertyName: Model.Permission.Relationship.User.name, value: .Relationship(.ToOne(authenticatedUser.resourceID))))
    
    let compoundPredicate = CompoundPredicate(type: CompoundPredicateType.And, subpredicates: [lockComparison, userComparison])
    
    permissionFetchRequest.predicate = Predicate.Compound(compoundPredicate)
    
    guard let permission = try context.store.fetch(permissionFetchRequest).first
        else { return HTTP.StatusCode.Forbidden.rawValue }
    
    // TODO: Verify permission
    
    // create action
    
    var actionValues = ValuesObject()
    
    actionValues[Model.Action.Attribute.ActionType.name] = .Attribute(.String(ActionType.Unlock.rawValue))
    actionValues[Model.Action.Attribute.Status.name] = .Attribute(.String(ActionStatus.Pending.rawValue))
    actionValues[Model.Action.Relationship.Permission.name] = .Relationship(.ToOne(permission.resourceID))
    
    let resourceID = NewResourceID(Model.Action.entityName)
    
    let newAction = Resource(Model.Action.entityName, resourceID)
    
    try context.store.create(newAction, initialValues: actionValues)
    
    return StatusCode.OK.rawValue
}