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
        buttonTextSize = (1.3/71) * UIScreen.main.bounds.height
        metaDataDelegate = self
        buttonsDelegate = self
        super.viewDidLoad()
    }
}

extension LookingForVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "What are you looking for from a peer counselor?"
    }
    
    func subtitle() -> String? {
        return "This information will be displayed on your public profile and is used by our matching algorithm."
    }
    
    func nextViewController() -> UIViewController? {
        return WhereInProcessVC()
    }
}

extension LookingForVC: ButtonsDelegate {
    func databaseIdentifier() -> DatabaseKey {
        return .lookingFor
    }
    
    func buttons() -> [DatabaseValue] {
        return [.keepOnTrack, .infoOnCollegeWants, .findingSupportSystem, .entranceTests, .essays]
    }
}
