//
//  RaceSpecificationViewController.swift
//  FBex
//
//  Created by AJ Radik on 1/11/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class RaceViewController: UIViewController {
    
    @IBOutlet var specificationButtons: [DesignableButton]!
    
    @IBOutlet weak var continueButton: DesignableButton!
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var subLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AccountTypeViewController.data.accountType == "Student" {
            subLabel.text = "EDyou uses this information to match you with tutors who are the same race as you."
        }
        
        else if AccountTypeViewController.data.accountType == "Tutor" {
            subLabel.text = "EDyou uses this information to match you with students who are the same race as you."
        }
        
        AccountTypeViewController.data.race = "Asian American"
        
        //
        for button in specificationButtons {
            button.titleLabel!.font = button.titleLabel!.font.withSize( (1.7/71) * UIScreen.main.bounds.height)
        }
        
        continueButton.titleLabel!.font = continueButton.titleLabel!.font.withSize( (1.7/71) * UIScreen.main.bounds.height)
        
        mainLabel.font = mainLabel.font.withSize( (3.5/71) * UIScreen.main.bounds.height)
        
        subLabel.font = subLabel.font.withSize( (1.7/71) * UIScreen.main.bounds.height)
        
        for i in 0 ..< specificationButtons.count {
           
            if i == 0 {
                specificationButtons[i].alpha = 1.0
                specificationButtons[i].backgroundColor = UIColor.systemGreen
            }
            
            else {
                specificationButtons[i].alpha = 0.6
                specificationButtons[i].backgroundColor = UIColor.systemPink
            }
            
        }
        
    }
    
    func transitionToHome() {
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        let homeViewController = storyboard?.instantiateViewController(identifier: "HomeViewController") as? HomeViewController
        
        
        view.window?.rootViewController = homeViewController
        
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
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        if sender == continueButton {
            UIView.animate(withDuration: 0.2) {
                sender.alpha = 1.0
            }
            
            let uid = Auth.auth().currentUser!.uid
        
            Firestore.firestore().collection("users").document(uid).setData(["accountType": AccountTypeViewController.data.accountType!, "zipCode": AccountTypeViewController.data.zipCode!, "value": AccountTypeViewController.data.value!, "gender": AccountTypeViewController.data.gender!, "interest": AccountTypeViewController.data.interest!, "race": AccountTypeViewController.data.race!]) { (error) in
            
                if error != nil {
                    // Show error message
                    print("Error saving user data")
                }
            }
            
            let docRef = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid)

            docRef.updateData([
                "whitelist" : [],
                "blacklist" : []
            ])
            
            transitionToHome()
        }
        
        AccountTypeViewController.data.race = sender.titleLabel!.text
        
        
        for button in specificationButtons {
            
            if button == sender {
                button.backgroundColor = UIColor.systemGreen
                UIView.animate(withDuration: 0.2) {
                    sender.alpha = 1.0
                }
            }
            
            else {
                button.backgroundColor = UIColor.systemPink
                UIView.animate(withDuration: 0.2) {
                    button.alpha = 0.6
                }
            }
            
        }
        
    }
    
    var mostRecentAlpha = 1.0
    
    @IBAction func buttonTouchDown(_ sender: UIButton) {
        
        self.mostRecentAlpha = Double(sender.alpha)
        
        UIView.animate(withDuration: 0.2) {
            sender.alpha = 0.6
        }
        
    }
    
    @IBAction func buttonCancel(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2) {
            sender.alpha = CGFloat(self.mostRecentAlpha)
        }
    }
    
}

