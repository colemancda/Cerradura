//
//  AuthenticationContext.swift
//  CoreCerradura
//
//  Created by Alsey Coleman Miller on 6/21/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/** Provides the context for authentication. Public information only. */
public protocol AuthenticationContext {
    
    /** The date the authentication context was created. Used to validate expiration. */
    var date: NSDate { get }
    
    /** String formed by cocatenating the values of the authentication context. */
    var concatenatedString: String { get }
}
