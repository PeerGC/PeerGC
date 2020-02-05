//
//  PasswordCreationViewController.swift
//  FBex
//
//  Created by AJ Radik on 1/16/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class CreatePasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var password: UITextField!
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
        
        password.delegate = self
        password.addDoneButtonOnKeyboard()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func continueButton(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2) {
            sender.alpha = 1.0
        }
        
        if !validatePassword(password.text!) {
            errorLabel.text = "Please make sure your password is at least 8 characters, contains a special character and a number."
            errorLabel.isHidden = false
            return
        }
        
        Auth.auth().createUser(withEmail: EmailViewController.emailString, password: password.text!) { (result, err) in
            
            // Check for errors
            if err != nil {
                
                // There was an error creating the user
                
                Auth.auth().currentUser?.updatePassword(to: self.password.text!) { (error) in
                    if error != nil {
                        
                        
                        let errorCode = AuthErrorCode(rawValue: error!._code)
                        
                        switch errorCode {
                            case .wrongPassword:
                                self.errorLabel.text = "Wrong Password."
                            case .networkError:
                                self.errorLabel.text = "Network Error."
                            default:
                                self.errorLabel.text = "Error Creating user."
                        }
                        
                        self.errorLabel.isHidden = false
                    }
                    
                    else {
                        self.errorLabel.isHidden = true
                        self.performSegue(withIdentifier: "passwordWasGoodGoToNameSpecScreen", sender: self)
                        
                    }
                }
                
            }
            else {
                
                //go to name spec screen
                
                self.errorLabel.isHidden = true
                self.performSegue(withIdentifier: "passwordWasGoodGoToNameSpecScreen", sender: self)
                
            }
            
        }
        
    }
        
    
    func validatePassword(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
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
