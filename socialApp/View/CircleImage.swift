//
//  CircleImage.swift
//  socialApp
//
//  Created by Luis  Costa on 29/10/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import UIKit

class CircleImage: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
    }

}
