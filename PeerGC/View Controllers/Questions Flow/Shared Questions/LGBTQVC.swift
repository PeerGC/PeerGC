//
//  LGBTQVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class LGBTQVC: GenericStructureViewController {
    override func viewDidLoad() {
        metaDataDelegate = self
        buttonsDelegate = self
        super.viewDidLoad()
    }
}

extension LGBTQVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "Are you LGBTQ?"
    }
    
    func subtitle() -> String? {
        return "This information will be displayed on your public profile and is used by our matching algorithm."
    }
    
    func nextViewController() -> UIViewController? {
        return RaceVC()
    }
}

extension LGBTQVC: ButtonsDelegate {
    func databaseIdentifier() -> DatabaseKey {
        return .LGBTQ
    }
    
    func buttons() -> [DatabaseValue] {
        return [.yes, .no]
    }
}
