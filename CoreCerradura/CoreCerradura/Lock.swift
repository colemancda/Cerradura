//
//  Lock.swift
//  CoreCerradura
//
//  Created by Alsey Coleman Miller on 4/18/15.
//  Copyright (c) 2015 ColemanCDA. All rights reserved.
//

import Foundation
import CoreData

/** Entity representing an instance of a physical lock. */
public class Lock: NSManagedObject, Archivable {
    
    // MARK: - Properties
    
    // MARK: Attributes

    /** Whether this entity is archived or not. Archived entities are basically deleted, but still stored for historical purposes. */
    @NSManaged public var archived: NSNumber
    
    /** Date the lock was created. */
    @NSManaged public var created: NSDate
    
    /** Human-readable name for the lock. */
    @NSManaged public var name: String
    
    /** The lock´s secret. Only the owner can see this. */
    @NSManaged public var secret: String
    
    /** The model of the lock. Raw value for LockModel. */
    @NSManaged public var model: String
    
    /** The version of the software currently on the lock. */
    @NSManaged public var version: String
    
    /** The build number of the firmware loaded on the lock. */
    @NSManaged public var firmwareBuild: NSNumber
    
    // MARK: Relationships
    
    /** Actions involving this lock. */
    @NSManaged public var actions: Set<Action>?
    
    /** Permissions granted for this lock. */
    @NSManaged public var permissions: Set<Permission>?
    
    // MARK: - Initialization
    
    public override func awakeFromInsert() {
        
        self.created = NSDate()
    }
    
    // MARK: - Archiveable
    
    public func didArchive() {
        
        // archive permissions
        if self.permissions != nil {
            
            for permission in self.permissions! {
                
                Archive(permission)
            }
        }
    }
    
    // MARK: - Validation
    
    public override func validateForInsert(error: NSErrorPointer) -> Bool {
        
        if !super.validateForInsert(error) {
            
            return false
        }
        
        // omit validation for client
        if !CoreCerraduraServerMode {
            
            return true
        }
        
        if LockModel(rawValue: self.model) == nil {
            
            return false
        }
        
        return true
    }
}

