//
//  MajorVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class MajorVC: GenericStructureViewController {
    override func viewDidLoad() {
        metaDataDelegate = self
        buttonsDelegate = self
        super.viewDidLoad()
    }
}

extension MajorVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "What field of study are you currently pursuing?"
    }
    
    func subtitle() -> String? {
        return "This information will be displayed on your public profile and is used by our matching algorithm."
    }
    
    func nextViewController() -> UIViewController? {
        return HighSchoolGPAVC()
    }
}

extension MajorVC: ButtonsDelegate {
    func databaseIdentifier() -> DatabaseKey {
        return .What_Field_Of_Study_Are_You_Currently_Pursuing
    }
    
    func buttons() -> [DatabaseValue] {
        return [.humanities, .math_or_computer_science, .sciences, .business, .art_or_theatre]
    }
}
