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
        
        let regex = "^(?!.*[_.]{2})[a-z0-9._]{3,32}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValidLength = text.count >= 3 && text.count <= 32
        let containsLetter = text.rangeOfCharacter(from: .letters) != nil
        let startsWithLetter = text.prefix(1).rangeOfCharacter(from: .letters) != nil
        
        isValidUsername = predicate.evaluate(with: text) && isValidLength && containsLetter && startsWithLetter
        print("Username valid: \(isValidUsername)")
        NotificationCenter.default.post(name: .usernameValidationComplete, object: self)
    }
}

extension Notification.Name {
    static let usernameValidationChanged = Notification.Name("usernameValidationChanged")
    static let usernameValidationComplete = Notification.Name("usernameValidationComplete")
}
