//
//  ExtensionUIViewController+Keyboard.swift
//  Wind App
//
//  Created by RASHED on 7/14/24.
//

import UIKit

extension UIViewController {
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        adjustViewForKeyboard(notification: notification, showing: true)
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        adjustViewForKeyboard(notification: notification, showing: false)
    }
    
    private func adjustViewForKeyboard(notification: NSNotification, showing: Bool) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        let keyboardHeight = showing ? keyboardFrame.height : 0
        adjustBottomConstraint(height: keyboardHeight, duration: animationDuration)
    }
    
    private func adjustBottomConstraint(height: CGFloat, duration: Double) {
        guard let bottomConstraint = view.constraints.first(where: { $0.identifier == "loginButtonBottomConstraint" }) else { return }
        bottomConstraint.constant = height + 20 
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
}
