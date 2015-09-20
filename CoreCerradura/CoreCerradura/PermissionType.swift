//
//  PermissionType.swift
//  CoreCerradura
//
//  Created by Alsey Coleman Miller on 9/19/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

public enum PermissionType: String {
    
    /// Admin permissions have unlimited access and can distribute keys.
    case Admin
    
    /// Anytime permissions have unlimited access but cannot distribute keys.
    case Anytime
    
    //// Schduled permissions have access during certain hours and can expire.
    case Scheduled
}