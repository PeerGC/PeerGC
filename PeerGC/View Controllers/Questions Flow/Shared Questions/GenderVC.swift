//
//  GenderVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class GenderVC: GenericStructureViewController {
    override func viewDidLoad() {
        genericStructureViewControllerMetadataDelegate = self
        buttonsDelegate = self
        super.viewDidLoad()
    }
}

extension GenderVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "What is your gender?"
    }
    
    func subtitle() -> String? {
        return "This information will be displayed on your public profile and is used by our matching algorithm."
    }
    
    func nextViewController() -> UIViewController? {
        return LGBTQVC()
    }
    
    
}

extension GenderVC: ButtonsDelegate {
    func databaseIdentifier() -> String {
        return "gender"
    }
    
    func buttons() -> [String] {
        return ["Male", "Female", "Non-Binary", "Other"]
    }
}
