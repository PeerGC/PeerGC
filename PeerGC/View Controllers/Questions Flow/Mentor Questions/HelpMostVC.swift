//
//  HelpMostVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class HelpMostVC: GenericStructureViewController {
    override func viewDidLoad() {
        genericStructureViewControllerMetadataDelegate = self
        buttonsDelegate = self
        super.viewDidLoad()
    }
}

extension HelpMostVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "Where can you help a student most?"
    }
    
    func subtitle() -> String? {
        return "This information will be displayed on your public profile and is used by our matching algorithm."
    }
    
    func nextViewController() -> UIViewController? {
        return WhyYourCollegeVC()
    }
}

extension HelpMostVC: ButtonsDelegate {
    func databaseIdentifier() -> DatabaseKey {
        return .helpMost
    }
    
    func buttons() -> [DatabaseValue] {
        return [.generalGuidance, .infoCollegeLookFor, .findingSupportSystem, .collegeEntranceTests, .applicationEssays]
    }
}
