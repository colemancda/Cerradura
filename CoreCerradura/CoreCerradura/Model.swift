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
    
    public static let entities: CoreModel.Model = {
       
        var model = CoreModel.Model()
        
        model[Lock.entityName]          = Lock.entity
        model[User.entityName]          = User.entity
        model[Action.entityName]        = Action.entity
        model[Permission.entityName]    = Permission.entity
        
        return model
    }()
    
    public static let functions: [String: [String]] = {
       
        var functions = [String: [String]]()
        
        functions[Lock.entityName]      = [Lock.Function.Archive, Lock.Function.Unlock]
        
        functions[User.entityName]      = [User.Function.Archive]
        
        functions[Permission.entityName] = [Permission.Function.Archive]
        
        return functions
    }()
}

// MARK: - Lock
public extension Model {
    
    /// Entity representing an instance of a physical lock.
    public struct Lock {
        
        public static let entityName = "Lock"
        
        public static let entity: Entity = {
           
            var entity = Entity()
            
            entity.attributes[Attribute.Archived.name]          = Attribute.Archived.property
            entity.attributes[Attribute.Created.name]           = Attribute.Created.property
            entity.attributes[Attribute.Name.name]              = Attribute.Name.property
            entity.attributes[Attribute.Secret.name]            = Attribute.Secret.property
            entity.attributes[Attribute.Model.name]             = Attribute.Model.property
            entity.attributes[Attribute.Version.name]           = Attribute.Version.property
            entity.attributes[Attribute.FirmwareBuild.name]     = Attribute.FirmwareBuild.property
            
            entity.relationships[Relationship.Actions.name]     = Relationship.Actions.property
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
            public static let Archive = "archive"
            
            /// Unlocks the lock.
            public static let Unlock = "unlock"
        }
    }
}

// MARK: - User
public extension Model {
    
    public struct User {
        
        public static let entityName = "User"
        
        public static let entity: Entity = {
            
            var entity = Entity()
            
            entity.attributes[Attribute.Archived.name]          = Attribute.Archived.property
            entity.attributes[Attribute.Created.name]           = Attribute.Created.property
            entity.attributes[Attribute.Email.name]             = Attribute.Email.property
            entity.attributes[Attribute.EmailValidated.name]    = Attribute.EmailValidated.property
            entity.attributes[Attribute.Password.name]          = Attribute.Password.property
            entity.attributes[Attribute.Username.name]          = Attribute.Username.property
            
            entity.relationships[Relationship.Actions.name]     = Relationship.Actions.property
            entity.relationships[Relationship.Permissions.name] = Relationship.Permissions.property
            
            return entity
            }()
        
        public struct Attribute {
            
            /// Whether this entity is archived or not.
            ///
            /// Archived entities are basically deleted, but still stored for historical purposes.
            public static let Archived = (name: "archived", property: CoreModel.Attribute(type: .Number(.Boolean)))
            
            /// Date the user was created.
            public static let Created = (name: "created", property: CoreModel.Attribute(type: .Date))
            
            /// User's email address.
            public static let Email = (name: "email", property: CoreModel.Attribute(type: .String))
            
            /// Whether the email was validated.
            public static let EmailValidated = (name: "emailValidated", property: CoreModel.Attribute(type: .Number(.Boolean)))
            
            /// User's password (Used for authentication).
            public static let Password = (name: "password", property: CoreModel.Attribute(type: .String))
            
            /// User's username (Used for authentication).
            public static let Username = (name: "username", property: CoreModel.Attribute(type: .String))
        }
        
        public struct Relationship {
            
            /// Actions involving this user.
            public static let Actions: (name: String, property: CoreModel.Relationship) = {
                
                let property = CoreModel.Relationship(type: RelationshipType.ToMany,
                    optional: true,
                    destinationEntityName: Action.entityName,
                    inverseRelationshipName: Action.Relationship.User.name)
                
                return (name: "actions", property: property)
                }()
            
            /// Permissions granted for this user.
            public static let Permissions: (name: String, property: CoreModel.Relationship) = {
                
                let property = CoreModel.Relationship(type: RelationshipType.ToMany,
                    optional: true,
                    destinationEntityName: Permission.entityName,
                    inverseRelationshipName: Permission.Relationship.User.name)
                
                return (name: "permissions", property: property)
                }()
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
        
        public static let entity: Entity = {
            
            var entity = Entity()
            
            entity.attributes[Attribute.Date.name]              = Attribute.Date.property
            entity.attributes[Attribute.ActionType.name]        = Attribute.ActionType.property
            entity.attributes[Attribute.Status.name]            = Attribute.Status.property
            
            entity.relationships[Relationship.Lock.name]        = Relationship.Lock.property
            entity.relationships[Relationship.User.name]        = Relationship.User.property
            entity.relationships[Relationship.Permission.name]  = Relationship.Permission.property
            
            return entity
            }()
        
        public struct Attribute {
            
            /// Date this action ocurred.
            public static let Date = (name: "date", property: CoreModel.Attribute(type: .Date))
            
            /// Type of action. Raw value of ```ActionType```.
            public static let ActionType = (name: "type", property: CoreModel.Attribute(type: .String))
            
            /// Whether the action has been completed. 
            ///
            /// Raw value of ```ActionStatus```.
            public static let Status = (name: "status", property: CoreModel.Attribute(type: .String))
        }
        
        public struct Relationship {
            
            /// The lock associated with this action.
            public static let Lock: (name: String, property: CoreModel.Relationship) = {
                
                let property = CoreModel.Relationship(type: RelationshipType.ToOne,
                    optional: true,
                    destinationEntityName: Model.Lock.entityName,
                    inverseRelationshipName: Model.Lock.Relationship.Actions.name)
                
                return (name: "lock", property: property)
                }()
            
            /// The user associated with this action.
            public static let User: (name: String, property: CoreModel.Relationship) = {
                
                let property = CoreModel.Relationship(type: RelationshipType.ToOne,
                    optional: true,
                    destinationEntityName: Model.User.entityName,
                    inverseRelationshipName: Model.User.Relationship.Actions.name)
                
                return (name: "user", property: property)
                }()
            
            /// The permission associated with this action.
            public static let Permission: (name: String, property: CoreModel.Relationship) = {
                
                let property = CoreModel.Relationship(type: RelationshipType.ToOne,
                    optional: true,
                    destinationEntityName: Model.Permission.entityName,
                    inverseRelationshipName: Model.Permission.Relationship.Actions.name)
                
                return (name: "permission", property: property)
                }()
        }
    }
}

// MARK: - Permission

public extension Model {
    
    public struct Permission {
        
        public static let entityName = "Permission"
        
        public static let entity: Entity = {
            
            var entity = Entity()
            
            entity.attributes[Attribute.Archived.name]              = Attribute.Archived.property
            entity.attributes[Attribute.Created.name]               = Attribute.Created.property
            entity.attributes[Attribute.StartDate.name]             = Attribute.StartDate.property
            entity.attributes[Attribute.EndDate.name]               = Attribute.EndDate.property
            entity.attributes[Attribute.ScheduledStartTime.name]    = Attribute.ScheduledStartTime.property
            entity.attributes[Attribute.ScheduledEndTime.name]      = Attribute.ScheduledEndTime.property
            entity.attributes[Attribute.PermissionType.name]        = Attribute.PermissionType.property
            
            entity.relationships[Relationship.Lock.name]            = Relationship.Lock.property
            entity.relationships[Relationship.User.name]            = Relationship.User.property
            entity.relationships[Relationship.Actions.name]         = Relationship.Actions.property
            entity.relationships[Relationship.DerivedPermissions.name] = Relationship.DerivedPermissions.property
            entity.relationships[Relationship.ParentPermission.name] = Relationship.ParentPermission.property
            
            return entity
            }()
        
        public struct Attribute {
            
            /// Whether this entity is archived or not.
            ///
            /// Archived entities are basically deleted, but still stored for historical purposes.
            public static let Archived = (name: "archived", property: CoreModel.Attribute(type: .Number(.Boolean)))
            
            /// Date the permission was created.
            public static let Created = (name: "created", property: CoreModel.Attribute(type: .Date))
            
            /// The date this permission goes into effect.
            public static let StartDate = (name: "startDate", property: CoreModel.Attribute(type: .Date))
            
            
            /// The date this permission becomes invalid.
            public static let EndDate = (name: "endDate", property: CoreModel.Attribute(type: .Date, optional: true))
            
            /// The starting time of the time interval the lock can be unlocked.
            ///
            /// -Note: Not applicable for admin / anytime permissions.
            public static let ScheduledStartTime = (name: "scheduledStartTime", property: CoreModel.Attribute(type: .Number(.Integer), optional: true))
            
            /// The ending time of the time interval the lock can be unlocked. 
            ///
            /// -Note: Not applicable for admin / anytime permissions.
            public static let ScheduledEndTime = (name: "scheduledEndTime", property: CoreModel.Attribute(type: .Number(.Integer), optional: true))
            
            /// Type of permission. 
            ///
            /// Raw value for ```PermissionType```.
            public static let PermissionType = (name: "permissionType", property: CoreModel.Attribute(type: .String))
        }
        
        public struct Relationship {
            
            /// The lock this permission is granting access for.
            public static let Lock: (name: String, property: CoreModel.Relationship) = {
                
                let property = CoreModel.Relationship(type: RelationshipType.ToOne,
                    optional: false,
                    destinationEntityName: Model.Lock.entityName,
                    inverseRelationshipName: Model.Lock.Relationship.Permissions.name)
                
                return (name: "lock", property: property)
                }()
            
            /// The user this permssion is granting access to. 
            public static let User: (name: String, property: CoreModel.Relationship) = {
                
                let property = CoreModel.Relationship(type: RelationshipType.ToOne,
                    optional: false,
                    destinationEntityName: Model.User.entityName,
                    inverseRelationshipName: Model.User.Relationship.Permissions.name)
                
                return (name: "user", property: property)
                }()
            
            /// Permissions derived from this permission. 
            public static let DerivedPermissions: (name: String, property: CoreModel.Relationship) = {
                
                let property = CoreModel.Relationship(type: RelationshipType.ToMany,
                    optional: true,
                    destinationEntityName: Model.Permission.entityName,
                    inverseRelationshipName: Model.Permission.Relationship.ParentPermission.name)
                
                return (name: "derivedPermissions", property: property)
                }()
            
            /// Permission this permission was derived from. 
            public static let ParentPermission: (name: String, property: CoreModel.Relationship) = {
                
                let property = CoreModel.Relationship(type: RelationshipType.ToOne,
                    optional: true,
                    destinationEntityName: Model.Permission.entityName,
                    inverseRelationshipName: Model.Permission.Relationship.DerivedPermissions.name)
                
                return (name: "parentPermission", property: property)
                }()
            
            /// Actions involving this permission. 
            public static let Actions: (name: String, property: CoreModel.Relationship) = {
                
                let property = CoreModel.Relationship(type: RelationshipType.ToMany,
                    optional: true,
                    destinationEntityName: Action.entityName,
                    inverseRelationshipName: Action.Relationship.Permission.name)
                
                return (name: "actions", property: property)
                }()
        }
        
        public struct Function {
            
            /// Archives the entity.
            public static let Archive           = "archive"
        }
    }
}




