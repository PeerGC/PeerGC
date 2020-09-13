//
//  InterestVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class InterestVC: GenericStructureViewController {
    override func viewDidLoad() {
        metaDataDelegate = self
        buttonsDelegate = self
        super.viewDidLoad()
    }
}

extension InterestVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "Which of these interests you most?"
    }
    
    func subtitle() -> String? {
        return "This information will be displayed on your public profile and is used by our matching algorithm."
    }
    
    func nextViewController() -> UIViewController? {
        return LookingForVC()
    }
}

extension InterestVC: ButtonsDelegate {
    func databaseIdentifier() -> DatabaseKey {
        return .Which_Of_These_Interests_You_Most
    }
    
    func buttons() -> [DatabaseValue] {
        return [.humanities, .mathComputerScience, .sciences, .business, .artTheatre]
    }
}
