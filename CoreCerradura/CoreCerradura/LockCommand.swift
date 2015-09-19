//
//  LockCommand.swift
//  CoreCerradura
//
//  Created by Alsey Coleman Miller on 6/21/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/** Encapsulates a lock command. */
public struct LockCommand {
    
    public let shouldUnlock: Bool
    
    public let shouldUpdate: Bool
    
    public init(shouldUnlock: Bool = false, shouldUpdate: Bool = false) {
        
        self.shouldUnlock = shouldUnlock
        self.shouldUpdate = shouldUpdate
    }
}