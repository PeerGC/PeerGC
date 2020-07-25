//
//  RaceVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class RaceVC: GenericStructureViewController {
    override func viewDidLoad() {
        genericStructureViewControllerMetadataDelegate = self
        buttonsDelegate = self
        super.viewDidLoad()
    }
}

extension RaceVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "What is your race?"
    }
    
    func subtitle() -> String? {
        return "This information will be displayed on your public profile and is used by our matching algorithm."
    }
    
    func nextViewController() -> UIViewController? {
        return FirstGenerationVC()
    }
    
    
}

extension RaceVC: ButtonsDelegate {
    func databaseIdentifier() -> String {
        return "race"
    }
    
    func buttons() -> [String] {
        return ["White", "Black / African American", "American Indian / Alaska Native", "Asian", "Native Hawaiian / Pacific Islander", "Other"]
    }
}
