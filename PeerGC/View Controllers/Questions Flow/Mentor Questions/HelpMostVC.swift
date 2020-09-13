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
        metaDataDelegate = self
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
        return .Where_Can_You_Help_A_Student_Most
    }
    
    func buttons() -> [DatabaseValue] {
        return [.general_guidance_or_keeping_on_track, .info_on_what_colleges_look_for, .finding_a_support_system_in_college, .college_entrance_tests, .application_essays]
    }
}
