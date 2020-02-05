//
//  GenderSpecificationViewController.swift
//  FBex
//
//  Created by AJ Radik on 1/11/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class GenderViewController: UIViewController {
    
    @IBOutlet var specificationButtons: [DesignableButton]!
    
    @IBOutlet weak var continueButton: DesignableButton!
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var subLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AccountTypeViewController.data.accountType == "Student" {
            subLabel.text = "EDyou uses this information to match you with tutors who are the same gender as you."
        }
        
        else if AccountTypeViewController.data.accountType == "Tutor" {
            subLabel.text = "EDyou uses this information to match you with students who are the same gender as you."
        }
        
        AccountTypeViewController.data.gender = "Female"
        
        //
        for button in specificationButtons {
            button.titleLabel!.font = button.titleLabel!.font.withSize( (1.7/71) * UIScreen.main.bounds.height)
        }
        
        continueButton.titleLabel!.font = continueButton.titleLabel!.font.withSize( (1.7/71) * UIScreen.main.bounds.height)
        
        mainLabel.font = mainLabel.font.withSize( (3.5/71) * UIScreen.main.bounds.height)
        
        subLabel.font = subLabel.font.withSize( (1.7/71) * UIScreen.main.bounds.height)
        
        for i in 0 ..< specificationButtons.count {
           
            if i == 0 {
                specificationButtons[i].alpha = 1.0
                specificationButtons[i].backgroundColor = UIColor.systemGreen
            }
            
            else {
                specificationButtons[i].alpha = 0.6
                specificationButtons[i].backgroundColor = UIColor.systemPink
            }
            
        }
        
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        if sender == continueButton {
            UIView.animate(withDuration: 0.2) {
                sender.alpha = 1.0
            }
            return
        }
        
        AccountTypeViewController.data.gender = sender.titleLabel!.text
        
        
        for button in specificationButtons {
            
            if button == sender {
                button.backgroundColor = UIColor.systemGreen
                UIView.animate(withDuration: 0.2) {
                    sender.alpha = 1.0
                }
            }
            
            else {
                button.backgroundColor = UIColor.systemPink
                UIView.animate(withDuration: 0.2) {
                    button.alpha = 0.6
                }
            }
            
        }
        
    }
    
    var mostRecentAlpha = 1.0
    
    @IBAction func buttonTouchDown(_ sender: UIButton) {
        
        self.mostRecentAlpha = Double(sender.alpha)
        
        UIView.animate(withDuration: 0.2) {
            sender.alpha = 0.6
        }
        
    }
    
    @IBAction func buttonCancel(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2) {
            sender.alpha = CGFloat(self.mostRecentAlpha)
        }
    }
    
}

