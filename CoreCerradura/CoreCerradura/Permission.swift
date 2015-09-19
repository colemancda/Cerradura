//
//  Permission.swift
//  CoreCerradura
//
//  Created by Alsey Coleman Miller on 4/18/15.
//  Copyright (c) 2015 ColemanCDA. All rights reserved.
//

import Foundation
import CoreData
import ExSwift

/** A permission encapsulates access control for a specified lock and user. */
public class Permission: NSManagedObject, Archivable {
    
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
    
    /** The starting time of the time interval the lock can be unlocked. Not applicable for admin / anytime permissions. */
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
    
    // MARK: - Archiveable
    
    public func didArchive() {
        
        // archive permissions
        if self.derivedPermissions != nil {
            
            for permission in self.derivedPermissions! {
                
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
    }
}

// MARK: - Enumeration

public enum PermissionType: String {
    
    /// Admin permissions have unlimited access and can distribute keys.
    case Admin
    
    /// Anytime permissions have unlimited access but cannot distribute keys.
    case Anytime
    
    //// Schduled permissions have access during certain hours and can expire.
    case Scheduled
}
