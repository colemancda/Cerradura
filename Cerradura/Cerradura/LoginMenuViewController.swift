//
//  LoginMenuViewController.swift
//  Cerradura
//
//  Created by Alsey Coleman Miller on 9/29/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import Foundation
import UIKit

class LoginMenuViewController: UIViewController {
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // attempt to load stored credentials
        if Authentication.sharedAuthentication.loadCredentials() {
            
            // show logged in UI
            let loggedInVC = R.storyboard.main.initialViewController!
            
            self.presentViewController(loggedInVC, animated: false, completion: nil)
        }
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
    }
    
    @IBAction func logoutUnwindSegue(sender: UIStoryboardSegue) {
        
        
    }
}