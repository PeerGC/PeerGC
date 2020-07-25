//
//  InterestVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class InterestVC: GenericStructureViewController {
    override func viewDidLoad() {
        genericStructureViewControllerMetadataDelegate = self
        buttonsDelegate = self
        super.viewDidLoad()
    }
}

extension InterestVC: GenericStructureViewControllerMetadataDelegate {
    func databaseIdentifier() -> String {
        return "interest"
    }
    
    func title() -> String {
        return "What year of High School are you in?"
    }
    
    func subtitle() -> String? {
        return "This information will be displayed on your public profile and is used by our matching algorithm."
    }
    
    func nextViewController() -> UIViewController {
        return LookingForVC()
    }
}

extension InterestVC: ButtonsDelegate {
    func buttons() -> [String] {
        return ["Humanities", "Math / Computer Science", "Sciences", "Business", "Art / Theatre", "A Specific Trade"]
    }
}
