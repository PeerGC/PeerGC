//
//  FirstAndLastNameViewController.swift
//  FBex
//
//  Created by AJ Radik on 1/16/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class CreateNameViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var continueButton: DesignableButton!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueButton.titleLabel!.font = continueButton.titleLabel!.font.withSize( (1.7/71) * UIScreen.main.bounds.height)
        
        mainLabel.font = mainLabel.font.withSize( (3.5/71) * UIScreen.main.bounds.height)
        
        subLabel.font = subLabel.font.withSize( (1.7/71) * UIScreen.main.bounds.height)
        
        errorLabel.font = errorLabel.font.withSize( (1.7/71) * UIScreen.main.bounds.height)
        
        firstName.delegate = self
        firstName.addDoneButtonOnKeyboard()
        lastName.delegate = self
        lastName.addDoneButtonOnKeyboard()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func continueButton(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2) {
            sender.alpha = 1.0
        }
        
        if firstName.text!.count == 0 || lastName.text!.count == 0 {
            errorLabel.text = "Please fill out both fields."
            errorLabel.isHidden = false
            return
        }
        
        let user = Auth.auth().currentUser
        
        let changeRequest = user!.createProfileChangeRequest()
        changeRequest.displayName = "\(firstName.text!) \(lastName.text!)"
           
            changeRequest.commitChanges { error in
                if let error = error {
                    
                    let errorCode = AuthErrorCode(rawValue: error._code)
                    
                    switch errorCode {
                        case .wrongPassword:
                            self.errorLabel.text = "Wrong Password."
                        case .networkError:
                            self.errorLabel.text = "Network Error."
                        default:
                            self.errorLabel.text = "Error setting name."
                    }
                    
                    self.errorLabel.isHidden = false
                    
                } else {
                    self.errorLabel.isHidden = true
                    self.performSegue(withIdentifier: "firstAndLastNameGoodGoToFurther", sender: self)
                }
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
