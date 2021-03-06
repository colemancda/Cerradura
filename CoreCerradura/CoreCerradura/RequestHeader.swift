//
//  RequestHeader.swift
//  CoreCerradura
//
//  Created by Alsey Coleman Miller on 5/27/15.
//  Copyright (c) 2015 ColemanCDA. All rights reserved.
//

/// HTTP Request headers.
public enum RequestHeader: String {
    
    case Date = "Date"
    case Authorization = "Authorization"
    case FirmwareBuild = "x-cerradura-firmware"
    case SoftwareVersion = "x-cerradura-version"
    case User = "x-cerradura-user"
}