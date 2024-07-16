//
//  ExtensionUIText+OTP.swift
//  Wind App
//
//  Created by RASHED on 7/14/24.
//

import UIKit

extension UITextField {
    private struct AssociatedKeys {
        static var nextTextFieldKey = "nextTextFieldKey"
        static var previousTextFieldKey = "previousTextFieldKey"
        static var underlineViewKey = "underlineViewKey"
    }
    
    @IBInspectable var nextTextField: UITextField? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.nextTextFieldKey) as? UITextField
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.nextTextFieldKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @IBInspectable var previousTextField: UITextField? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.previousTextFieldKey) as? UITextField
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.previousTextFieldKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @IBInspectable var underlineView: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.underlineViewKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.underlineViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateUnderlineColor()
        }
    }
    
    func configureForOTP() {
        self.delegate = self
        self.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        self.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        self.keyboardType = .numberPad
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if text.count > 1 {
            textField.text = String(text.prefix(1))
        }
        
        if text.isEmpty {
            previousTextField?.becomeFirstResponder()
        } else {
            nextTextField?.becomeFirstResponder()
        }
        
        updateUnderlineColor()
    }
    
    @objc public func textFieldDidBeginEditing(_ textField: UITextField) {
        animateUnderlineColor(to: .black)
    }
    
    @objc public func textFieldDidEndEditing(_ textField: UITextField) {
        updateUnderlineColor()
    }
    
    private func updateUnderlineColor() {
        let color = self.isFirstResponder || !(self.text?.isEmpty ?? true) ? UIColor.black : UIColor.lightGray
        animateUnderlineColor(to: color)
    }
    
    private func animateUnderlineColor(to color: UIColor) {
        UIView.animate(withDuration: 0.3) {
            self.underlineView?.backgroundColor = color
        }
    }
}

extension UITextField: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            if range.location == 0 {
                textField.text = ""
                previousTextField?.becomeFirstResponder()
                return false
            }
        } else {
            textField.text = string
            nextTextField?.becomeFirstResponder()
            return false
        }
        return true
    }
}

extension UITextField {
    func setPlaceholder(text: String, color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [
                .foregroundColor: color,
            ]
        )
    }
}
