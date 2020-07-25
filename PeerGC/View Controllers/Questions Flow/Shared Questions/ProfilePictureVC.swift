//
//  ProfilePictureVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class ProfilePictureVC: GenericStructureViewController {
    override func viewDidLoad() {
        genericStructureViewControllerMetadataDelegate = self
        imagePickerDelegate = self
        super.viewDidLoad()
    }
}

extension ProfilePictureVC: GenericStructureViewControllerMetadataDelegate {
    func databaseIdentifier() -> String {
        return "profilePicturePhotoURL"
    }
    
    func title() -> String {
        return "Please upload a profile picture."
    }
    
    func subtitle() -> String? {
        return "Your profile picture is mandatory and will be displayed publicly."
    }
    
    func nextViewController() -> UIViewController {
        return ZipCodeVC()
    }
}

extension ProfilePictureVC: ImagePickerDelegate {
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
