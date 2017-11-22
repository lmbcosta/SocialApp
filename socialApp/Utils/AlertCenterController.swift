//
//  AlertCenterController.swift
//  socialApp
//
//  Created by Luis  Costa on 21/11/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import Foundation
import UIKit

class AlertCenterController {
    static var shared = AlertCenterController()
    
    private init() {}
    
    func createAlert(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        vc.present(alert, animated: true, completion: nil)
    }
}
