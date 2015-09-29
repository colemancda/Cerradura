//
//  RegisterViewController.swift
//  Cerradura
//
//  Created by Alsey Coleman Miller on 9/27/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import Foundation
import UIKit
import SwiftFoundation
import CoreModel
import NetworkObjects
import CoreCerradura
import JGProgressHUD
import TextFieldEffects

class RegisterViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - IB Outlets
    
    @IBOutlet var textFields: [HoshiTextField]!
    
    @IBOutlet weak var usernameTextField: HoshiTextField!
    
    @IBOutlet weak var emailTextField: HoshiTextField!
    
    @IBOutlet weak var passwordTextField: HoshiTextField!
    
    @IBOutlet weak var confirmPasswordTextField: HoshiTextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    // MARK: - Private Properties
        
    private let progressHUD = JGProgressHUD(style: .Dark)
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.validateFields()
    }
    
    // MARK: - Actions
    
    @IBAction func cancel(sender: AnyObject) {
        
        progressHUD.dismissAnimated(false)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func register(sender: AnyObject) {
        
        // collect registration data
        
        var values = ValuesObject()
        
        let username = self.usernameTextField.text!
        let password = self.passwordTextField.text!
        let email = self.emailTextField.text!
        
        values[Model.User.Attribute.Username.name] = .Attribute(.String(username))
        values[Model.User.Attribute.Password.name] = .Attribute(.String(password))
        values[Model.User.Attribute.Email.name] = .Attribute(.String(email))
        
        self.view.endEditing(true)
        progressHUD.showInView(self.view, animated: true)
        self.tableView.scrollEnabled = false
        
        Store.create(Model.User.entityName, initialValues: values) { [weak self] (response) in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                
                guard let controller = self else { return }
                
                switch response {
                    
                case let .Error(error):
                    
                    controller.showErrorAlert("\(error)")
                    
                    controller.progressHUD.dismissAnimated(false)
                    
                    controller.tableView.scrollEnabled = true
                    
                case let .Value(newUser):
                    
                    controller.progressHUD.dismiss()
                    
                    // save user ID and credentials
                    
                    let userID = newUser.valueForKey(CoreDataResourceIDAttributeName) as! String
                    
                    let credentials = Authentication.Credential(username: username, password: password, userID: userID)
                    
                    Authentication.sharedAuthentication.setCredentials(credentials)
                    
                    // Create SQLite cache file for the new user
                    
                    try! LoadPersistentStore(userID)
                    
                    // show logged in view
                    
                    controller.dismissViewControllerAnimated(true, completion: {
                        
                        controller.presentingViewController!.dismissViewControllerAnimated(true, completion: {
                            
                            
                        })
                    })
                }
            })
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        let index = self.textFields.indexOf(textField as! HoshiTextField)!
        
        guard index != self.textFields.count - 1 else {
            
            textField.resignFirstResponder()
            
            return true
        }
        
        let nextTextField = self.textFields[index + 1]
        
        nextTextField.becomeFirstResponder()
        
        return false
    }
    
    @IBAction func textFieldValueDidChange(sender: UITextField) {
        
        self.validateFields()
    }
    
    // MARK: - Methods
    
    func validateFields() {
        
        var canRegister = true
        
        for textField in self.textFields {
            
            // validate
            
            let textFieldValid: Bool
            
            switch textField {
                
            case usernameTextField:
                
                textFieldValid = Model.User.Validate.username(self.usernameTextField.text!)
                
            case emailTextField:
                
                textFieldValid = Model.User.Validate.email(self.emailTextField.text!)
                
            case passwordTextField:
                
                textFieldValid = Model.User.Validate.password(self.passwordTextField.text!)
                
            case confirmPasswordTextField:
                
                textFieldValid = self.passwordTextField.text == self.confirmPasswordTextField.text
                    && Model.User.Validate.password(self.passwordTextField.text!)
                
            default: textFieldValid = false
            }
            
            if textFieldValid == false { canRegister = false }
            
            // determine color
            
            let newTextFieldColor: UIColor
            
            if textFieldValid || textField.text!.utf8.count == 0 {
                
                newTextFieldColor = StyleKit.registrationTextColor
            }
            else {
                
                newTextFieldColor = StyleKit.registrationRed
            }
            
            // set only if different
            
            if textField.placeholderColor != newTextFieldColor {
                
                textField.placeholderColor = newTextFieldColor
            }
        }
        
        self.registerButton.enabled = canRegister
    }
}