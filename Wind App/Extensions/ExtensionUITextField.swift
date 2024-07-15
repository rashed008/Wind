
import UIKit

extension UITextField {
    private struct AssociatedKeys {
        static var isValidUsernameKey = "isValidUsernameKey"
        static var debounceTimerKey = "debounceTimerKey"
    }
    
    var isValidUsername: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.isValidUsernameKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isValidUsernameKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            NotificationCenter.default.post(name: .usernameValidationChanged, object: self)
        }
    }
    
    private var debounceTimer: Timer? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.debounceTimerKey) as? Timer
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.debounceTimerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func configureForUsernameValidation() {
        self.addTarget(self, action: #selector(validateUsername), for: .editingChanged)
    }
    
    @objc private func validateUsername() {
        self.text = self.text?.lowercased()
        self.text = String(self.text?.prefix(32) ?? "")
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(debouncedValidation), userInfo: nil, repeats: false)
    }
    
    @objc private func debouncedValidation() {
        guard let text = self.text else {
            isValidUsername = false
            return
        }
        
        if text.isEmpty {
            isValidUsername = true
            return
        }
        
        let containsAtLeastOneAlphabet = text.range(of: "[a-zA-Z]", options:.regularExpression) != nil
        let hasThreeCharacters = text.count >= 3
        let hasNoNumberInFirstThreeCharacters = text.prefix(3).range(of: "[0-9]", options:.regularExpression) == nil
        let doesNotContainSpecialCharsExceptDotAndUnderscore = text.range(of: "[^a-zA-Z0-9._]", options:.regularExpression) == nil
        let doesNotContainConsecutiveDots = text.range(of: "\\.{2,}", options:.regularExpression) == nil
        let doesNotContainConsecutiveUnderscores = text.range(of: "_{2,}", options:.regularExpression) == nil
        let isValidLength = text.count <= 32
        
        isValidUsername = containsAtLeastOneAlphabet && hasThreeCharacters && hasNoNumberInFirstThreeCharacters && doesNotContainSpecialCharsExceptDotAndUnderscore && doesNotContainConsecutiveDots && doesNotContainConsecutiveUnderscores && isValidLength
        print("Username valid: \(isValidUsername)")
        NotificationCenter.default.post(name:.usernameValidationComplete, object: self)
    }
}

extension Notification.Name {
    static let usernameValidationChanged = Notification.Name("usernameValidationChanged")
    static let usernameValidationComplete = Notification.Name("usernameValidationComplete")
}



