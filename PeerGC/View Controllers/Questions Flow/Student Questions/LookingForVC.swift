//
//  LookingForVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class LookingForVC: GenericStructureViewController {
    
    override func viewDidLoad() {
        BUTTON_TEXT_SIZE = (1.3/71) * UIScreen.main.bounds.height
        genericStructureViewControllerMetadataDelegate = self
        buttonsDelegate = self
        super.viewDidLoad()
    }
}

extension LookingForVC: GenericStructureViewControllerMetadataDelegate {
    func databaseIdentifier() -> String {
        return "lookingFor"
    }
    
    func title() -> String {
        return "What are you looking for from a peer counselor?"
    }
    
    func subtitle() -> String? {
        return "This information will be displayed on your public profile and is used by our matching algorithm."
    }
    
    func nextViewController() -> UIViewController {
        return WhereInProcessVC()
    }
}

extension LookingForVC: ButtonsDelegate {
    func buttons() -> [String] {
        return ["To help keep me on track.", "To provide info on what colleges look for.", "To find a support system in college.", "To help with college entrance tests.", "To help with essays."]
    }
}
