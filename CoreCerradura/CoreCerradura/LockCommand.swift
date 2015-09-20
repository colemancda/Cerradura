//
//  LockCommand.swift
//  CoreCerradura
//
//  Created by Alsey Coleman Miller on 6/21/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import SwiftFoundation

/// Encapsulates a lock command.
public struct LockCommand: JSONEncodable, JSONDecodable {
    
    public var unlock: Bool = false
    
    public var update: Bool = false
    
    public init() { }
}

// MARK: - JSON

public extension LockCommand {
    
    private enum JSONKey: String {
        
        case unlock
        case update
    }
    
    init?(JSONValue: JSON.Value) {
        
        guard let jsonObject = (JSONValue.rawValue as? [String: Any]) as? [String: Bool]
            where jsonObject.count == 2,
            let unlock = jsonObject[JSONKey.unlock.rawValue],
            let update = jsonObject[JSONKey.update.rawValue]
            else { return nil }
        
        self.unlock = unlock
        self.update = update
    }
    
    public func toJSON() -> JSON.Value {
        
        let jsonObject = [JSONKey.unlock.rawValue: JSON.Value.Number(.Boolean(self.unlock)),
            JSONKey.update.rawValue: JSON.Value.Number(.Boolean(self.update))]
        
        return JSON.Value.Object(jsonObject)
    }
}