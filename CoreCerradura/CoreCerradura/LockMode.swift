//
//  LockMode.swift
//  CoreCerradura
//
//  Created by Alsey Coleman Miller on 6/21/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/** Modes for the lock device. */
public enum LockMode {
    
    /** The lock device is in setup mode. */
    case Setup
    
    /** The lock device is in command reciever mode. */
    case CommandReceiver
    
    /** The lock device is in fatal error mode. */
    case FatalError
}