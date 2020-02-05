//
//  ZipCodeSpecificationViewController.swift
//  FBex
//
//  Created by AJ Radik on 1/11/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class ZipCodeViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var zipCode: UITextField!
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
            subLabel.text = "EDyou uses this information to match you with tutors who lived in zip codes with similar economic statistics, and to display your city and state to your tutors."
            mainLabel.text = "What is your zip code?"
        }
        
        else if AccountTypeViewController.data.accountType == "Tutor" {
            subLabel.text = "Enter the zip code you had in high school. It's used to match you with students with similar economic status, and to display your city and state to your students."
            mainLabel.text = "What was your zip code?"
        }
        
        zipCode.delegate = self
        zipCode.addDoneButtonOnKeyboard()
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
            
            if zipCode.text!.count > 5 {
                errorLabel.isHidden = false
                return
            }
            
            var zipCodeEdited = ""
            var hasStarted = false
            
            for char in zipCode.text! {
                
                if char != "0" {
                    hasStarted = true
                    zipCodeEdited += String(char)
                }
                
                if char == "0" {
                    if hasStarted {
                        zipCodeEdited += String(char)
                    }
                }
            }
            
            if !Utilities.zipCodeDoesExist(zipcode: zipCodeEdited) {
                errorLabel.isHidden = false
                return
            }
            
            errorLabel.isHidden = true
            
            AccountTypeViewController.data.zipCode = zipCodeEdited
            AccountTypeViewController.data.value = Double(Utilities.getValueByZipCode(zipcode: zipCodeEdited)!)
            
            self.performSegue(withIdentifier: "zipCodeWasGood", sender: self)
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

