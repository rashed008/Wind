//
//  ExtensionImage.swift
//  Wind App
//
//  Created by RASHED on 7/15/24.
//

import UIKit

extension UIImageView {
    func makeRound() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
    func loadImage(from url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                    self?.makeRound()
                }
            }
        }
    }
}
