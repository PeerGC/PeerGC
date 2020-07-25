//
//  MatchingVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/25/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MatchingVC: GenericStructureViewController {
    override func viewDidLoad() {
        topBuffer = -60
        genericStructureViewControllerMetadataDelegate = self
        activityIndicatorDelegate = self
        super.viewDidLoad()
        uploadDataToDatabase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func uploadDataToDatabase() {
        let uid = Auth.auth().currentUser!.uid
        let photoURL = Auth.auth().currentUser!.photoURL
        var photoURLString = ""
        
        if photoURL != nil {
            photoURLString = "\(photoURL!)"
        }
        
        //TODO: Change this default photo url
        else {
            photoURLString = "https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80"
        }
        
        GenericStructureViewController.sendToDatabaseData["photoURL"] = photoURLString
        
        //Upload Data
        
        Firestore.firestore().collection("users").document(uid).setData(GenericStructureViewController.sendToDatabaseData) { (error) in
            
            if error != nil {
                // Show error message
                print("Error saving user data")
            }
            
            else {
                self.doneLoading()
            }
        }
        
    }
}

extension MatchingVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "Matching You Now!"
    }
    
    func subtitle() -> String? {
        return "Please wait a minute while our matching algorithm matches you with your peers."
    }
    
    func nextViewController() -> UIViewController? {
        return nil
    }
}

extension MatchingVC: ActivityIndicatorDelegate {
    
}
