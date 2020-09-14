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
    
    lazy var functions = Functions.functions()
    
    override func viewDidLoad() {
        topBuffer = -60
        metaDataDelegate = self
        activityIndicatorDelegate = self
        super.viewDidLoad()
        preUploadDataToDatabase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func preUploadDataToDatabase() {
        let uid = Auth.auth().currentUser!.uid
        let photoURL = Auth.auth().currentUser!.photoURL
        var photoURLString = ""
        
        if photoURL != nil {
            photoURLString = "\(photoURL!)"
        } else {
            photoURLString = "https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80"
        }
        
        GenericStructureViewController.sendToDatabaseData[DatabaseKey.Photo_URL.name] = photoURLString
        GenericStructureViewController.sendToDatabaseData[DatabaseKey.First_Name.name] =
            Auth.auth().currentUser!.displayName!.components(separatedBy: " ")[0]
        
        //Upload Data
        
        let docRef = Firestore.firestore().collection(DatabaseKey.Users.name).document(uid)
        
        docRef.getDocument { (document, _) in
            if let document = document, document.exists {
                
            } else {
                self.uploadDataToDatabase()
            }
        }
        
        matchStudentToMentors()
        
    }
    
    func uploadDataToDatabase() {
        Firestore.firestore().collection(DatabaseKey.Users.name).document(Auth.auth().currentUser!.uid)
            .setData(GenericStructureViewController.sendToDatabaseData) { (error) in
            
            if error != nil {
                // Show error message
                print("Error saving user data")
            }
        }
    }
    
    func matchStudentToMentors() {
        if GenericStructureViewController.sendToDatabaseData[DatabaseKey.Account_Type.name] == DatabaseValue.student.name {
            functions.httpsCallable("matchStudentToMentors").call(["uid": Auth.auth().currentUser!.uid]) { (_, _) in
                self.doneLoading()
            }
        } else {
            self.doneLoading()
        }
    }
    
    override func activityIndicatorContinueButtonHandler() {
        if activityIndicatorContinueButton?.alpha == 1.0 {
            Utilities.loadHomeScreen()
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
