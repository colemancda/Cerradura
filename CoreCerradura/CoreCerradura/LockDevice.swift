//
//  LockDevice.swift
//  CoreCerradura
//
//  Created by Alsey Coleman Miller on 6/21/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/** Encapsulates information about the lock. */
public struct LockDevice {
    
    /** The lock's device model. */
    public let model: LockModel
    
    /** Integer representing the firmware build of the lock. */
    public let firmwareBuild: UInt
    
    public init(model: LockModel = .Simulator, firmwareBuild: UInt = 1) {
        
        self.model = model
        self.firmwareBuild = firmwareBuild
    }
}