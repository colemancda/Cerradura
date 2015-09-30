//
//  Authentication.swift
//  Cerradura
//
//  Created by Alsey Coleman Miller on 6/4/15.
//  Copyright (c) 2015 ColemanCDA. All rights reserved.
//

import Foundation
import KeychainAccess

/** Holds the information for authenticating with the server, and manages storage in the keychain. */
public final class Authentication {
    
    // MARK: - Class Properties
    
    public static let sharedAuthentication = Authentication()
    
    // MARK: - Properties
    
    public private(set) var credentials: Credential?
    
    // MARK: - Functions
    
    public func loadCredentials() -> Bool {
        
        guard let username = try! self.keychain.get(Authentication.KeychainKey.Username.rawValue),
            let password = try! self.keychain.get(Authentication.KeychainKey.Username.rawValue),
            let userID = Preference.UserID.value as String?
            else { self.credentials = nil; return false }
        
        self.credentials = Credential(username: username, password: password, userID: userID)
        
        return true
    }
    
    public func setCredentials(credentials: Credential) {
        
        try! self.keychain.set(credentials.username, key: KeychainKey.Username.rawValue)
        try! self.keychain.set(credentials.password, key: KeychainKey.Password.rawValue)
        Preference.UserID.value = credentials.userID
        
        self.credentials = credentials
    }
    
    public func removeCredentials() {
        
        try! self.keychain.remove(KeychainKey.Username.rawValue)
        try! self.keychain.remove(KeychainKey.Password.rawValue)
        Preference.UserID.value = nil
    }
    
    // MARK: - Private Properties
    
    /** The keychain used for storing the credentials. */
    private let keychain: Keychain
    
    // MARK: - Initialization
    
    public init(keychainIdentifier: String = NSBundle.mainBundle().infoDictionary![kCFBundleIdentifierKey as String] as! String, accessGroup: String? = nil) {
        
        // set keychain
        
        if let accessGroup = accessGroup {
            
            self.keychain = Keychain(service: keychainIdentifier, accessGroup: accessGroup)
        }
        else {
            
            self.keychain = Keychain(service: keychainIdentifier)
        }
    }
    
    
}

public extension Authentication {
    
    public enum KeychainKey: String {
        
        case Username
        case Password
    }
}

public extension Authentication {
    
    public struct Credential {
        
        public var username: String
        
        public var password: String
        
        public var userID: String
        
        public init(username: String, password: String, userID: String) {
            
            self.username = username
            self.password = password
            self.userID = userID
        }
    }
}

