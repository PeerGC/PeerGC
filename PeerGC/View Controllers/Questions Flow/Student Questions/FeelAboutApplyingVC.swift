//
//  FeelAboutApplyingVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class FeelAboutApplyingVC: GenericStructureViewController {
    override func viewDidLoad() {
        BUTTON_TEXT_SIZE = (1.4/71) * UIScreen.main.bounds.height
        genericStructureViewControllerMetadataDelegate = self
        buttonsDelegate = self
        super.viewDidLoad()
    }
}

extension FeelAboutApplyingVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "How do you feel about applying?"
    }
    
    func subtitle() -> String? {
        return "This information will be displayed on your public profile and is used by our matching algorithm."
    }
    
    func nextViewController() -> UIViewController? {
        return KindOfCollegeVC()
    }
}

extension FeelAboutApplyingVC: ButtonsDelegate {
    func databaseIdentifier() -> String {
        return "feelAboutApplying"
    }
    
    func buttons() -> [String] {
        return ["No idea what I’m doing", "Some idea of where to start", "Started but stuck", "Pretty good idea of what I have to do", "Have taken all known steps"]
    }
}
