//
//  HighSchoolScoresVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class HighSchoolScoresVC: GenericStructureViewController {
    override func viewDidLoad() {
        genericStructureViewControllerMetadataDelegate = self
        buttonsDelegate = self
        super.viewDidLoad()
    }
    
    override func selectionButtonTextHandler(text: String) {
        if text == "SAT" {
            nextViewControllerHandler(viewController: SATScoreVC())
        }
            
        else if text == "ACT" {
            nextViewControllerHandler(viewController: ACTScoreVC())
        }
            
        else {
            GenericStructureViewController.sendToDatabaseData["testScore"] = "N/A"
            super.selectionButtonTextHandler(text: text)
        }
    }
}

extension HighSchoolScoresVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "Which test did you use for your college application?"
    }
    
    func subtitle() -> String? {
        return "This information will be displayed on your public profile and is used by our matching algorithm."
    }
    
    func nextViewController() -> UIViewController? {
        return HelpMostVC()
    }
}

extension HighSchoolScoresVC: ButtonsDelegate {
    func databaseIdentifier() -> String {
        return "testTaken"
    }
    
    func buttons() -> [String] {
        return ["SAT", "ACT", "Other / None"]
    }
}
