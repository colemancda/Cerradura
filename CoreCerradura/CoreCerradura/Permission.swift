//
//  Permission.swift
//  CoreCerradura
//
//  Created by Alsey Coleman Miller on 4/18/15.
//  Copyright (c) 2015 ColemanCDA. All rights reserved.
//

import Foundation
import CoreData

/** A permission encapsulates access control for a specified lock and user. */
final public class Permission: NSManagedObject {
    
    // MARK: - Properties

    // MARK: Attributes
    
    /** Whether this entity is archived or not. Archived entities are basically deleted, but still stored for historical purposes. */
    @NSManaged public var archived: NSNumber
    
    /** Date the permission was created. */
    @NSManaged public var created: NSDate
    
    /** The date this permission goes into effect. */
    @NSManaged public var startDate: NSDate
    
    /** The date this permission becomes invalid. */
    @NSManaged public var endDate: NSDate?
    
    /// The starting time of the time interval the lock can be unlocked.
    ///
    /// -Note: Not applicable for admin / anytime permissions.
    @NSManaged public var scheduledStartTime: NSNumber?
    
    /** The ending time of the time interval the lock can be unlocked. Not applicable for admin / anytime permissions. */
    @NSManaged public var scheduledEndTime: NSNumber?
    
    /** Type of permission. Raw value for PermissionType. */
    @NSManaged public var permissionType: String
    
    // MARK: Relationships
    
    /** The lock this permission is granting access for. */
    @NSManaged public var lock: Lock
    
    /** The user this permssion is granting access to. */
    @NSManaged public var user: User
    
    /** Permissions derived from this permission. */
    @NSManaged public var derivedPermissions: Set<Permission>?
    
    /** Permission this permission was derived from. */
    @NSManaged public var parentPermission: Permission?
    
    /** Actions involving this permission. */
    @NSManaged public var actions: Set<Action>?
    
    // MARK: - Initialization
    
    public override func awakeFromInsert() {
        
        self.created = NSDate()
    }
    
    /*
    // MARK: - Validation
    
    public override func validateForInsert(error: NSErrorPointer) -> Bool {
        
        if !super.validateForInsert(error) {
            
            return false
        }
        
        // omit validation for client
        if !CoreCerraduraServerMode {
            
            return true
        }
        
        // validate
        
        let permissionType = PermissionType(rawValue: self.permissionType)
        
        if permissionType == nil {
            
            return false
        }
        
        // admin and anytime permissions cannot be scheduled
        if (permissionType == .Admin || permissionType == .Anytime) &&
            (scheduledStartTime != nil || scheduledEndTime != nil) {
            
            return false
        }
        
        // end date should be later than start date
        if self.endDate != nil {
            
            return (self.startDate < self.endDate!)
        }
        
        return true
    }*/
}

