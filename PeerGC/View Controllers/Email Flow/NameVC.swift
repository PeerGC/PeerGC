//
//  NameVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 8/3/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class NameVC: GenericStructureViewController {
    static var email: String?
    
    override func viewDidLoad() {
        genericStructureViewControllerMetadataDelegate = self
        textFieldDelegate = self
        super.viewDidLoad()
    }
    
    override func textFieldContinueButtonHandler() {
        guard let text = textField?.text else {
            errorLabel!.text = "Invalid."
            errorLabel!.isHidden = false
            return
        }
        
        if text.count == 0 {
            errorLabel!.text = "Please enter a name."
            errorLabel!.isHidden = false
            return
        }
        
        let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
        changeRequest.displayName = text
           
        changeRequest.commitChanges { error in
            if let error = error {
                
                let errorCode = AuthErrorCode(rawValue: error._code)
                
                switch errorCode {
                    case .wrongPassword:
                        self.errorLabel!.text = "Wrong Password."
                    case .networkError:
                        self.errorLabel!.text = "Network Error."
                    default:
                        self.errorLabel!.text = "Error setting name."
                }
                
                self.errorLabel!.isHidden = false
                
            } else {
                self.errorLabel!.isHidden = true
                self.nextViewControllerHandler(viewController: self.nextViewController())
            }
        }
    }
    
}

extension NameVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "What is your first name?"
    }
    
    func subtitle() -> String? {
        return "This will be displayed to your peers as part of your public profile."
    }
    
    func nextViewController() -> UIViewController? {
        return VerifyEmailVC()
    }
}

extension NameVC: TextFieldDelegate {
    func continuePressed(textInput: String?) -> String? {
        return nil // does nothing
    }
}

