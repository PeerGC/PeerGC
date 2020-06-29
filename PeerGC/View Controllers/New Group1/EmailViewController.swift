//
//  SignUpWithEmailViewController.swift
//  FBex
//
//  Created by AJ Radik on 1/16/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class EmailViewController: UIViewController, UITextFieldDelegate {
    
    static var emailString = ""
    
    @IBOutlet weak var email: UITextField!
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
        
        email.delegate = self
        email.addDoneButtonOnKeyboard()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func continueButton(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2) {
            sender.alpha = 1.0
        }
        
        
        Auth.auth().fetchSignInMethods(forEmail: email.text!, completion: {
            (providers, error) in
            
            if let error = error {
                
                
                let errorCode = AuthErrorCode(rawValue: error._code)
                
                switch errorCode {
                    case .wrongPassword:
                        self.errorLabel.text = "Wrong Password."
                    case .networkError:
                        self.errorLabel.text = "Network Error."
                    default:
                        self.errorLabel.text = "Error Signing In."
                }
                
                self.errorLabel.isHidden = false
                
                
            } else if let providers = providers {
                
                if providers.count >= 0 { //acc DOES exist
                    if providers[0] == "password" {
                        //continue to password screen
                        EmailViewController.emailString = self.email.text!
                        self.errorLabel.isHidden = true
                        self.performSegue(withIdentifier: "emailWasGoodGoToPasswordScreen", sender: self)
                    }
                    
                    else {
                        //other login provider
                        self.errorLabel.text = "This email is associated with the login provider " + providers[0] + ". Please return to the home screen and log in with this provider."
                        self.errorLabel.isHidden = false
                    }
                }
                return
            }
            //account does not exist go to creation
            
            if self.validateEmail(candidate: self.email.text!) {
                // email is good move on
                EmailViewController.emailString = self.email.text!
                self.errorLabel.isHidden = true
                self.performSegue(withIdentifier: "emailWasGoodGoToCreation", sender: self)
            }
            
            else {
                //email is bad
                self.errorLabel.text = "This email is invalid."
                self.errorLabel.isHidden = false
            }
            
            
        })
        
        
    }
    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
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
