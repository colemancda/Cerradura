//
//  HTTPAuthenticationContext.swift
//  CoreCerradura
//
//  Created by Alsey Coleman Miller on 6/22/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/** Provides the context for HTTP authorization. */
public struct HTTPAuthenticationContext: AuthenticationContext {
    
    // MARK: - Properties
    
    /** The HTTP verb of the request. */
    public let verb: String
    
    /** The path of the HTTP request. */
    public let path: String
    
    /** The string of the date of the request. */
    public let dateString: String
    
    // MARK: - Initialization
    
    public init?(verb: String, path: String, dateString: String) {
        
        self.verb = verb
        self.path = path
        self.dateString = dateString
        
        let date = HTTPDateFormatter.dateFromString(dateString)
        
        if date == nil {
            
            return nil
        }
        
        self.date = date!
    }
    
    public init(verb: String, path: String, date: NSDate) {
        
        self.verb = verb
        self.path = path
        self.date = date
        self.dateString = HTTPDateFormatter.stringFromDate(date)
    }
    
    // MARK: - AuthenticationContext
    
    public var concatenatedString: String {

        return verb + path + dateString
    }
    
    public let date: NSDate
}

// MARK: - Private Constants

private let HTTPDateFormatter: NSDateFormatter = {
    
    let dateFormatter = NSDateFormatter()
    
    dateFormatter.dateFormat = "EEE',' dd' 'MMM' 'yyyy HH':'mm':'ss zzz"
    
    return dateFormatter
    }()