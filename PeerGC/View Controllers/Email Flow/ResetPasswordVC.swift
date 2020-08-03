//
//  ResetPasswordVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 8/3/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ResetPasswordVC: GenericStructureViewController {
    
    override func viewDidLoad() {
        genericStructureViewControllerMetadataDelegate = self
        super.viewDidLoad()
    }

}

extension ResetPasswordVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "A password reset email has been sent."
    }
    
    func subtitle() -> String? {
        return "Check your email and the spam folder to reset your password. Follow the provided link."
    }
    
    func nextViewController() -> UIViewController? {
        return nil
    }
}
