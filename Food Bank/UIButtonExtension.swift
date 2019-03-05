//
//  UIButtonExtension.swift
//  Food Bank
//
//  Created by Louis Lim Ying Wei on 26/3/18.
//  Copyright © 2018 Louis Lim Ying Wei. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func pulsate () {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.2
        pulse.fromValue = 0.95
        pulse.toValue = 1
        pulse.autoreverses = false
        pulse.repeatCount = 0
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        layer.add(pulse, forKey: nil)
    }
    
}
