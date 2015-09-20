//
//  Model.swift
//  CoreCerradura
//
//  Created by Alsey Coleman Miller on 9/19/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import CoreModel

/// CoreCerradura Model
public struct Model {
    
    public static let entites: CoreModel.Model = {
       
        var model = CoreModel.Model()
        
        model[Lock.entityName]          = Lock.entity
        model[User.entityName]          = User.entity
        model[Action.entityName]        = Action.entity
        model[Permission.entityName]    = Permission.entity
        
        return model
    }()

}

// MARK: - Lock
public extension Model {
    
    /// Entity representing an instance of a physical lock.
    public struct Lock {
        
        public static let entityName = "Lock"
        
        public static let entity: Entity = {
           
            var entity = Entity()
            
            entity.attributes[Attribute.Archived.name]      = Attribute.Archived.property
            entity.attributes[Attribute.Created.name]       = Attribute.Created.property
            entity.attributes[Attribute.Name.name]          = Attribute.Name.property
            entity.attributes[Attribute.Secret.name]        = Attribute.Secret.property
            entity.attributes[Attribute.Model.name]         = Attribute.Model.property
            entity.attributes[Attribute.Version.name]       = Attribute.Version.property
            entity.attributes[Attribute.FirmwareBuild.name] = Attribute.FirmwareBuild.property
            
            entity.relationships[Relationship.Actions.name] = Relationship.Actions.property
            entity.relationships[Relationship.Permissions.name] = Relationship.Permissions.property
            
            return entity
        }()
        
        public struct Attribute {
            
            /// Whether this entity is archived or not. 
            ///
            /// Archived entities are basically deleted, but still stored for historical purposes.
            public static let Archived = (name: "archived", property: CoreModel.Attribute(type: .Number(.Boolean)))
            
            /// Date the lock was created.
            public static let Created = (name: "created", property: CoreModel.Attribute(type: .Date))
            
            /// Human-readable name for the lock.
            public static let Name = (name: "name", property: CoreModel.Attribute(type: .String))
            
            /// The lock´s secret. 
            ///
            /// -Note: Only the owner can see this.
            public static let Secret = (name: "secret", property: CoreModel.Attribute(type: .String))
            
            /// The model of the lock. 
            ///
            /// Raw value for ```LockModel```.
            public static let Model = (name: "model", property: CoreModel.Attribute(type: .String))
            
            /// The version of the software currently on the lock.
            public static let Version = (name: "version", property: CoreModel.Attribute(type: .String))
            
            /// The build number of the firmware loaded on the lock.
            public static let FirmwareBuild = (name: "firmwareBuild", property: CoreModel.Attribute(type: .Number(.Integer)))
        }
        
        public struct Relationship {
            
            /// Actions involving this lock.
            public static let Actions: (name: String, property: CoreModel.Relationship) = {
                
                let property = CoreModel.Relationship(type: RelationshipType.ToMany,
                    optional: true,
                    destinationEntityName: Action.entityName,
                    inverseRelationshipName: Action.Relationship.Lock.name)
               
                return (name: "actions", property: property)
            }()
            
            /// Permissions granted for this lock.
            public static let Permissions: (name: String, property: CoreModel.Relationship) = {
                
                let property = CoreModel.Relationship(type: RelationshipType.ToMany,
                    optional: true,
                    destinationEntityName: Permission.entityName,
                    inverseRelationshipName: Permission.Relationship.Lock.name)
                
                return (name: "permissions", property: property)
                }()
        }
        
        public struct Function {
            
            /// Archives the entity.
            public static let Archive           = "archive"
            
            /// Unlocks the lock.
            public static let Unlock            = "unlock"
        }
    }
}

// MARK: - User
public extension Model {
    
    public struct User {
        
        public static let entityName = "User"
        
        public struct Attribute {
            
            /// Whether this entity is archived or not.
            ///
            /// Archived entities are basically deleted, but still stored for historical purposes.
            public static let Archived          = "archived"
            
            /// Date the user was created.
            public static let Created           = "created"
            
            /// User's email address.
            public static let Email             = "email"
            
            /// Whether the email was validated.
            public static let EmailValidated    = "emailValidated"
            
            /// User's password (Used for authentication).
            public static let Password          = "password"
            
            /// User's username (Used for authentication).
            public static let Username          = "username"
        }
        
        public struct Relationship {
            
            /// Actions involving this user.
            public static let Actions           = "actions"
            
            /// Permissions granted for this user.
            public static let Permissions       = "permissions"
        }
        
        public struct Function {
            
            /// Archives the entity.
            public static let Archive           = "archive"
        }
    }
}

// MARK: - Action
public extension Model {
    
    public struct Action {
        
        public static let entityName = "Action"
        
        public struct Attribute {
            
            /// Date this action ocurred.
            public static let Date              = "date"
            
            /// Type of action. Raw value of ```ActionType```.
            public static let Type              =  "type"
            
            /// Whether the action has been completed. 
            ///
            /// Raw value of ```ActionStatus```.
            public static let Status            = "status"
        }
        
        public struct Relationship {
            
            /// The lock associated with this action.
            public static let Lock: (name: String, property: CoreModel.Relationship) = {
                
                let property = CoreModel.Relationship(type: RelationshipType.ToMany,
                    optional: true,
                    destinationEntityName: Model.Lock.entityName,
                    inverseRelationshipName: Model.Lock.Relationship.Actions.name)
                
                return (name: "lock", property: property)
                }()
            
            /// The user associated with this action.
            public static let User              = "user"
            
            /// The permission associated with this action.
            public static let Permission        = "permission"
        }
    }
}

// MARK: - Permission

public extension Model {
    
    public struct Permission {
        
        public static let entityName = "Permission"
        
        public struct Attribute {
            
            /// Whether this entity is archived or not.
            ///
            /// Archived entities are basically deleted, but still stored for historical purposes.
            public static let Archived          = "archived"
            
            /// Date the permission was created.
            public static let Created           = "created"
            
            /// The date this permission goes into effect.
            public static let StartDate         = "startDate"
            
            /// The date this permission becomes invalid.
            public static let EndDate           = "endDate"
            
            /// The starting time of the time interval the lock can be unlocked.
            ///
            /// -Note: Not applicable for admin / anytime permissions.
            public static let ScheduledStartTime = "scheduledStartTime"
            
            /// The ending time of the time interval the lock can be unlocked. 
            ///
            /// -Note: Not applicable for admin / anytime permissions.
            public static let ScheduledEndTime  = "scheduledEndTime"
            
            /// Type of permission. 
            ///
            /// Raw value for ```PermissionType```.
            public static let PermissionType    = "permissionType"
        }
        
        public struct Relationship {
            
            /// The lock this permission is granting access for.
            public static let Lock: (name: String, property: CoreModel.Relationship) = {
                
                let property = CoreModel.Relationship(type: RelationshipType.ToMany,
                    optional: false,
                    destinationEntityName: Model.Lock.entityName,
                    inverseRelationshipName: Model.Lock.Relationship.Permissions.name)
                
                return (name: "lock", property: property)
                }()
            
            /// The user this permssion is granting access to. 
            public static let User              = "user"
            
            /// Permissions derived from this permission. 
            public static let DerivedPermissions = "derivedPermissions"
            
            /// Permission this permission was derived from. 
            public static let ParentPermission  = "parentPermission"
            
            /// Actions involving this permission. 
            public static let Actions           = "actions"
        }
    }
}




