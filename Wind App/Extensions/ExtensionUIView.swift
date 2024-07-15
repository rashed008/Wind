//
//  ExtensionUIView.swift
//  Wind App
//
//  Created by RASHED on 7/15/24.
//

import UIKit

extension UIView {
    func applyCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }

    func applyShadow(radius: CGFloat = 4.0, opacity: Float = 0.5, offset: CGSize = CGSize(width: 0, height: 2), color: UIColor = .black) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
}


extension UIView {
    func applyGradientBackground(colors: [UIColor], locations: [NSNumber]? = nil) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = self.layer.cornerRadius
        self.layer.insertSublayer(gradientLayer, at: 0)
    }

    func applyGradientBorder(colors: [UIColor], lineWidth: CGFloat) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.bounds

        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = lineWidth
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        gradientLayer.mask = shapeLayer

        self.layer.addSublayer(gradientLayer)
    }

    func setBackgroundColorWithBorder() {
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        
        self.applyGradientBackground(colors: [
            UIColor(red: 1.0, green: 0.95, blue: 0.92, alpha: 0.4),
            UIColor(red: 1.0, green: 0.93, blue: 0.78, alpha: 0.4)
        ])
        
        // Apply gradient border
        self.applyGradientBorder(colors: [
            UIColor(red: 0.65, green: 0.0, blue: 1.0, alpha: 1.0),
            UIColor(red: 1.0, green: 0.55, blue: 0.0, alpha: 1.0)  
        ], lineWidth: 1.5)
    }
}
