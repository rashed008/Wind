//
//  ExtensionAlert.swift
//  Wind App
//
//  Created by RASHED on 7/14/24.
//

import UIKit

extension UIAlertController {
    static func showAutoDismissAlert(title: String?, message: String?, duration: TimeInterval = 1.5, in viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        viewController.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
}

