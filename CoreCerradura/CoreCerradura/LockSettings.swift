//
//  LockSettings.swift
//  CoreCerradura
//
//  Created by Alsey Coleman Miller on 6/21/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/** Encapsulates all of the required settings for the lock */
public struct LockSettings {
    
    public let ServerURL: String
    
    public let LockIdentifier: UInt
    
    public let Secret: String
    
    public let RequestInterval: Double
    
    public let NetworkSSID: String
    
    public let NetworkSecret: String
}