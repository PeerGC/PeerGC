//
//  AccountTypeVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class AccountTypeVC: GenericStructureViewController {
    override func viewDidLoad() {
        genericStructureViewControllerMetadataDelegate = self
        buttonsDelegate = self
        super.viewDidLoad()
    }
}

extension AccountTypeVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "Are you a student or a mentor?"
    }
    
    func subtitle() -> String? {
        return "PeerGC uses this information to determine the type of your account."
    }
    
    func nextViewController() -> UIViewController? {
        return ProfilePictureVC()
    }
}

extension AccountTypeVC: ButtonsDelegate {
    func databaseIdentifier() -> String {
        return "accountType"
    }
}
