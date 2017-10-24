//
//  SignInButton.swift
//  socialApp
//
//  Created by Luis  Costa on 19/10/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import UIKit

class SignInButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = self.bounds.height / 4
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowOpacity = 0.8
        layer.shadowColor = UIColor(displayP3Red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
    }
}
