//
//  ActionType.swift
//  CoreCerradura
//
//  Created by Alsey Coleman Miller on 9/19/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/** Specifies the type of action. */
public enum ActionType: String {
    
    /** A new entity was created. */
    case New
    
    /** An entity has been archived / invalidated. */
    case Archived
    
    /** A lock was unlocked. */
    case Unlock
}