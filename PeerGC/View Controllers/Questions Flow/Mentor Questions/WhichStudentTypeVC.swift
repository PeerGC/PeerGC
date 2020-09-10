//
//  WhichStudentTypeVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class WhichStudentTypeVC: GenericStructureViewController {
    override func viewDidLoad() {
        buttonTextSize = (1.2/71) * UIScreen.main.bounds.height
        metaDataDelegate = self
        buttonsDelegate = self
        super.viewDidLoad()
    }
}

extension WhichStudentTypeVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "What kind of student would you be most excited to mentor?"
    }
    
    func subtitle() -> String? {
        return "This information will be displayed on your public profile and is used by our matching algorithm."
    }
    
    func nextViewController() -> UIViewController? {
        return WhichDegreeVC()
    }
}

extension WhichStudentTypeVC: ButtonsDelegate {
    func databaseIdentifier() -> DatabaseKey {
        return .whichStudentType
    }
    
    func buttons() -> [DatabaseValue] {
        return [.financiallyUnderprivileged, .lgbtq, .womenInStem, .similarCultureReligion, .similarRacialBackground]
    }
}
