//
//  HighSchoolGPAVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class HighSchoolGPAVC: GenericStructureViewController {
    override func viewDidLoad() {
        metaDataDelegate = self
        buttonsDelegate = self
        super.viewDidLoad()
    }
}

extension HighSchoolGPAVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "What was your high school GPA?"
    }
    
    func subtitle() -> String? {
        return "This information will be displayed on your public profile and is used by our matching algorithm."
    }
    
    func nextViewController() -> UIViewController? {
        return HighSchoolScoresVC()
    }
}

extension HighSchoolGPAVC: ButtonsDelegate {
    func databaseIdentifier() -> DatabaseKey {
        return .What_Was_Your_High_School_GPA
    }
    
    func buttons() -> [DatabaseValue] {
        return [.two_or_under, .between_two_and_three, .between_three_and_four, .four_or_higher]
    }
}
