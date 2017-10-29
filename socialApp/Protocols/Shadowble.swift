//
//  Shadowble.swift
//  socialApp
//
//  Created by Luis  Costa on 29/10/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import UIKit

protocol Shadowble {}

extension Shadowble where Self: UIView {
    func addShadow() {
        layer.shadowColor = UIColor(displayP3Red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
}
