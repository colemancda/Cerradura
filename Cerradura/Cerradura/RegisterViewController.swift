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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.usernameTextField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    
    @IBAction func cancel(sender: AnyObject) {
        
        progressHUD.dismissAnimated(false)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func register(sender: AnyObject) {
        
        // collect registration data
        
        var values = ValuesObject()
        
        values[Model.User.Attribute.Username.name] = .Attribute(.String(self.usernameTextField.text!))
        values[Model.User.Attribute.Email.name] = .Attribute(.String(self.emailTextField.text!))
        values[Model.User.Attribute.Password.name] = .Attribute(.String(self.passwordTextField.text!))
        
        self.view.endEditing(true)
        progressHUD.showInView(self.view, animated: true)
        self.tableView.scrollEnabled = false
        
        // create user
        
        NewRequest({
            
            try Store.create(Model.User.entityName, initialValues: values)
            
            }, error: { [weak self] (error) -> () in
                
                guard let controller = self else { return }
                
                controller.showErrorAlert("\(error)")
                
                controller.progressHUD.dismissAnimated(false)
                
                controller.tableView.scrollEnabled = true
                
            }, success: { [weak self] (resource, values) -> () in
                
                guard let controller = self else { return }
                
                controller.progressHUD.dismiss()
                
                controller.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                    
                })
        })
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        let index = self.textFields.indexOf(textField)!
        
        guard index != self.textFields.count - 1 else {
            
            textField.resignFirstResponder()
            
            return true
        }
        
        textField.resignFirstResponder()
        
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