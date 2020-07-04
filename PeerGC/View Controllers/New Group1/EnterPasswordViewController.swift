//
//  LogInWithPasswordViewController.swift
//  FBex
//
//  Created by AJ Radik on 1/16/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class EnterPasswordViewController: UIViewController, UITextFieldDelegate {
    
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
        
        Auth.auth().signIn(withEmail: EmailViewController.emailString, password: password.text!) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            if error != nil {
                
                let errorCode = AuthErrorCode(rawValue: error!._code)
                
                switch errorCode {
                    case .wrongPassword:
                        strongSelf.errorLabel.text = "Wrong Password."
                    case .networkError:
                        strongSelf.errorLabel.text = "Network Error."
                    default:
                        strongSelf.errorLabel.text = "Error Signing In."
                }
                
                strongSelf.errorLabel.isHidden = false
            }
            
            else {
                strongSelf.errorLabel.isHidden = true
                
                //add detector
                
                let uid = Auth.auth().currentUser!.uid
                       let docRef = Firestore.firestore().collection("users").document(uid)

                       docRef.getDocument { (document, error) in
                           if let document = document, document.exists {
                               print("Document EXISTS")
                               strongSelf.transitionToHome()
                           } else {
                               print("Document does not exist")
                               strongSelf.performSegue(withIdentifier: "documentDoesNotExistGoToName", sender: self)
                           }
                       }
        
            }
        }
        
    }
    
    @IBAction func forgotPasswordButton(_ sender: UIButton) {
        Auth.auth().sendPasswordReset(withEmail: EmailViewController.emailString) { [weak self] error in
          
            guard let strongSelf = self else { return }
            
            if error != nil {
                
                let errorCode = AuthErrorCode(rawValue: error!._code)
                
                switch errorCode {
                    case .wrongPassword:
                        strongSelf.errorLabel.text = "Wrong Password."
                    case .networkError:
                        strongSelf.errorLabel.text = "Network Error."
                    default:
                        strongSelf.errorLabel.text = "Error Signing In."
                }
                
                strongSelf.errorLabel.isHidden = false
            }
            
            else {
                strongSelf.performSegue(withIdentifier: "resetPasswordSegue", sender: self)
            }
            
        }
    }
        
    func transitionToHome() {
        
        let window: UIWindow = (UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first)!
        
        HomeViewController.loadCardLoader(action: {self.view.window?.rootViewController = self.storyboard?.instantiateViewController(identifier: "HomeNavigationController") as? UINavigationController})
        
        // A mask of options indicating how you want to perform the animations.
        let options: UIView.AnimationOptions = .transitionFlipFromRight

        // The duration of the transition animation, measured in seconds.
        let duration: TimeInterval = 0.3

        // Creates a transition animation.
        // Though `animations` is optional, the documentation tells us that it must not be nil. ¯\_(ツ)_/¯
        UIView.transition(with: window, duration: duration, options: options, animations: {}, completion:
        { completed in
            // maybe do something on completion here
        })
        
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
