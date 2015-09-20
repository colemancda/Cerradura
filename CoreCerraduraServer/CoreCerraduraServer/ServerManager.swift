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
    
    public func server<T : ServerType>(server: T, functionsForEntity entity: String) -> [String] {
        
        return CoreCerradura.Model.functions[entity] ?? []
    }
    
    public func server<T : ServerType>(server: T, performFunction functionName: String, forResource resource: Resource, recievedJSON: JSONObject?, context: Server.RequestContext) -> (Int, JSONObject?) {
        
        switch functionName {
        
        // Archive
        case CoreCerradura.ArchiveFunctionName:
            
            let changes = [CoreCerradura.ArchivePropertyName: Value.Attribute(.Number(.Boolean(true)))]
            
            do { try context.store.edit(resource, changes: changes) }
            
            catch {
                
                self.server(server, didEncounterInternalError: error, context: context)
                
                return (StatusCode.InternalServerError.rawValue, nil)
            }
            
            return (StatusCode.OK.rawValue, nil)
            
        // Unlock
        case CoreCerradura.Model.Lock.Function.Unlock:
            
            // create action
            
            
            
            return (StatusCode.OK.rawValue, nil)
            
            
        default: fatalError("Unhandled function: \(functionName)")
        }
    }
    
    // MARK: - ServerDelegate
    
    public func server<T : ServerType>(server: T, statusCodeForRequest context: Server.RequestContext) -> Int {
        
        return StatusCode.OK.rawValue
    }
    
    public func server<T : ServerType>(server: T, willCreateResource resource: Resource, var initialValues: ValuesObject, context: Server.RequestContext) -> ValuesObject {
        
        
        
        return initialValues
    }
    
    public func server<T : ServerType>(server: T, willPerformRequest context: Server.RequestContext, withResponse response: ResponseMessage) -> ResponseMessage {
        
        return response
    }
    
    public func server<T : ServerType>(server: T, didEncounterInternalError error: ErrorType, context: Server.RequestContext) {
        
        print("Internal Server Error: \(error)")
    }
}