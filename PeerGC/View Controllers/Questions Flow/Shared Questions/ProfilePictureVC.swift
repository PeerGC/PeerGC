//
//  ProfilePictureVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProfilePictureVC: GenericStructureViewController {
    override func viewDidLoad() {
        metaDataDelegate = self
        imagePickerDelegate = self
        super.viewDidLoad()
    }
}

extension ProfilePictureVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "Please upload a profile picture."
    }
    
    func subtitle() -> String? {
        return "Your profile picture is mandatory and will be displayed publicly."
    }
    
    func nextViewController() -> UIViewController? {
        return ZipCodeVC()
    }
}

extension ProfilePictureVC: ImagePickerDelegate {
    func setInitialImage(imageView: UIImageView, continueButton: UIButton) {
        let photoURL = Auth.auth().currentUser!.photoURL
        
        if photoURL != nil {
            downloadImage(url: photoURL!, imageView: imageView, continueButton: continueButton)
        }
    }
    
    func imageWasSelected(imageView: UIImageView, continueButton: UIButton, image: UIImage) {
        
        guard let imageData = image.pngData() else { return }
        
        let profilePicStorageRef = Storage.storage().reference().child("\(DatabaseKey.Users.name)/\(Auth.auth().currentUser!.uid)/\(DatabaseKey.Profile_Picture.name)")
        
        profilePicStorageRef.putData(imageData, metadata: nil) { (_, error) in
            
            profilePicStorageRef.downloadURL { (url, error) in
                guard let url = url else { return }
                let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
                changeRequest.photoURL = url
                changeRequest.commitChanges { error in
                    if let error = error {
                        let errorCode = AuthErrorCode(rawValue: error._code)
                        switch errorCode {
                            case .wrongPassword:
                                print("Wrong Password.")
                            case .networkError:
                                print("Network Error.")
                            default:
                                print("Error setting name.")
                        }
                    } else {
                        continueButton.alpha = 1.0
                        imageView.image = image
                    }
                }
            }
        }
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
