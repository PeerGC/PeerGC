//
//  GenericExampleVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/22/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class GenericExampleVC: GenericStructureViewController {
    override func viewDidLoad() {
        genericStructureViewControllerMetadataDelegate = self
        buttonsDelegate = self
        super.viewDidLoad()
    }
}

extension GenericExampleVC: GenericStructureViewControllerMetadataDelegate {
    
    func databaseIdentifier() -> String {
        "ExampleID"
    }
    
    func title() -> String {
        "Hello! This is what a title might look like."
    }
    
    func subtitle() -> String? {
        "This is where we can explain stuff or whatever. We don't use your data."
    }
    
    func nextViewController() -> UIViewController {
        return UIViewController()
    }
    
}

extension GenericExampleVC: ButtonsDelegate {
    func buttons() -> [String] {
        return [
            "Yes, I have done this.",
            "No, I have not done this.",
            "I may have done this?",
            "Absolutely not."
        ]
    }
}
