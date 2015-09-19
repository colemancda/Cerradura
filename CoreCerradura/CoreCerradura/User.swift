//
//  User.swift
//  CoreCerradura
//
//  Created by Alsey Coleman Miller on 4/18/15.
//  Copyright (c) 2015 ColemanCDA. All rights reserved.
//

import Foundation
import CoreData

public class User: NSManagedObject, Archivable {
    
    // MARK: - Properties
    
    // MARK: Attributes

    /** Whether this entity is archived or not. Archived entities are basically deleted, but still stored for historical purposes. */
    @NSManaged public var archived: NSNumber
    
    /** Date the permission was created. */
    @NSManaged public var created: NSDate
    
    @NSManaged public var email: String
    
    @NSManaged public var emailValidated: NSNumber
    
    @NSManaged public var password: String
    
    @NSManaged public var username: String
    
    // MARK: Relationships
    
    @NSManaged public var actions: Set<Action>?
    
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
}
