//
//  SendFundOTPViewController.swift
//  Wind App
//
//  Created by RASHED on 7/13/24.
//

import UIKit

class SendFundOTPViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var headerTtitleLabel: UILabel!
    @IBOutlet weak var userNameTitleLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var textField4: UITextField!
    @IBOutlet weak var underline1: UIView!
    @IBOutlet weak var underline2: UIView!
    @IBOutlet weak var underline3: UIView!
    @IBOutlet weak var underline4: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginButtonBottomConstraint: NSLayoutConstraint!
    
    var viewModel: LoginViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateOTPView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        scrollView.addGestureRecognizer(tapGesture)
        
        // Register for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Configure username text field
        NotificationCenter.default.addObserver(self, selector: #selector(validateForm), name: .usernameValidationChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enableOTPFields), name: .usernameValidationComplete, object: nil)
        
        loginButton.isEnabled = false
        loginButton.alpha = 0.7
        disableOTPFields()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.userNameTextField.becomeFirstResponder()
        }
    }
    
    deinit {
        // Remove notifications
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .usernameValidationChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .usernameValidationComplete, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        let keyboardHeight = keyboardFrame.height
        
        UIView.animate(withDuration: animationDuration) {
            self.loginButtonBottomConstraint.constant = keyboardHeight + 20
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        UIView.animate(withDuration: animationDuration) {
            self.loginButtonBottomConstraint.constant = 20
            self.view.layoutIfNeeded()
        }
    }
    
    func fetchAPI() {
        let otpString = getOTPString()
        let user = userNameTextField.text ?? ""
        let pin = otpString
        let apiClient = AlamofireAPIClient()
        let loginService = AlamofireLoginService(apiClient: apiClient)
        viewModel = LoginViewModel(loginService: loginService, user: user, pin: pin)
        
        viewModel?.performLogin { [weak self] success, message in
            guard let self = self else { return }
            if success {
                print("Login successful")
                if let loginResponse = self.viewModel?.loginResponse {
                    print(loginResponse.data?.userInfo?.email ?? "")
                }
            } else {
                print("Login failed: \(message ?? "Unknown error")")
                if let errorResponse = self.viewModel?.errorResponse {
                    UIAlertController.showAutoDismissAlert(title: "", message: errorResponse.messages[0] , in: self)
                    print(errorResponse.messages)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.scrollView.updateContentView()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    func UpdateOTPView() {
        userNameTextField.configureForUsernameValidation()
        headerTtitleLabel.font = UIFont.CircularBoldFont(ofSize: 24)
        userNameTextField.font = UIFont.CircularBoldFont(ofSize: 16)
        loginButton.cornerRadius = 8
        
        textField1.nextTextField = textField2
        textField2.nextTextField = textField3
        textField3.nextTextField = textField4
        textField2.previousTextField = textField1
        textField3.previousTextField = textField2
        textField4.previousTextField = textField3
        
        textField1.underlineView = underline1
        textField2.underlineView = underline2
        textField3.underlineView = underline3
        textField4.underlineView = underline4
        
        [textField1, textField2, textField3, textField4].forEach { textField in
            textField?.configureForOTP()
            textField?.delegate = self
            textField?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        
        [underline1, underline2, underline3, underline4].forEach { underline in
            underline?.clipsToBounds = true
            underline?.layer.cornerRadius = 2
        }
    }
    
    func getOTPString() -> String {
        let otpString = "\(textField1.text ?? "")\(textField2.text ?? "")\(textField3.text ?? "")\(textField4.text ?? "")"
        print("OTP String: \(otpString)")
        return otpString
    }
    
    @objc func enableOTPFields() {
        [textField1, textField2, textField3, textField4].forEach { textField in
            textField?.isEnabled = true
        }
    }
    
    func disableOTPFields() {
        [textField1, textField2, textField3, textField4].forEach { textField in
            textField?.isEnabled = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let view = touch?.view, !(view is UITextField) {
            view.endEditing(true)
        }
    }
    
    @IBAction func onTapContinueButton(_ sender: Any) {
        fetchAPI()
    }
    
    @objc private func validateForm() {
        let isUsernameValid = userNameTextField.isValidUsername
        let otpString = getOTPString()
        let isOTPValid = otpString.count == 4 && otpString.allSatisfy { $0.isNumber }
        if isUsernameValid {
            print("It's valid and it's true")
        } else {
            //UIAlertController.showAutoDismissAlert(title: "", message: "Invalid User Name", in: self)
            print("It's not valid and it's false")
        }
        print("Username valid: \(isUsernameValid), OTP valid: \(isOTPValid), OTP: \(otpString)")
        let formIsValid = isUsernameValid && isOTPValid
        loginButton.isEnabled = formIsValid
        loginButton.alpha = formIsValid ? 1.0 : 0.7
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        print("Text field \(textField.tag) changed to: \(textField.text ?? "")")
        validateForm()
    }
}
