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
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var subLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AccountTypeViewController.data.race = "Asian American"
        
        //
        for button in specificationButtons {
            button.titleLabel!.font = button.titleLabel!.font.withSize( (1.5/71) * UIScreen.main.bounds.height)
        }
        
        mainLabel.font = mainLabel.font.withSize( (3.5/71) * UIScreen.main.bounds.height)
        
        subLabel.font = subLabel.font.withSize( (1.7/71) * UIScreen.main.bounds.height)
        
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
    
            
//        let uid = Auth.auth().currentUser!.uid
//        let url = Auth.auth().currentUser!.photoURL
//
//        var urlString = ""
//
//        if url != nil {
//            urlString = "\(Auth.auth().currentUser!.photoURL!)"
//        }
//
//        Firestore.firestore().collection("users").document(uid).setData(
//            ["accountType": AccountTypeViewController.data.accountType!,
//             "zipCode": AccountTypeViewController.data.zipCode!,
//             "value": AccountTypeViewController.data.value!,
//             "gender": AccountTypeViewController.data.gender!,
//             "interest": AccountTypeViewController.data.interest!,
//             "race": AccountTypeViewController.data.race!,
//             "firstName": Auth.auth().currentUser!.displayName!.split(separator: " ")[0],
//             "photoURL": urlString ]
//            ) { (error) in
//
//            self.performSegue(withIdentifier: "goToMatching", sender: self)
//
//            if error != nil {
//                // Show error message
//                print("Error saving user data")
//            }
//        }
        
        AccountTypeViewController.data.race = sender.titleLabel!.text
        
    }
    
}

