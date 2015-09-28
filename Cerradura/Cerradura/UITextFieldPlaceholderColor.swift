//
//  UITextFieldPlaceholderColor.swift
//  Cerradura
//
//  Created by Alsey Coleman Miller on 9/28/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import Foundation
import UIKit

public extension UITextField {
    
    func setPlaceholderColor(color: UIColor) {
        
        let attributedString = self.attributedPlaceholder!.mutableCopy() as! NSMutableAttributedString
        
        attributedString.setAttributes([NSForegroundColorAttributeName: color], range: NSMakeRange(0,  attributedString.length))
        
        self.attributedPlaceholder = attributedString
    }
}
