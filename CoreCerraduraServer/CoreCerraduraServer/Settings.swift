//
//  Settings.swift
//  CoreCerraduraServer
//
//  Created by Alsey Coleman Miller on 9/22/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import SwiftFoundation

/// Server Settings
public struct Settings: JSONEncodable, JSONDecodable {
    
    // MARK: - Properties
    
    public var serverPort: Int = 8080
    
    public var authorizationHeaderTimeout: Int = 30
    
    public var unlockCommandDuration: Int = 5
    
    // MARK: - Singleton
    
    /// Loads the server settings from disk.
    public static var sharedSettings: Settings = {
       
        guard let settingsData = try? FileManager.contents(ServerSettingsFilePath),
            let jsonString = String(UTF8Data: settingsData),
            let settingsJSON = JSON.Value(string: jsonString),
            let settings = Settings(JSONValue: settingsJSON)
            else { return Settings() }
        
        return settings
    }()
    
    public func saveSharedSettings() throws {
        
        let jsonData = Settings.sharedSettings.toJSON().toString([.Pretty])!.toUTF8Data()
        
        // write to file
        if FileManager.fileExists(ServerSettingsFilePath) {
            
            try FileManager.setContents(ServerSettingsFilePath, data: jsonData)
        }
        
        /// create new file
        else { try FileManager.createFile(ServerSettingsFilePath, contents: jsonData) }
    }
    
}
// MARK: - JSON

private extension Settings {
    
    private enum JSONKey: String {
        
        case ServerPort
        case AuthorizationHeaderTimeout
        case UnlockCommandDuration
    }
}

public extension Settings {
    
    public init?(JSONValue: JSON.Value) {
        
        guard let jsonObject = JSONValue.objectValue,
            let serverPort = jsonObject[JSONKey.ServerPort.rawValue]?.rawValue as? Int,
            let authorizationHeaderTimeout = jsonObject[JSONKey.AuthorizationHeaderTimeout.rawValue]?.rawValue as? Int,
            let unlockCommandDuration = jsonObject[JSONKey.UnlockCommandDuration.rawValue]?.rawValue as? Int
            else { return nil }
        
        self.serverPort = serverPort
        self.authorizationHeaderTimeout = authorizationHeaderTimeout
        self.unlockCommandDuration = unlockCommandDuration
    }
    
    public func toJSON() -> JSON.Value {
        
        var jsonObject = JSON.Object()
        
        jsonObject[JSONKey.ServerPort.rawValue] = .Number(.Integer(serverPort))
        jsonObject[JSONKey.AuthorizationHeaderTimeout.rawValue] = .Number(.Integer(authorizationHeaderTimeout))
        jsonObject[JSONKey.UnlockCommandDuration.rawValue] = .Number(.Integer(unlockCommandDuration))
        
        return .Object(jsonObject)
    }
}
