//
//  ExtensionUILabel.swift
//  Wind App
//
//  Created by RASHED on 7/15/24.
//

import UIKit

extension UILabel {
    func showAndFadeOut(text: String, font: UIFont, color: UIColor, duration: TimeInterval = 6) {
        self.text = text
        self.font = font
        self.textColor = color
        self.alpha = 1.0

        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 1, animations: {
                self.alpha = 0.0
            })
        }
    }
}
