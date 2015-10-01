//
//  MainStoryboard.swift
//  Cerradura
//
//  Created by Alsey Coleman Miller on 6/10/15.
//  Copyright (c) 2015 ColemanCDA. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SwiftFoundation
import NetworkObjects

extension UIViewController {
    
    func showAdaptiveDetailController(detailController: UINavigationController) {
        
        // show navigation stack based on splitVC setup
        if self.splitViewController!.viewControllers.count == 2 {
            
            // set detailVC
            self.splitViewController!.showDetailViewController(detailController, sender: self)
            
            // no edit handler
        }
        else {
            
            // set detailVC
            self.showViewController(detailController, sender: self)
        }
    }
    
    func handleManagedObjectDeletionInMainStoryboard() {
        
        // Detect if contained in splitViewController
        let regularLayout: Bool = (self.splitViewController?.viewControllers.count == 2) ?? false
        
        // Regular layout
        if regularLayout {
            
            // show empty selection if root VC and visible detail VC
            if self.navigationController!.viewControllers.first! == self &&
                self.splitViewController!.viewControllers[1] == self.navigationController! {
                    
                    // set detailVC
                    self.splitViewController!.showDetailViewController(R.storyboard.main.emptySelectionNavigationStack!, sender: self)
            }
        }
            
        // Compact layout
        else {
            
            // pop to root VC if top if second VC
            if self.navigationController!.viewControllers[1] == self {
                
                self.navigationController!.popToRootViewControllerAnimated(true)
            }
        }
    }
    
    func handleErrorInMainStoryboard(error: ErrorType) {
        
        let errorText: String
        
        do { throw error }
            
        catch is NSURLError {
            
            errorText = (error as NSError).localizedDescription
        }
            
        catch let Client.Error.ErrorStatusCode(statusCode) {
            
            guard statusCode != HTTP.StatusCode.Unauthorized.rawValue else {
                
                errorText = NSLocalizedString("You have been logged out.",
                    comment: "401 Logout")
                
                self.showErrorAlert(errorText, okHandler: {
                    
                    self.logoutFromMainStoryboard()
                })
                
                return
            }
            
            errorText = "\(error)"
        }
            
        catch {
            
            errorText = "\(error)"
        }
        
        self.showErrorAlert(errorText)
    }
    
    func logoutFromMainStoryboard() {
        
        // reset credentials
        Authentication.sharedAuthentication.removeCredentials()
        Preference.UserID.value = nil
        
        // reset Core Data stack
        try! RemovePersistentStore()
        try! LoadPersistentStore()
        Store.managedObjectContext.reset()
        
        // dismiss splitVC
        self.splitViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
