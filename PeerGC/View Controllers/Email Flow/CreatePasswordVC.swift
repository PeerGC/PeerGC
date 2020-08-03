//
//  CreatePasswordVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 8/3/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class CreatePasswordVC: GenericStructureViewController {
    
    override func viewDidLoad() {
        genericStructureViewControllerMetadataDelegate = self
        textFieldDelegate = self
        super.viewDidLoad()
        textField?.autocapitalizationType = .none
        textField?.textContentType = .newPassword
    }
    
    override func textFieldContinueButtonHandler() {
        guard let text = textField?.text else {
            errorLabel!.text = "Invalid."
            errorLabel!.isHidden = false
            return
        }
        
        Auth.auth().createUser(withEmail: EmailVC.email!, password: text) { (result, error) in
            
            if error != nil {
                let errorCode = AuthErrorCode(rawValue: error!._code)
                
                switch errorCode {
                    case .wrongPassword:
                        self.errorLabel!.text = "Wrong Password."
                    case .networkError:
                        self.errorLabel!.text = "Network Error."
                    default:
                        self.errorLabel!.text = "Error Creating user."
                }
                self.errorLabel?.isHidden = false
            }
                
            else {
                self.errorLabel!.isHidden = true
                self.nextViewControllerHandler(viewController: self.nextViewController())
            }
            
        }
    }
    
}

extension CreatePasswordVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "Enter a password."
    }
    
    func subtitle() -> String? {
        return "This will be the password to your account."
    }
    
    func nextViewController() -> UIViewController? {
        return NameVC()
    }
}

extension CreatePasswordVC: TextFieldDelegate {
    func continuePressed(textInput: String?) -> String? {
        return nil // does nothing
    }
}

