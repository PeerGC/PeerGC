//
//  PostGradAspirationsVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class PostGradAspirationsVC: GenericStructureViewController {
    override func viewDidLoad() {
        BUTTON_TEXT_SIZE = (1.3/71) * UIScreen.main.bounds.height
        genericStructureViewControllerMetadataDelegate = self
        buttonsDelegate = self
        super.viewDidLoad()
    }
}

extension PostGradAspirationsVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "What are your post-grad aspirations?"
    }
    
    func subtitle() -> String? {
        return "This information will be displayed on your public profile and is used by our matching algorithm."
    }
    
    func nextViewController() -> UIViewController? {
        return WhichStudentTypeVC()
    }
}

extension PostGradAspirationsVC: ButtonsDelegate {
    func databaseIdentifier() -> String {
        return "postGradAspirations"
    }
    
    func buttons() -> [String] {
        return ["Continued study [masters, PhD, MD, etc].", "Athletics.", "Work in an industry related to your major.", "Earn money with your degree.", "Something else."]
    }
}
