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

public struct ServerModel {
    
    /// Whether authentication is required to access the entity
    public var authenticationRequired: (context: Server.RequestContext) -> Bool = { (context) in return true }
    
    /// Asks the reciever whether the initial values are valid. 
    /// Also gives the server a chance to set initial values
    public var willCreate: (initialValues: ValuesObject, resourceID: String) -> ValuesObject = { (initialValues, resourceID) in return $0 }
    
    /// Asks the reciever whether the changes values are valid.
    public static func willEdit: (changes: ValuesObject, resourceID: String) -> Bool
    
    public static func visibleProperties(context: Server.RequestContext, resourceID: String) -> [String]
    
    public init() { }
}


