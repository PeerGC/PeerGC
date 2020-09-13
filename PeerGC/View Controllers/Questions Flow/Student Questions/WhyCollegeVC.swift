//
//  WhyCollegeVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class WhyCollegeVC: GenericStructureViewController {
    override func viewDidLoad() {
        metaDataDelegate = self
        buttonsDelegate = self
        super.viewDidLoad()
    }
}

extension WhyCollegeVC: GenericStructureViewControllerMetadataDelegate {
    
    func title() -> String {
        return "Why do you want to go to college?"
    }
    
    func subtitle() -> String? {
        return "This information will be displayed on your public profile and is used by our matching algorithm."
    }
    
    func nextViewController() -> UIViewController? {
        return FirstLanguageVC()
    }
}

extension WhyCollegeVC: ButtonsDelegate {
    func databaseIdentifier() -> DatabaseKey {
        return .Why_Do_You_Want_To_Go_To_College
    }
    
    func buttons() -> [DatabaseValue] {
        return [.getOutOfLivingSituation, .specificFieldOfStudy, .highPayingJob, .atheltics, .dontKnow]
    }
}
