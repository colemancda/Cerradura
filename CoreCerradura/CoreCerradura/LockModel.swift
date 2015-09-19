//
//  LockModel.swift
//  CoreCerradura
//
//  Created by Alsey Coleman Miller on 6/21/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/** The different Lock models. */
public enum LockModel: String {
    
    /** Simulator model. Used in development. */
    case Simulator
    
    /** Lock model based on Intel Edison board. */
    case Edison
    
    /** Lock model based on C.H.I.P. board. */
    case Chip
    
    case Beaglebone
}