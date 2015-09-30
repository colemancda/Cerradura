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

class LoginViewController: UITableViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Private Properties
    
    private let progressHUD = JGProgressHUD(style: .Dark)
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // MARK: - Actions
        
    @IBAction func cancel(sender: AnyObject) {
        
        progressHUD.dismissAnimated(false)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func login(sender: AnyObject) {
        
        let username = self.usernameTextField!.text!
        let password = self.passwordTextField!.text!
        
        var fetchRequest = FetchRequest(entityName: Model.User.entityName, sortDescriptors: [])
        
        fetchRequest.predicate = Predicate.Comparison(ComparisonPredicate(propertyName: Model.User.Attribute.Username.name, value: Value.Attribute(AttributeValue.String(username))))
        
        // show HUD
        self.view.endEditing(true)
        progressHUD.showInView(self.view, animated: true)
        self.tableView.scrollEnabled = false
        
        // search for user with username
        Store.search(fetchRequest) { [weak self] (response: ErrorValue<[User]>) in
            
            NSOperationQueue.mainQueue().addOperationWithBlock {
                
                guard let controller = self else { return }
                
                controller.tableView.scrollEnabled = true
                
                switch response {
                    
                case let .Error(error):
                    
                    controller.showErrorAlert("\(error)")
                    
                    // hide HUD
                    controller.progressHUD.dismissAnimated(false)
                    
                case let .Value(results):
                    
                    // hide HUD
                    controller.progressHUD.dismissAnimated(false)
                    
                    guard let authenticatedUser: User = results.first else {
                        
                        // hide HUD
                        controller.progressHUD.dismissAnimated(false)
                        
                        let errorText = NSLocalizedString("Could not fetch user profile",
                            comment: "Could not fetch user profile")
                        
                        controller.showErrorAlert(errorText)
                        
                        return
                    }
                    
                    // hide HUD
                    controller.progressHUD.dismiss()
                    
                    // save user ID and credentials
                    
                    let userID = authenticatedUser.valueForKey(CoreDataResourceIDAttributeName) as! String
                    
                    let credentials = Authentication.Credential(username: username, password: password, userID: userID)
                    
                    Authentication.sharedAuthentication.setCredentials(credentials)
                    
                    // show logged in view
                    
                    let presentingVC = controller.presentingViewController!
                    
                    controller.dismissViewControllerAnimated(true, completion: {
                        
                        let loggedInVC = R.storyboard.main.initialViewController!
                        
                        presentingVC.presentViewController(loggedInVC, animated: true, completion: nil)
                    })
                }
            }
        }
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
    }
}

