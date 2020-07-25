//
//  FirstGenerationVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class FirstGenerationVC: GenericStructureViewController {
    override func viewDidLoad() {
        genericStructureViewControllerMetadataDelegate = self
        buttonsDelegate = self
        super.viewDidLoad()
    }
}

extension FirstGenerationVC: GenericStructureViewControllerMetadataDelegate {
    func databaseIdentifier() -> String {
        return "firstGeneration"
    }
    
    func title() -> String {
        return "Did either of your parents attend higher education?"
    }
    
    func subtitle() -> String? {
        return "This information will be displayed on your public profile and is used by our matching algorithm."
    }
    
    func nextViewController() -> UIViewController {
        if GenericStructureViewController.sendToDatabaseData["accountType"] == "Student" {
            return HighSchoolYearVC()
        }
        
        else if GenericStructureViewController.sendToDatabaseData["accountType"] == "Mentor" {
            return CollegeYearVC()
        }
        
        else {
            return self
        }
    }
}

extension FirstGenerationVC: ButtonsDelegate {
    func buttons() -> [String] {
        return ["Yes", "No", "Partially, but no degree."]
    }
}
