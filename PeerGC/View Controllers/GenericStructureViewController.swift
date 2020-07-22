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

//MARK: GenericStructureViewController
class ConcreteGenericStructureViewController: UIViewController {
    
    static var dbData: [String: String] = [:]
    
    var headerDelegate: HeaderDelegate?
    var buttonsDelegate: ButtonsDelegate?
    var nextViewControllerDelegate: NextViewControllerDelegate?
    var databaseDelegate: DatabaseDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    //MARK: Layout
    
    func layout() {
        
        var headerStack: UIStackView? = nil
        
        if headerDelegate != nil {
            
            headerStack = initializeCustomStack(spacing: 10, distribution: .fill)
            headerStack!.addArrangedSubview(initializeCustomLabel(title: headerDelegate!.title(), size: Double(TITLE_TEXT_SIZE), color: .label))
            
            if headerDelegate!.subtitle() != nil {
                headerStack!.addArrangedSubview(initializeCustomLabel(title: headerDelegate!.subtitle()!, size: Double(SUBTITLE_TEXT_SIZE), color: .gray))
            }
            
            let headerStackConstraints: [NSLayoutConstraint] = [
                view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: headerStack!.trailingAnchor, constant: 20),
                view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: headerStack!.leadingAnchor, constant: -20),
                view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: headerStack!.topAnchor, constant: -10)
            ]
            
            headerStack!.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(headerStack!)
            NSLayoutConstraint.activate(headerStackConstraints)
            
        }
        
        if buttonsDelegate != nil {
            
            let buttonStack = initializeCustomStack(spacing: 10, distribution: .fillEqually)
            
            for buttonText in buttonsDelegate!.buttons() {
                buttonStack.addArrangedSubview(initializeCustomButton(title: buttonText, color: .systemPink, action: #selector(selectionButtonHandler(sender:))))
            }
            
            var buttonStackConstraints: [NSLayoutConstraint] = []
            
            if headerStack != nil {
                buttonStackConstraints = [NSLayoutConstraint(item: buttonStack, attribute: .top, relatedBy: .equal, toItem: headerStack, attribute: .bottom, multiplier: 1, constant: 30), view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: buttonStack.trailingAnchor, constant: 20), view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: buttonStack.leadingAnchor, constant: -20)]
            }
            
            else {
                buttonStackConstraints = [
                view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: buttonStack.trailingAnchor, constant: 20),
                view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: buttonStack.leadingAnchor, constant: -20),
                view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: buttonStack.topAnchor, constant: -30)
                ]
            }
            
            buttonStack.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(buttonStack)
            NSLayoutConstraint.activate(buttonStackConstraints)
        }
    }
    
    //MARK: Custom UI Initializers
    
    let FONT_NAME = "LexendDeca-Regular"
    let BUTTON_TEXT_SIZE = (1.5/71) * UIScreen.main.bounds.height
    let TITLE_TEXT_SIZE = (3.5/71) * UIScreen.main.bounds.height
    let SUBTITLE_TEXT_SIZE = (1.7/71) * UIScreen.main.bounds.height
    
    func initializeCustomButton(title: String, color: UIColor, action: Selector) -> UIButton {
        let toReturn = UIButton()
        toReturn.setTitle(title, for: .normal)
        toReturn.titleLabel!.font = UIFont(name: FONT_NAME, size: BUTTON_TEXT_SIZE)
        toReturn.setTitleColor(UIColor.label, for: .normal)
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
    
    //MARK: Handlers
    @objc func selectionButtonHandler(sender: UIButton) {
        ConcreteGenericStructureViewController.dbData[databaseDelegate!.databaseIdentifier()] = sender.titleLabel!.text!
    }
    
}

//MARK: Delegate Protocols

protocol DatabaseDelegate {
    func databaseIdentifier() -> String
}

protocol HeaderDelegate {
    func title() -> String
    func subtitle() -> String?
}

protocol ButtonsDelegate {
    func buttons() -> [String]
}

protocol NextViewControllerDelegate {
    func nextViewController() -> UIViewController
}
