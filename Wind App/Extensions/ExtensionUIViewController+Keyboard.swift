//
//  ExtensionUIViewController+Keyboard.swift
//  Wind App
//
//  Created by RASHED on 7/14/24.
//

import UIKit

extension UIViewController {
    func setupKeyboardNotifications(continueButtonBottomConstraint: NSLayoutConstraint) {
        // Add keyboard show/hide notifications
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            self.keyboardWillShow(notification: notification, continueButtonBottomConstraint: continueButtonBottomConstraint)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { notification in
            self.keyboardWillHide(notification: notification, continueButtonBottomConstraint: continueButtonBottomConstraint)
        }
        
        // Add tap gesture recognizer to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func keyboardWillShow(notification: Notification, continueButtonBottomConstraint: NSLayoutConstraint) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }

        let keyboardHeight = keyboardFrame.height
        UIView.animate(withDuration: animationDuration) {
            continueButtonBottomConstraint.constant = keyboardHeight //+ 20
            self.view.layoutIfNeeded()
        }
    }

    private func keyboardWillHide(notification: Notification, continueButtonBottomConstraint: NSLayoutConstraint) {
        guard let userInfo = notification.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }

        UIView.animate(withDuration: animationDuration) {
            continueButtonBottomConstraint.constant = 20
            self.view.layoutIfNeeded()
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
