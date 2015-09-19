//
//  Archivable.swift
//  CoreCerradura
//
//  Created by Alsey Coleman Miller on 4/20/15.
//  Copyright (c) 2015 ColemanCDA. All rights reserved.
//

/** Protocol that defines whether an entity can be archived or not. Archived entities are basically deleted, but still stored for historical purposes. */
public protocol Archivable: class {
    
    /* Whether this entity is archived or not. Archived entities are basically deleted, but still stored for historical purposes. */
    var archived: NSNumber { get set }
    
    /** Entity was archived. Perform any post-archiving operations. */
    func didArchive()
}

/** Name of the NetworkObjects API function for archiving objects on the server. */
public let ArchiveFunctionName = "archive"

/** Performs the archive operation on an Archivable. */
public func Archive(archivable: Archivable) {
    
    archivable.archived = true
    
    archivable.didArchive()
}