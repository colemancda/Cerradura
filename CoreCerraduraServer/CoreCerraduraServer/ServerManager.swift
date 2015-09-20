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
        
        
    }
    
    public func server<T : ServerType>(server: T, performFunction functionName: String, forResource resource: Resource, recievedJSON: JSONObject?, context: Server.RequestContext) -> (Int, JSONObject?) {
        
        
    }
    
    // MARK: - ServerDelegate
    
    public func server<T : ServerType>(server: T, statusCodeForRequest context: Server.RequestContext) -> Int {
        
        
    }
    
    public func server<T : ServerType>(server: T, willCreateResource resource: Resource, initialValues: ValuesObject, context: Server.RequestContext) -> ValuesObject {
        
        
    }
    
    public func server<T : ServerType>(server: T, willPerformRequest context: Server.RequestContext, withResponse response: ResponseMessage) -> ResponseMessage {
        
        
    }
    
    public func server<T : ServerType>(server: T, didEncounterInternalError error: ErrorType, context: Server.RequestContext) {
        
        
    }
}