//
//  WhyYourCollegeVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class WhyYourCollegeVC: GenericStructureViewController {
    override func viewDidLoad() {
        genericStructureViewControllerMetadataDelegate = self
        buttonsDelegate = self
        super.viewDidLoad()
    }
}

extension WhyYourCollegeVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "Why did you choose the college you are in?"
    }
    
    func subtitle() -> String? {
        return "This information will be displayed on your public profile and is used by our matching algorithm."
    }
    
    func nextViewController() -> UIViewController? {
        return PostGradAspirationsVC()
    }
}

extension WhyYourCollegeVC: ButtonsDelegate {
    func databaseIdentifier() -> String {
        return "whyYourCollege"
    }
    
    func buttons() -> [String] {
        return ["Close to home", "Big name school", "Best scholarship", "Best fit with your religion or culture", "Something else"]
    }
}
