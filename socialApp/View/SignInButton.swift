//
//  SignInButton.swift
//  socialApp
//
//  Created by Luis  Costa on 19/10/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import UIKit

extension UIButton {
    func roundButton() {
        let radius = self.frame.height / 2
        layer.cornerRadius = radius
    }
}

class SignInButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        addShadow()
        roundButton()
    }
}
