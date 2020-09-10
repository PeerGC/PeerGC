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
        metaDataDelegate = self
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
    func databaseIdentifier() -> DatabaseKey {
        return .feelAboutApplying
    }
    
    func buttons() -> [DatabaseValue] {
        return [.noIdea, .someIdea, .startedButStuck, .prettyGoodIdea, .takenAllKnownSteps]
    }
}
