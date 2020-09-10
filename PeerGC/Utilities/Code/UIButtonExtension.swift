//
//  UIButtonExtension.swift
//  PathFinder
//
//  Created by AJ Radik on 4/7/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

let buttonAnimationDuration = 0.5
let buttonAnimationDelay: TimeInterval = 0
let buttonAnimationSpringWithDamping: CGFloat = 0.5
let buttonAnimationInitialSpringVelocity: CGFloat = 6
let buttonAnimationXYScale: CGFloat = 1.4

extension DesignableButton {
        
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()

        UIView.animate(withDuration: buttonAnimationDuration,
                       delay: buttonAnimationDelay,
                       usingSpringWithDamping: buttonAnimationSpringWithDamping,
                       initialSpringVelocity: buttonAnimationInitialSpringVelocity,
                       options: .allowUserInteraction, animations: {
                           self.transform = CGAffineTransform(scaleX: buttonAnimationXYScale, y: buttonAnimationXYScale)
                       }, completion: nil)
        
        UIView.animate(withDuration: buttonAnimationDuration,
                       delay: buttonAnimationDelay,
                       usingSpringWithDamping: buttonAnimationSpringWithDamping,
                       initialSpringVelocity: buttonAnimationInitialSpringVelocity,
                       options: .allowUserInteraction, animations: {
                           self.transform = CGAffineTransform.identity
                       }, completion: nil)
    }
    
}

@IBDesignable
class CardButton: UIButton {

}
