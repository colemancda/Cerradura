//
//  Validate.swift
//  CoreCerradura
//
//  Created by Alsey Coleman Miller on 9/28/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import SwiftFoundation

// MARK: - Lock

// MARK: - User

public extension Model.User {
    
    public struct Validate {
        
        private static let usernameRegex = try! RegularExpression("", options: [])
        
        public static func username(value: String) -> Bool {
            
            return true
        }
    }
}