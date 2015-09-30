//
//  Authentication.swift
//  CoreCerraduraServer
//
//  Created by Alsey Coleman Miller on 9/23/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import SwiftFoundation
import CoreModel
import NetworkObjects
import CoreCerradura

public func AuthenticateWithHeader(header: String, identifierKey: String, secretKey: String, entityName: String, context: Server.RequestContext) throws -> Resource? {
    
    // parse authentication header
    
    guard let authorizationHeader = context.requestMessage.metadata[header],
        let dateHeader = context.requestMessage.metadata[RequestHeader.Date.rawValue],
        let authenticationContext = RequestAuthenticationContext(request: context.requestMessage.request, dateString: dateHeader),
        let header = JSON.Value(string: authorizationHeader)?.objectValue where header.count == 1,
        let (identifier, tokenJSON) = header.first,
        let token = tokenJSON.rawValue as? String
        else { return nil }
    
    // check that authentication has not expired
    
    let authorizationHeaderTimeout = TimeInterval(Settings.sharedSettings.authorizationHeaderTimeout)
    
    let now = Date()
    
    let expiredDate = authenticationContext.date + authorizationHeaderTimeout
    
    // token expired
    guard now < expiredDate else { return nil }
    
    // search for entity with identifier
    
    let sort = [SortDescriptor(propertyName: identifierKey)]
    
    var fetchRequest = FetchRequest(entityName: entityName, sortDescriptors: sort)
    
    fetchRequest.fetchLimit = 1
    
    let predicate = ComparisonPredicate(propertyName: identifierKey, value: CoreModel.Value.Attribute(.String(identifier)))
    
    fetchRequest.predicate = CoreModel.Predicate.Comparison(predicate)
    
    let fetchResults = try context.store.fetch(fetchRequest)
    
    // cant have multiple users with the same username
    assert(fetchResults.count <= 1)
    
    guard let authenticatedResource = fetchResults.first else { return nil }
    
    let values = try context.store.values(authenticatedResource)
    
    guard let secretValue = values[secretKey]
        else { fatalError("Value not found for secret property: \(secretKey)") }
    
    let secret: String = {
        
        switch secretValue {
            
        case let .Attribute(.String(stringValue)):
            return stringValue
            
        default: fatalError()
        }
    }()
    
    // check if entity is archived
    if let archivedValue = values[ArchivePropertyName] {
        
        let archived: Bool = {
            
            switch archivedValue {
                
            case let .Attribute(.Number(.Boolean(booleanValue))):
                return booleanValue
                
            default: fatalError()
            }
        }()
        
        guard archived == false else { return nil }
    }
    
    // generate authentication token... 
    
    let generatedToken = authenticationContext.generateToken(identifier, secret: secret)
    
    guard generatedToken == token else { return nil }
    
    return authenticatedResource
}

