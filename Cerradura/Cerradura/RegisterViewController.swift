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
    
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet weak var usernameTextField: HoshiTextField!
    
    @IBOutlet weak var emailTextField: HoshiTextField!
    
    @IBOutlet weak var passwordTextField: HoshiTextField!
    
    @IBOutlet weak var confirmPasswordTextField: HoshiTextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    // MARK: - Properties
    
    private(set) var dataValidated = false
    
    let progressHUD = JGProgressHUD(style: .Dark)
    
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
        
        NewRequest({ () -> (Resource, ValuesObject) in
            
            try Store.create(Model.User.entityName, initialValues: values)
            
            }, error: { [weak self] (error) -> () in
                
                guard let controller = self else { return }
                
                controller.showErrorAlert("\(error)")
                
                controller.progressHUD.dismissAnimated(false)
                
                controller.tableView.scrollEnabled = true
                
            }, success: { [weak self] (Resource) -> () in
                
                guard let controller = self else { return }
                
                controller.progressHUD.dismiss()
                
                
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
        
        
    }
    
    // MARK: - Methods
    
    func validateFields() {
        
        
    }
}