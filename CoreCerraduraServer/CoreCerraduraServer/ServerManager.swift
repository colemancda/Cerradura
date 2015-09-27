//
//  ServerManager.swift
//  CoreCerraduraServer
//
//  Created by Alsey Coleman Miller on 9/20/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import SwiftFoundation
import CoreModel
import NetworkObjects
import CoreCerradura

public final class ServerManager: ServerDataSource, ServerDelegate {
    
    public static let sharedManager = ServerManager()
    
    // MARK: - Properties
    
    public lazy var server: NetworkObjects.Server.HTTP = NetworkObjects.Server.HTTP(model: CoreCerradura.Model.entities, dataSource: self, delegate: self)
    
    // MARK: - ServerDataSource
    
    public func server<T : ServerType>(server: T, storeForRequest request: RequestMessage) -> CoreModel.Store {
        
        return StoreForRequest(request)
    }
    
    public func server<T : ServerType>(server: T, newResourceIDForEntity entity: String) -> String {
        
        return NewResourceID(entity)
    }
    
    public func server<T : ServerType>(server: T, functionsForEntity entity: String) -> [String] {
        
        return CoreCerradura.Model.functions[entity] ?? []
    }
    
    public func server<T : ServerType>(server: T, performFunction functionName: String, forResource resource: Resource, recievedJSON: JSONObject?, context: Server.RequestContext) -> (Int, JSONObject?) {
        
        let functionCode: Int
        
        do {
            
            switch functionName {
                
            // Archive
            case CoreCerradura.ArchiveFunctionName:
                
                guard recievedJSON == nil else { return (HTTP.StatusCode.BadRequest.rawValue, nil) }
                
                functionCode = try ArchiveFunction(resource, context: context)
                
            // Unlock
            case CoreCerradura.Model.Lock.Function.Unlock:
                
                guard recievedJSON == nil else { return (HTTP.StatusCode.BadRequest.rawValue, nil) }
                
                functionCode = try UnlockFunction(resource, context: context)
                
            default: fatalError("Unhandled function: \(functionName)")
            }
        }
        
        catch {
            
            self.server(server, didEncounterInternalError: error, context: context)
            
            return (StatusCode.InternalServerError.rawValue, nil)
        }
        
        return (functionCode, nil)
    }
    
    // MARK: - ServerDelegate
    
    public func server<T : ServerType>(server: T, statusCodeForRequest context: Server.RequestContext) -> Int {
        
        // get authentication
        
        if let _ = context.requestMessage.metadata[RequestHeader.Authorization.rawValue] {
            
            let authenticatedUser: Resource
            
            do {
                guard let resource = try AuthenticateWithHeader(RequestHeader.Authorization.rawValue,
                identifierKey: CoreCerradura.Model.User.Attribute.Username.name,
                secretKey: CoreCerradura.Model.User.Attribute.Password.name,
                entityName: CoreCerradura.Model.User.entityName,
                    context: context)
                    
                else { return HTTP.StatusCode.Unauthorized.rawValue }
                
                authenticatedUser = resource
            }
            
            catch {
                
                self.server(self.server, didEncounterInternalError: error, context: context)
                
                return HTTP.StatusCode.InternalServerError.rawValue
            }
            
            // set in user info
            context.userInfo[ServerUserInfoKey.AuthenticatedUser.rawValue] = authenticatedUser
        }
        
        // check if authentication is required
        
        // check validate initial values
        //serverModelType.willCreate(initialValues, resourceID: resource.resourceID, context: context)
        
        // validate edit
        
        // check if fetch request can be performed
        
        
        return StatusCode.OK.rawValue
    }
    
    public func server<T : ServerType>(server: T, willCreateResource resource: Resource, initialValues: ValuesObject, context: Server.RequestContext) -> ValuesObject {
        
        let serverModelType = ServerModelForEntity(resource.entityName)
        
        return serverModelType.initialValues(initialValues, resourceID: resource.resourceID, context: context)
    }
    
    public func server<T : ServerType>(server: T, willPerformRequest context: Server.RequestContext, var withResponse responseMessage: ResponseMessage) -> ResponseMessage {
        
        func omitValues(var values: ValuesObject, resourceID: String) -> ValuesObject {
            
            let serverModelType = ServerModelForEntity(context.requestMessage.request.entityName)
            
            let ommitedKeys = serverModelType.omittedProperties(resourceID, context: context)
            
            for (key, _) in values {
                
                for ommitedKey in ommitedKeys {
                    
                    if key == ommitedKey {
                        
                        values[key] = nil
                        
                        break
                    }
                }
            }
            
            return values
        }
        
        switch (context.requestMessage.request, responseMessage.response) {
            
        case let (.Get(resource), .Get(values)):
            responseMessage.response = .Get(omitValues(values, resourceID: resource.resourceID))
            
        case let (.Edit(resource, _), .Edit(values)):
            responseMessage.response = .Edit(omitValues(values, resourceID: resource.resourceID))
            
        case let (.Create(_, _), .Create(resourceID, values)):
            responseMessage.response = .Create(resourceID, omitValues(values, resourceID: resourceID))
            
        default: break
        }
        
        return responseMessage
    }
    
    public func server<T : ServerType>(server: T, didEncounterInternalError error: ErrorType, context: Server.RequestContext) {
        
        print("Internal Server Error: \(error)")
    }
}


// MARK: - Supporting Types

public enum ServerUserInfoKey: String {
    
    case AuthenticatedUser
}

