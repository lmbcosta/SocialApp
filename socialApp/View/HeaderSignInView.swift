//
//  HeaderSignInView.swift
//  socialApp
//
//  Created by Luis  Costa on 19/10/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import UIKit

class HeaderSignInView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(displayP3Red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        
        layer.opacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
    }
}
