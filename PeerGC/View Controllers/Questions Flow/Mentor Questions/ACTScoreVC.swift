//
//  ACTScoreVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class ACTScoreVC: GenericStructureViewController {
    override func viewDidLoad() {
        genericStructureViewControllerMetadataDelegate = self
        textFieldDelegate = self
        super.viewDidLoad()
    }
}

extension ACTScoreVC: GenericStructureViewControllerMetadataDelegate {
    func databaseIdentifier() -> String {
        return "highSchoolTestScore"
    }
    
    func title() -> String {
        return "Please enter your ACT score."
    }
    
    func subtitle() -> String? {
        return "This information will be displayed on your public profile and is used by our matching algorithm."
    }
    
    func nextViewController() -> UIViewController {
        return HelpMostVC()
    }
}

extension ACTScoreVC: TextFieldDelegate {
    func continuePressed(textInput: String?) -> String? {
        return nil
    }
}
