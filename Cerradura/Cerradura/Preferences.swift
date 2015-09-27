//
//  Preferences.swift
//  Cerradura
//
//  Created by Alsey Coleman Miller on 9/26/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import Foundation

public struct Preference {
    
    public static let ServerURL = UserPreference<NSString>(key: "ServerURL")
    
    /// Stored resource ID for the authenticated user.
    public static let UserID = UserPreference<NSString>(key: "UserID")
}

public struct UserPreference<T: AnyObject> {
    
    public var key: String
    
    public init(key: String) {
        
        self.key = key
    }
    
    public var value: T? {
        
        get { return NSUserDefaults.standardUserDefaults().objectForKey(key) as? T }
        
        set {
            
            guard let newValue = value
                else { NSUserDefaults.standardUserDefaults().removeObjectForKey(key); return }
            
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: key)
            
            guard NSUserDefaults.standardUserDefaults().synchronize()
                else { fatalError("Could not save \(key) to user defaults") }
        }
    }
}

