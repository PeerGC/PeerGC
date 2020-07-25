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
//        textFieldDelegate = self
        imagePickerDelegate = self
        super.viewDidLoad()
    }
}

extension GenericExampleVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "Hello! This is what a title might look like."
    }
    
    func subtitle() -> String? {
        return nil
    }
    
    func nextViewController() -> UIViewController? {
        return nil
    }
    
}

extension GenericExampleVC: ButtonsDelegate {
    func databaseIdentifier() -> String {
        return "ExampleID"
    }
    
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
}

extension GenericExampleVC: ImagePickerDelegate {
    func setInitialImage(imageView: UIImageView, continueButton: UIButton) {
        downloadImage(url: URL(string: "https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80")!, imageView: imageView, continueButton: continueButton)
    }
    
    func imageWasSelected(imageView: UIImageView, continueButton: UIButton, image: UIImage) {
        continueButton.alpha = 1.0
        imageView.image = image
    }
    
    func downloadImage(url: URL, imageView: UIImageView, continueButton: UIButton) {
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async { // Make sure you're on the main thread here
                imageView.image = UIImage(data: data)
                continueButton.alpha = 1.0
            }
        }
        task.resume()
    }
}
