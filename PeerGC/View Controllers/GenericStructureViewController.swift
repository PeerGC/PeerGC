//
//  GenericStructureViewController.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/22/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit
import Firebase

//MARK: Header
class GenericStructureViewController: UIViewController {
    
    static var sendToDatabaseData: [String: String] = [:]
    
    var genericStructureViewControllerMetadataDelegate: GenericStructureViewControllerMetadataDelegate?
    var buttonsDelegate: ButtonsDelegate?
    var textFieldDelegate: TextFieldDelegate?
    var imagePickerDelegate: ImagePickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if genericStructureViewControllerMetadataDelegate == nil {
            print("ERROR: You must set the GenericStructureViewControllerMetadataDelegate.")
            return
        }
        
        let optionalDelegates: [Any?] = [buttonsDelegate, textFieldDelegate, imagePickerDelegate]
        
        var numberOfNonNilOptionalDelegates = 0
        
        for delegate in optionalDelegates {
            if delegate != nil {
                numberOfNonNilOptionalDelegates += 1
            }
        }
        
        if numberOfNonNilOptionalDelegates > 1 {
            print("ERROR: You cannot set more than one optional delegate.")
            return
        }
        
        layout()
    }
    
    //MARK: Layout
    var topBuffer: CGFloat = -10
    func layout() {
        
        view.backgroundColor = .secondarySystemGroupedBackground
            
        let headerStack = initializeCustomStack(spacing: 10, distribution: .fill)
        headerStack.addArrangedSubview(initializeCustomLabel(title: genericStructureViewControllerMetadataDelegate!.title(), size: Double(TITLE_TEXT_SIZE), color: .label))
        
        if genericStructureViewControllerMetadataDelegate!.subtitle() != nil {
            headerStack.addArrangedSubview(initializeCustomLabel(title: genericStructureViewControllerMetadataDelegate!.subtitle()!, size: Double(SUBTITLE_TEXT_SIZE), color: .gray))
        }
        
        let headerStackConstraints: [NSLayoutConstraint] = [
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: headerStack.trailingAnchor, constant: 20),
            view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: headerStack.leadingAnchor, constant: -20),
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: headerStack.topAnchor, constant: topBuffer)
        ]
        
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerStack)
        NSLayoutConstraint.activate(headerStackConstraints)
            
        
        if buttonsDelegate != nil {
            
            let buttonStack = initializeCustomStack(spacing: 10, distribution: .fillEqually)
            
            for buttonText in buttonsDelegate!.buttons() {
                buttonStack.addArrangedSubview(initializeCustomButton(title: buttonText, color: .systemPink, action: #selector(selectionButtonHandler(sender:))))
            }
            
            let buttonStackConstraints = [NSLayoutConstraint(item: buttonStack, attribute: .top, relatedBy: .equal, toItem: headerStack, attribute: .bottom, multiplier: 1, constant: 30), view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: buttonStack.trailingAnchor, constant: 20), view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: buttonStack.leadingAnchor, constant: -20)]
            
            buttonStack.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(buttonStack)
            NSLayoutConstraint.activate(buttonStackConstraints)
        }
        
        if textFieldDelegate != nil {
            
            textField = initializeCustomTextField(placeHolderText: textFieldDelegate!.placeHolderText())
            
            let textFieldConstraints = [NSLayoutConstraint(item: textField!, attribute: .top, relatedBy: .equal, toItem: headerStack, attribute: .bottom, multiplier: 1, constant: 30), view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: textField!.trailingAnchor, constant: 30), view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: textField!.leadingAnchor, constant: -30)]
            
            textField!.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(textField!)
            NSLayoutConstraint.activate(textFieldConstraints)
            
            errorLabel = initializeCustomLabel(title: "Error.", size: Double(SUBTITLE_TEXT_SIZE), color: .systemPink)
            errorLabel!.isHidden = true
            
            let errorLabelConstraints = [NSLayoutConstraint(item: errorLabel!, attribute: .top, relatedBy: .equal, toItem: textField, attribute: .bottom, multiplier: 1, constant: 30), view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: errorLabel!.trailingAnchor, constant: 20), view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: errorLabel!.leadingAnchor, constant: -20)]
            
            errorLabel!.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(errorLabel!)
            NSLayoutConstraint.activate(errorLabelConstraints)
            
            let textFieldContinueButton = initializeCustomButton(title: "Continue", color: .systemPink, action: #selector(textFieldContinueButtonHandler))
            
            let continueButtonConstraints: [NSLayoutConstraint] = [
                view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: textFieldContinueButton.trailingAnchor, constant: 30),
                view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: textFieldContinueButton.leadingAnchor, constant: -30),
                view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: textFieldContinueButton.bottomAnchor, constant: 16)
            ]
            
            textFieldContinueButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(textFieldContinueButton)
            NSLayoutConstraint.activate(continueButtonConstraints)
            
        }
        
        if imagePickerDelegate != nil {
            
            let selectButton = initializeCustomButton(title: "Select", color: .systemGreen, action: #selector(imagePickerSelectButtonHandler))
            
            let selectButtonConstraints = [NSLayoutConstraint(item: selectButton, attribute: .top, relatedBy: .equal, toItem: headerStack, attribute: .bottom, multiplier: 1, constant: 30), view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: selectButton.trailingAnchor, constant: 30), view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: selectButton.leadingAnchor, constant: -30)]
            
            selectButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(selectButton)
            NSLayoutConstraint.activate(selectButtonConstraints)
            
            let imageView = initializeCustomImageView()
            
            let imageViewConstraints = [NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: selectButton, attribute: .bottom, multiplier: 1, constant: 30), view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: selectButton.trailingAnchor, constant: 120), view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: selectButton.leadingAnchor, constant: -120), NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: selectButton, attribute: .height, multiplier: 1, constant: 0)]
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageView)
            NSLayoutConstraint.activate(imageViewConstraints)
            
            imagePickerContinueButton = initializeCustomButton(title: "Continue", color: .systemPink, action: #selector(imagePickerContinueButtonHandler(sender:)))
            imagePickerContinueButton!.alpha = 0.6
            
            let continueButtonConstraints: [NSLayoutConstraint] = [
                view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: imagePickerContinueButton!.trailingAnchor, constant: 30),
                view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: imagePickerContinueButton!.leadingAnchor, constant: -30),
                view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: imagePickerContinueButton!.bottomAnchor, constant: 16)
            ]
            
            imagePickerContinueButton!.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imagePickerContinueButton!)
            NSLayoutConstraint.activate(continueButtonConstraints)
            
        }
        
    }
    
    //MARK: Custom UI Initializers
    let FONT_NAME = "LexendDeca-Regular"
    let BUTTON_TEXT_SIZE = (1.5/71) * UIScreen.main.bounds.height
    let TITLE_TEXT_SIZE = (3.5/71) * UIScreen.main.bounds.height
    let SUBTITLE_TEXT_SIZE = (1.7/71) * UIScreen.main.bounds.height
    
    func initializeCustomButton(title: String, color: UIColor, action: Selector) -> DesignableButton {
        let toReturn = DesignableButton()
        toReturn.setTitle(title, for: .normal)
        toReturn.setTitleColor(.white, for: .normal)
        toReturn.titleLabel!.font = UIFont(name: FONT_NAME, size: BUTTON_TEXT_SIZE)
        toReturn.setTitleColor(UIColor.white, for: .normal)
        toReturn.backgroundColor = color
        toReturn.cornerRadius = CGFloat(16)
        toReturn.addTarget(self, action: action, for: .touchUpInside)
        let buttonConstraints = [toReturn.heightAnchor.constraint(equalToConstant: 50)]
        NSLayoutConstraint.activate(buttonConstraints)
        return toReturn
    }
    
    func initializeCustomLabel(title: String, size: Double, color: UIColor) -> UILabel {
        let toReturn = UILabel()
        toReturn.textColor = color
        toReturn.numberOfLines = 0
        toReturn.textAlignment = .center
        toReturn.text = title
        toReturn.font = UIFont.init(name: FONT_NAME, size: CGFloat(size))
        return toReturn
    }
    
    func initializeCustomStack(spacing: Int, distribution: UIStackView.Distribution) -> UIStackView {
        let toReturn = UIStackView()
        toReturn.axis = .vertical
        toReturn.alignment = .fill
        toReturn.distribution = distribution
        toReturn.spacing = CGFloat(spacing)
        toReturn.isUserInteractionEnabled = true
        return toReturn
    }
    
    func initializeCustomTextField(placeHolderText: String) -> UITextField {
        let toReturn = UITextField()
        toReturn.delegate = self
        toReturn.borderStyle = .roundedRect
        toReturn.backgroundColor = .secondarySystemBackground
        toReturn.font = UIFont.init(name: FONT_NAME, size: toReturn.font!.pointSize)
        toReturn.placeholder = placeHolderText
        toReturn.textAlignment = .center
        toReturn.isUserInteractionEnabled = true
        let textFieldConstraints = [toReturn.heightAnchor.constraint(equalToConstant: 50)]
        NSLayoutConstraint.activate(textFieldConstraints)
        return toReturn
    }
    
    func initializeCustomImageView() -> UIImageView {
        let toReturn = UIImageView()
        toReturn.cornerRadius = 20
        toReturn.contentMode = .scaleAspectFill
        return toReturn
    }
    
    //MARK: Handlers
    //Buttons Delegate
    @objc func selectionButtonHandler(sender: UIButton) {
        selectionButtonTextHandler(text: sender.titleLabel!.text!)
    }
    
    func selectionButtonTextHandler(text: String) { //override this for custom button exceptions
        GenericStructureViewController.sendToDatabaseData[genericStructureViewControllerMetadataDelegate!.databaseIdentifier()] = text
        
        nextViewControllerHandler()
    }
    
    //Text Field Delegate
    var textField: UITextField?
    var errorLabel: UILabel?
    
    @objc func textFieldContinueButtonHandler() {
        if textFieldDelegate != nil {
            let error = textFieldDelegate?.continuePressed(textInput: textField!.text)
            
            if error == nil {
                nextViewControllerHandler()
                errorLabel!.isHidden = true
            }
            
            else {
                errorLabel!.text = error
                errorLabel!.isHidden = false
            }
        }
    }
    
    //Image Picker Delegate
    var imageView: UIImageView?
    var imagePickerContinueButton: UIButton?
    
    @objc func imagePickerSelectButtonHandler() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let myActionSheet = UIAlertController(title:"Profile Picture",message:"Select",preferredStyle: UIAlertController.Style.actionSheet)
        
        let photoGallery = UIAlertAction(title: "Photos", style: UIAlertAction.Style.default) { (action) in
            
            if UIImagePickerController.isSourceTypeAvailable( UIImagePickerController.SourceType.savedPhotosAlbum)
            {
                imagePickerController.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
                imagePickerController.allowsEditing = true
                self.present(imagePickerController, animated: true
                    , completion: nil)
            }
        }
        
        myActionSheet.addAction(photoGallery)
        myActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(myActionSheet, animated: true, completion: nil)
    }
    
    @objc func imagePickerContinueButtonHandler(sender: UIButton) {
        if imageView!.image != nil {
            nextViewControllerHandler()
        }
    }
    
    //General
    func nextViewControllerHandler() {
        let keyWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
        
        if let navigationController = keyWindow?.rootViewController as? UINavigationController {
            guard let nextViewController = genericStructureViewControllerMetadataDelegate?.nextViewController() else { return }
            navigationController.pushViewController(nextViewController, animated: true)
        }
    }
    
}

//MARK: Extensions
extension GenericStructureViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true
    }
}

extension GenericStructureViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        imageView!.image = image
        imagePickerContinueButton?.alpha = 1.0
        
        imagePickerDelegate?.imageWasSelected(image: image)
    
        self.dismiss(animated: true, completion: nil)
    }
}

extension GenericStructureViewController: UINavigationControllerDelegate {
    
}

//MARK: Delegate Protocols
protocol GenericStructureViewControllerMetadataDelegate {
    func databaseIdentifier() -> String
    
    func title() -> String
    func subtitle() -> String?
    
    func nextViewController() -> UIViewController
}

protocol ButtonsDelegate {
    func buttons() -> [String]
}

protocol TextFieldDelegate {
    func continuePressed(textInput: String?) -> String?
    func placeHolderText() -> String
}

protocol ImagePickerDelegate {
    func setInitialImage() -> UIImage
    func imageWasSelected(image: UIImage)
}
