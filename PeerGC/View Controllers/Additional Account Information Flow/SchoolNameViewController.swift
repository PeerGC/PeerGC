//
//  SchoolNameViewController.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/13/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//
import Foundation
import UIKit

class SchoolNameViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var schoolName: UITextField!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var continueButton: DesignableButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        continueButton.titleLabel!.font = continueButton.titleLabel!.font.withSize( (1.7/71) * UIScreen.main.bounds.height)
        
        mainLabel.font = mainLabel.font.withSize( (3.5/71) * UIScreen.main.bounds.height)
        
        subLabel.font = subLabel.font.withSize( (1.7/71) * UIScreen.main.bounds.height)
        
        errorLabel.font = errorLabel.font.withSize( (1.7/71) * UIScreen.main.bounds.height)
        
        if AccountTypeViewController.data.accountType == "Student" {
            subLabel.text = "PeerGC uses your dream school to match you with peers similar to yourself."
            mainLabel.text = "What is your dream school?"
        }
        
        else if AccountTypeViewController.data.accountType == "Mentor" {
            subLabel.text = "PeerGC uses your school to match you with peers that share an interest in your school."
            mainLabel.text = "What school do you go to?"
        }
        
        schoolName.delegate = self
        schoolName.addDoneButtonOnKeyboard()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
      textField.resignFirstResponder()
      return true
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        if sender == continueButton {
            
            UIView.animate(withDuration: 0.2) {
                sender.alpha = 1.0
            }
            
            if schoolName.text!.count <= 0 {
                errorLabel.isHidden = false
                return
            }
            
            errorLabel.isHidden = true
            
            AccountTypeViewController.data.zipCode = "N/A"
            
            self.performSegue(withIdentifier: "schoolNameWasGood", sender: self)
        }
        
    }
    
    @IBAction func buttonTouchDown(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2) {
            sender.alpha = 0.6
        }
        
    }
    
    @IBAction func buttonCancel(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            sender.alpha = 1.0
        }
    }
    
}

