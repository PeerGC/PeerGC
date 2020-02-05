//
//  ProfilePictureViewController.swift
//  FBex
//
//  Created by AJ Radik on 1/21/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProfilePictureViewController: UIViewController {
    
    @IBOutlet var specificationButtons: [DesignableButton]!
    
    @IBOutlet weak var continueButton: DesignableButton!
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var subLabel: UILabel!
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for button in specificationButtons {
            button.titleLabel!.font = button.titleLabel!.font.withSize( (1.7/71) * UIScreen.main.bounds.height)
        }
        
        continueButton.titleLabel!.font = continueButton.titleLabel!.font.withSize( (1.7/71) * UIScreen.main.bounds.height)
        
        mainLabel.font = mainLabel.font.withSize( (3.5/71) * UIScreen.main.bounds.height)
        
        subLabel.font = subLabel.font.withSize( (1.7/71) * UIScreen.main.bounds.height)
        
        let photoURL = Auth.auth().currentUser!.photoURL
        
        if photoURL != nil {
            downloadImage(url: photoURL!, imageView: profilePicImageView)
        }
        
        profilePicImageView.cornerRadius = 40
        
        imagePicker.delegate = self
    }
    
    func downloadImage(url: URL, imageView: UIImageView) {
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async { // Make sure you're on the main thread here
                imageView.image = UIImage(data: data)
            }
        }
        task.resume()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        if sender == continueButton {
            UIView.animate(withDuration: 0.2) {
                sender.alpha = 1.0
            }
            return
        }
        
        for button in specificationButtons {
            
            if button == sender {
                button.backgroundColor = UIColor.systemGreen
                UIView.animate(withDuration: 0.2) {
                    sender.alpha = 1.0
                }
            }
            
            else {
                button.backgroundColor = UIColor.systemPink
                UIView.animate(withDuration: 0.2) {
                    button.alpha = 0.6
                }
            }
            
        }
        
    }
    
    var imagePicker = UIImagePickerController()
    var storageRef = Storage.storage().reference()
    
    @IBAction func uploadButton(_ sender: Any) {
        
        let myActionSheet = UIAlertController(title:"Profile Picture",message:"Select",preferredStyle: UIAlertController.Style.actionSheet)
        
        let photoGallery = UIAlertAction(title: "Photos", style: UIAlertAction.Style.default) { (action) in
            
            if UIImagePickerController.isSourceTypeAvailable( UIImagePickerController.SourceType.savedPhotosAlbum)
            {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true
                    , completion: nil)
            }
        }
        
        let camera = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) { (action) in
            
            if UIImagePickerController.isSourceTypeAvailable( UIImagePickerController.SourceType.camera)
            {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.imagePicker.allowsEditing = true
                
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        myActionSheet.addAction(photoGallery)
//        myActionSheet.addAction(camera)
        
        myActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(myActionSheet, animated: true, completion: nil)
        
    }
    
    
    var mostRecentAlpha = 1.0
    
    @IBAction func buttonTouchDown(_ sender: UIButton) {
        
        self.mostRecentAlpha = Double(sender.alpha)
        
        UIView.animate(withDuration: 0.2) {
            sender.alpha = 0.6
        }
        
    }
    
    @IBAction func buttonCancel(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2) {
            sender.alpha = CGFloat(self.mostRecentAlpha)
        }
    }
    
}

extension ProfilePictureViewController: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print("made it one")
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        profilePicImageView.image = image
        
        print("made it two")
        
        if let imageData: Foundation.Data = self.profilePicImageView.image!.pngData()
        {
            
            let profilePicStorageRef = storageRef.child("users/\(Auth.auth().currentUser!.uid)/profilePicture")
            
            let uploadTask = profilePicStorageRef.putData(imageData, metadata: nil) { (metadata, error) in
              guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
              }
              // Metadata contains file metadata such as size, content-type.
              let size = metadata.size
              // You can also access to download URL after upload.
              profilePicStorageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                  print("download url error")
                  return
                }
                // add url to prof pic
                
                 let user = Auth.auth().currentUser
                       
                       let changeRequest = user!.createProfileChangeRequest()
                       changeRequest.photoURL = downloadURL
                          
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
                                   
                               }
                            print("made it three")
                           }
                
              }
            }
            
        }
    
        self.dismiss(animated: true, completion: nil)
    }
}

extension ProfilePictureViewController: UINavigationControllerDelegate {
    
}
