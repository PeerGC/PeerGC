//
//  FirstLanguageVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class FirstLanguageVC: GenericStructureViewController {
    override func viewDidLoad() {
        genericStructureViewControllerMetadataDelegate = self
        buttonsDelegate = self
        super.viewDidLoad()
    }
    
    override func selectionButtonTextHandler(text: String) {
        if text == "Other." {
            nextViewControllerHandler(viewController: OtherFirstLanguageVC())
        }
            
        else {
            super.selectionButtonTextHandler(text: text)
        }
    }
}

extension FirstLanguageVC: GenericStructureViewControllerMetadataDelegate {
    func databaseIdentifier() -> String {
        return "firstLanguage"
    }
    
    func title() -> String {
        return "What is your first language?"
    }
    
    func subtitle() -> String? {
        return "This information will be displayed on your public profile and is used by our matching algorithm."
    }
    
    func nextViewController() -> UIViewController {
        return FirstLanguageVC()
    }
}

extension FirstLanguageVC: ButtonsDelegate {
    func buttons() -> [String] {
        return ["English.", "Other."]
    }
}
