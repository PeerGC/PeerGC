//
//  VerifyEmailVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 8/3/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class VerifyEmailVC: GenericStructureViewController {
    
    var stateChangeHandle : AuthStateDidChangeListenerHandle?
    var timer: Timer?
    
    override func viewDidLoad() {
        genericStructureViewControllerMetadataDelegate = self
        activityIndicatorDelegate = self
        super.viewDidLoad()
        activityIndicatorContinueButton?.backgroundColor = .systemPink
        activityIndicatorContinueButton?.setTitle("Continue", for: .normal)
        verifyEmail()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkVerified), userInfo: nil, repeats: true)
    }
    
    func verifyEmail() {
        
        if Auth.auth().currentUser!.isEmailVerified {
            doneLoading()
            return
        }
        
        Auth.auth().currentUser?.sendEmailVerification { (error) in
        
        }
    }
    
    @objc func checkVerified() {
        Auth.auth().currentUser?.reload(completion: nil)
        if Auth.auth().currentUser!.isEmailVerified {
            timer?.invalidate()
            doneLoading()
        }
    }
    
    override func activityIndicatorContinueButtonHandler() {
        if activityIndicatorContinueButton?.alpha == 1.0 {
            nextViewControllerHandler(viewController: nextViewController())
        }
    }
    
}

extension VerifyEmailVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "Please verify your email."
    }
    
    func subtitle() -> String? {
        return "We have sent you a verification email to ensure your email is legitimate. Please follow the link and then return to the app."
    }
    
    func nextViewController() -> UIViewController? {
        return ProfilePictureVC()
    }
}

extension VerifyEmailVC: ActivityIndicatorDelegate {
    
}
