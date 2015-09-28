//
//  Request.swift
//  Cerradura
//
//  Created by Alsey Coleman Miller on 9/28/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import Foundation

/// **Cerradura** request queue
let RequestQueue: NSOperationQueue = {
    
    let queue = NSOperationQueue()
    
    queue.name = "Cerradura Request Queue"
    
    return queue
}()

/// Wraps the requests to perform on their respective queues.
func NewRequest<T>(requestBlock: (() throws -> T), error errorBlock: (ErrorType -> ()), success successBlock: (T -> ())) {
    
    RequestQueue.addOperationWithBlock { () -> Void in
        
        let value: T
        
        do { value = try requestBlock() }
        
        catch {
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                errorBlock(error)
            })
            
            return
        }
        
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            
            successBlock(value)
        })
    }
}