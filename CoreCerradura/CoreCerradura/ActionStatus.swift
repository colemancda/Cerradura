//
//  ActionStatus.swift
//  CoreCerradura
//
//  Created by Alsey Coleman Miller on 9/19/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/** Specifies the status of the action. */
public enum ActionStatus: String {
    
    /** Action completed. Default value. */
    case Completed
    
    /** Action is pending completion. */
    case Pending
    
    /** Action expired. */
    case Expired
}