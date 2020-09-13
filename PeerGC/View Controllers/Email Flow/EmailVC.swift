//
//  EmailVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/26/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class EmailVC: GenericStructureViewController {
    static var email: String?
    
    override func viewDidLoad() {
        metaDataDelegate = self
        textFieldDelegate = self
        super.viewDidLoad()
        textField?.autocapitalizationType = .none
        textField?.textContentType = .emailAddress
    }
    
    func error(text: String) {
        errorLabel?.isHidden = false
        errorLabel?.text = text
    }
    
    func noError(nextViewController: UIViewController) {
        EmailVC.email = textField!.text
        nextViewControllerHandler(viewController: nextViewController)
        errorLabel!.isHidden = true
    }
    
    override func textFieldContinueButtonHandler() {
        guard let text = textField?.text else {
            error(text: "Invalid.")
            return
        }
        
        if !self.validateEmail(candidate: text) {
            self.error(text: "This email is invalid.")
            return
        }
        
        if GenericStructureViewController.sendToDatabaseData[DatabaseKey.accountType.name] == DatabaseValue.mentor.name && text.trimmingCharacters(in: .whitespacesAndNewlines).suffix(4) != ".edu" {
            self.error(text: "Mentors must use a .edu email address.")
            return
        }
        
        Auth.auth().fetchSignInMethods(forEmail: text, completion: { (providers, error) in
            
            if let error = error {
                let errorCode = AuthErrorCode(rawValue: error._code)
                
                switch errorCode {
                    case .wrongPassword:
                        self.error(text: "Wrong Password.")
                    case .networkError:
                        self.error(text: "Network Error.")
                    default:
                        self.error(text: "Error Signing In.")
                }
                return
            } else if let providers = providers {
                
                if providers.count == 0 { //acc DOES exist
                    if providers[0] == "password" {
                        //continue to password screen
                        self.noError(nextViewController: EnterPasswordVC())
                    } else {
                        //other login provider
                        self.error(text: "This email is associated with the login provider " + providers[0] + ". Please return to the home screen and log in with this provider.")
                    }
                    return
                }
            }
            //account does not exist go to creation
            
            self.noError(nextViewController: CreatePasswordVC())
        })
    }
    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
}

extension EmailVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "What is your email?"
    }
    
    func subtitle() -> String? {
        var firstPart = "If you have an account, you will be asked to log in with your password. If not, you will be asked to create an account with a password."
        
        if GenericStructureViewController.sendToDatabaseData[DatabaseKey.accountType.name] == DatabaseValue.mentor.name {
            firstPart += " Please note that mentors must use a .edu email address."
        }
        
        return firstPart
    }
    
    func nextViewController() -> UIViewController? {
        return nil
    }
}

extension EmailVC: TextFieldDelegate {
    func continuePressed(textInput: String?) -> String? {
        return nil // does nothing
    }
}
