//
//  WhichDegreeVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class WhichDegreeVC: GenericStructureViewController {
    override func viewDidLoad() {
        metaDataDelegate = self
        buttonsDelegate = self
        super.viewDidLoad()
    }
}

extension WhichDegreeVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "What kind of degree are you currently pursuing?"
    }
    
    func subtitle() -> String? {
        return "This information will be displayed on your public profile and is used by our matching algorithm."
    }
    
    func nextViewController() -> UIViewController? {
        return FirstLanguageVC()
    }
}

extension WhichDegreeVC: ButtonsDelegate {
    func databaseIdentifier() -> DatabaseKey {
        return .What_Kind_Of_Degree_Are_You_Currently_Pursuing
    }
    
    func buttons() -> [DatabaseValue] {
        return [.aa, .aaForTransfer, .bachelorArtScience, .tradeSchoolDegree, .other]
    }
}
