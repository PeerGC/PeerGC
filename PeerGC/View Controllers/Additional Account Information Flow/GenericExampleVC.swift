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
//        buttonsDelegate = self
        textFieldDelegate = self
        super.viewDidLoad()
    }
}

extension GenericExampleVC: GenericStructureViewControllerMetadataDelegate {
    
    func databaseIdentifier() -> String {
        return "ExampleID"
    }
    
    func title() -> String {
        return "Hello! This is what a title might look like."
    }
    
    func subtitle() -> String? {
        return nil
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

extension GenericExampleVC: TextFieldDelegate {
    func continuePressed(textInput: String?) -> String? {
        if textInput == "12345" {
            print("success!")
            return nil
        }
            
        else {
            return "Incorrect. This is an error."
        }
    }
    
    func placeHolderText() -> String {
        return "Password"
    }
}
