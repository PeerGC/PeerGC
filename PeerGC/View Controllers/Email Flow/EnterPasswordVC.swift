//
//  EnterPasswordVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 8/3/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class EnterPasswordVC: GenericStructureViewController {
    static var email: String?
    
    override func viewDidLoad() {
        genericStructureViewControllerMetadataDelegate = self
        textFieldDelegate = self
        super.viewDidLoad()
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
        
        Auth.auth().signIn(withEmail: EmailVC.email!, password: text) { [weak self] authResult, error in
            
            if error != nil {
                let errorCode = AuthErrorCode(rawValue: error!._code)
                
                switch errorCode {
                    case .wrongPassword:
                        self?.errorLabel!.text = "Wrong Password."
                    case .networkError:
                        self?.errorLabel!.text = "Network Error."
                    default:
                        self?.errorLabel!.text = "Error Signing In."
                }
                self?.errorLabel!.isHidden = false
            }
            
            else {
                self?.errorLabel!.isHidden = true
                Utilities.loadHomeScreen()
            }
            
            
        }
    }
}

extension EnterPasswordVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "What is your password?"
    }
    
    func subtitle() -> String? {
        return "You will be logged in."
    }
    
    func nextViewController() -> UIViewController? {
        return nil
    }
}

extension EnterPasswordVC: TextFieldDelegate {
    func continuePressed(textInput: String?) -> String? {
        return nil // does nothing
    }
}
