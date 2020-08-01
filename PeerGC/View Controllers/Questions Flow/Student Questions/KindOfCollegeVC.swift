//
//  KindOfCollegeVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class KindOfCollegeVC: GenericStructureViewController {
    override func viewDidLoad() {
        genericStructureViewControllerMetadataDelegate = self
        buttonsDelegate = self
        super.viewDidLoad()
    }
}

extension KindOfCollegeVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "What kind of college are you considering?"
    }
    
    func subtitle() -> String? {
        return "This information will be displayed on your public profile and is used by our matching algorithm."
    }
    
    func nextViewController() -> UIViewController? {
        return WhyCollegeVC()
    }
}

extension KindOfCollegeVC: ButtonsDelegate {
    func databaseIdentifier() -> String {
        return "kindOfCollege"
    }
}
