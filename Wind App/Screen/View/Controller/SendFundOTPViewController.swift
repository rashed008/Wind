//
//  SendFundOTPViewController.swift
//  Wind App
//
//  Created by RASHED on 7/13/24.
//

import UIKit

protocol UserDataProvider {
    var userEmail: String? { get set }
    var userName: String? { get set }
    var userWalletAddress: String? { get set }
    var userProfileImage: String? { get set }
    var balance: Double? { get set }
    var currency: String? { get set }
}

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
    @IBOutlet weak var userNameErrorLabel: UILabel!
    @IBOutlet weak var apiErrorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginButtonBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    var userDataProvider: UserDataProvider = UserDataModel()
    
    // MARK: - Properties
    var viewModel: LoginViewModel?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNotifications()
        loginButton.isUserInteractionEnabled = false
        loginButton.alpha = 0.50
        disableOTPFields()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.userNameTextField.becomeFirstResponder()
        }
    }
    
    deinit {
        removeNotifications()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        UpdateOTPView()
    }
    
    private func setupNotifications() {
        setupKeyboardNotifications(continueButtonBottomConstraint: loginButtonBottomConstraint)
        NotificationCenter.default.addObserver(self, selector: #selector(validateForm), name: .usernameValidationChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enableOTPFields), name: .usernameValidationComplete, object: nil)
    }
    
    private func removeNotifications() {
        removeKeyboardNotifications()
        NotificationCenter.default.removeObserver(self, name: .usernameValidationChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .usernameValidationComplete, object: nil)
    }
    
    // MARK: - API Call
    func fetchLoginAPI() {
        let otpString = getOTPString()
        let user = userNameTextField.text ?? ""
        let pin = otpString
        let apiClient = AlamofireAPIClient()
        let loginService = AlamofireLoginService(apiClient: apiClient)
        viewModel = LoginViewModel(loginService: loginService, user: user, pin: pin)
        
        viewModel?.performLogin { [weak self] success, message in
            guard let self = self else { return }
            if success {
                if let loginResponse = self.viewModel?.loginResponse {
                    guard self.userDataProvider != nil else {
                        return
                    }
                    self.userDataProvider.userEmail = loginResponse.data?.userInfo?.email ?? ""
                    self.userDataProvider.userName = loginResponse.data?.userInfo?.userName ?? ""
                    self.userDataProvider.userWalletAddress = loginResponse.data?.userInfo?.walletAddress ?? ""
                    self.userDataProvider.userProfileImage = loginResponse.data?.userInfo?.profileImage ?? ""
                    self.userDataProvider.balance = loginResponse.data?.accountInfo?.balance ?? 0
                    self.userDataProvider.currency = loginResponse.data?.accountInfo?.currency ?? ""
                    push(from: Storyboard.main.rawValue, identifier: ViewControllerIdentifier.sendFundViewController.rawValue) { (viewController: SendFundViewController) in
                        viewController.userDataProvider = self.userDataProvider
                    }
                }
            } else {
                if let errorResponse = self.viewModel?.errorResponse {
                    self.apiErrorLabel.showAndFadeOut(text: errorResponse.messages[0], font: UIFont.CircularBoldFont(ofSize: 14), color: UIColor(red: 0.88, green: 0.26, blue: 0.26, alpha: 1.00))
                    print(errorResponse.messages)
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    private func getOTPString() -> String {
        let otpString = "\(textField1.text ?? "")\(textField2.text ?? "")\(textField3.text ?? "")\(textField4.text ?? "")"
        return otpString
    }
    
    @objc func enableOTPFields() {
        [textField1, textField2, textField3, textField4].forEach { $0?.isEnabled = true }
    }
    
    private func disableOTPFields() {
        [textField1, textField2, textField3, textField4].forEach { $0?.isEnabled = false }
    }
    
    // MARK: - UI Configuration
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
        
        [textField1, textField2, textField3, textField4].forEach {
            $0?.configureForOTP()
            $0?.delegate = self
            $0?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        
        [underline1, underline2, underline3, underline4].forEach {
            $0?.clipsToBounds = true
            $0?.layer.cornerRadius = 2
        }
    }
    
    // MARK: - UITextFieldDelegate Methods
    @objc private func textFieldDidChange(_ textField: UITextField) {
        validateForm()
    }
    
    // MARK: - Validation
    @objc func validateForm() {
        let isUsernameValid = userNameTextField.isValidUsername
        let otpString = getOTPString()
        let isOTPValid = otpString.count == 4 && otpString.allSatisfy { $0.isNumber }
        if !isUsernameValid {
            userNameErrorLabel.showAndFadeOut(text: "Invalid User Name", font: UIFont.CircularBoldFont(ofSize: 14), color: UIColor(red: 0.88, green: 0.26, blue: 0.26, alpha: 1.00))
        }
        let formIsValid = isUsernameValid && isOTPValid
        loginButton.isUserInteractionEnabled = formIsValid
        loginButton.alpha = formIsValid ? 1.0 : 0.50
    }
    
    // MARK: - Actions
    @IBAction func onTapContinueButton(_ sender: Any) {
        view.endEditing(true)
        fetchLoginAPI()
    }
    
    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let view = touch?.view, !(view is UITextField) {
            view.endEditing(true)
        }
    }
}
