//
//  ResetPasswordViewController.swift
//  FBex
//
//  Created by AJ Radik on 1/22/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mainLabel.font = mainLabel.font.withSize( (3.5/71) * UIScreen.main.bounds.height)
        
        subLabel.font = subLabel.font.withSize( (1.7/71) * UIScreen.main.bounds.height)

    }
    
}
