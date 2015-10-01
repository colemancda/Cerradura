//
//  Version.swift
//  Cerradura
//
//  Created by Alsey Coleman Miller on 6/4/15.
//  Copyright (c) 2015 ColemanCDA. All rights reserved.
//

import Foundation

/** Version of the app. */
public let AppVersion = NSBundle.mainBundle().valueForKey("infoDictionary")!["CFBundleShortVersionString"] as! String

/** Build of the app. */
public let AppBuild = NSBundle.mainBundle().valueForKey("infoDictionary")!["CFBundleVersion"] as! String