//
//  ExtensionString.swift
//  Wind App
//
//  Created by RASHED on 7/15/24.
//

import Foundation
import UIKit

extension String {
    func formattedWalletAddress() -> String {
        guard self.count > 8 else {
            return self
        }
        
        let prefix = self.prefix(4)
        let suffix = self.suffix(4)
        return "\(prefix)...\(suffix)"
    }
}



extension String {
    func attributedString(withColor color: UIColor, forSubstring substring: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        if let range = self.range(of: substring) {
            let nsRange = NSRange(range, in: self)
            let fullRange = NSRange(location: nsRange.location - 1, length: nsRange.length + 1)
            attributedString.addAttribute(.foregroundColor, value: color, range: fullRange)
        }
        
        return attributedString
    }
}
