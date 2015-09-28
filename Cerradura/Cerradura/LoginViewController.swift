//
//  LoginViewController.swift
//  Cerradura
//
//  Created by Alsey Coleman Miller on 6/3/15.
//  Copyright (c) 2015 ColemanCDA. All rights reserved.
//

import Foundation
import UIKit
import SwiftFoundation
import CoreModel
import NetworkObjects
import CoreCerradura
import JGProgressHUD
import TextFieldEffects

class LoginViewController: UIViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // MARK: - Actions
    
    @IBAction func login(sender: AnyObject) {
        
        /*
        AuthenticationController.sharedController.login(self.usernameTextField.text!.lowercaseString, password: self.passwordTextField.text!, server: serverURL, completion: { (error: NSError?) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                if error != nil {
                    
                    // override unauthorized error message
                    let errorText: String = {
                       
                        if error!.code == NetworkObjects.ErrorCode.ServerStatusCodeUnauthorized.rawValue {
                            
                            return NSLocalizedString("Invalid username or password.", value: "Invalid username or password.", comment: "Invalid username or password.")
                        }
                        
                        return error!.localizedDescription
                    }()
                    
                    self.showErrorAlert(errorText, retryHandler: { () -> Void in
                        
                        self.login(self)
                    })
                    
                    return
                }
                
                // present split VC
                
                self.performSegueWithIdentifier(R.segue.loginSegue, sender: self)
            })
        })
        */
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
    }
    
    @IBAction func logoutSegue(segue: UIStoryboardSegue) {
        
        
    }
}

