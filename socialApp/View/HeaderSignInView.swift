//
//  HeaderSignInView.swift
//  socialApp
//
//  Created by Luis  Costa on 19/10/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import UIKit

extension UIView: Shadowble {}

class HeaderSignInView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        addShadow()
    }
}
