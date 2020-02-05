//
//  AccountInfoViewController.swift
//  FBex
//
//  Created by AJ Radik on 12/11/19.
//  Copyright © 2019 AJ Radik. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class AccountInfoViewController: UIViewController {

    @IBOutlet weak var identifier: UILabel!
    @IBOutlet weak var providerID: UILabel!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var uid: UILabel!
    @IBOutlet weak var accountType: UILabel!
    @IBOutlet weak var zipCode: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var interest: UILabel!
    @IBOutlet weak var race: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let currentUser = Auth.auth().currentUser!
        identifier.text! = "identifier: " + currentUser.email!
        providerID.text! = "providerID: " + currentUser.providerID
        uid.text! = "uid: " + currentUser.uid
        displayName.text! = "displayName: " + currentUser.displayName!
        
//        let docRef = Firestore.firestore().collection("users").document(currentUser.uid)
//
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                let dataDescription = document.data()
//                self.accountType.text! = "accountType: " + (dataDescription!["accountType"] as! String)
//                self.zipCode.text! = "zipCode: " + (dataDescription!["zipCode"] as! String)
//                self.gender.text! = "gender: " + (dataDescription!["gender"] as! String)
//                self.interest.text! = "interest: " + (dataDescription!["interest"] as! String)
//                self.race.text! = "race: " + (dataDescription!["race"] as! String)
//            } else {
//                print("Document does not exist")
//            }
//        }
        
        
        Firestore.firestore().collection("users").document(currentUser.uid)
        .addSnapshotListener { documentSnapshot, error in
          guard let document = documentSnapshot else {
            print("Error fetching document: \(error!)")
            return
          }
          guard let data = document.data() else {
            print("Document data was empty.")
            return
          }
          self.accountType.text! = "accountType: " + (data["accountType"] as! String)
          self.zipCode.text! = "zipCode: " + (data["zipCode"] as! String)
          self.gender.text! = "gender: " + (data["gender"] as! String)
          self.interest.text! = "interest: " + (data["interest"] as! String)
          self.race.text! = "race: " + (data["race"] as! String)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        viewDidLoad()
    }
    
    
}
