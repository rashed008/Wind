//
//  SendFundViewController.swift
//  Wind App
//
//  Created by RASHED on 7/15/24.
//

import UIKit

class SendFundViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var recipientLabel: UILabel!
    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var walletAddressLabel: UILabel!
    @IBOutlet weak var amountInputView: UIView!
    @IBOutlet weak var setBalanceTextField: UITextField!
    @IBOutlet weak var currencyName: UILabel!
    @IBOutlet weak var totalBalance: UILabel!
    @IBOutlet weak var maxBalanceButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var continueButtonButtomConstraint: NSLayoutConstraint!
    @IBOutlet weak var insufficientBalanceErrorLabel: UILabel!
    @IBOutlet weak var addFundButton: UIButton!
    
    // MARK: - Properties
    var userDataProvider: UserDataProvider?
    private var isShowingImageOne = true
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUppUI()
        setupKeyboardNotifications(continueButtonBottomConstraint: continueButtonButtomConstraint)
        setBalanceTextField.delegate = self
        updateUserData()
    }
    
    deinit {
        removeKeyboardNotifications()
    }
    
    // MARK: - Setup Methods
    private func setUppUI() {
        userInfoView.applyCornerRadius(10)
        userInfoView.applyShadow(radius: 2.0, opacity: 0.2, offset: CGSize(width: 0, height: 1), color: .black)
        
        headerTitleLabel.font = UIFont.CircularBoldFont(ofSize: 24)
        recipientLabel.font = UIFont.CircularBoldFont(ofSize: 16)
        amountInputView.setBackgroundColorWithBorder()
        
        continueButton.cornerRadius = 8
        continueButton.alpha = 0.50
        
        setBalanceTextField.setPlaceholder(text: "$0", color: .black)
        setBalanceTextField.font = UIFont.CircularBoldFont(ofSize: 48)
        setBalanceTextField.becomeFirstResponder()
        
        walletAddressLabel.font = UIFont.CircularBoldFont(ofSize: 16)
        
        insufficientBalanceErrorLabel.isHidden = true
        addFundButton.isHidden = true
    }
    
    // MARK: - Actions
    @IBAction func onTapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTapMaxBalanceButton(_ sender: Any) {
        toggleMaxBalance()
    }
    
    // MARK: - Helper Methods
    func toggleMaxBalance() {
        let newImageName = isShowingImageOne ? "maxBtnSelected" : "maxBtn"
        maxBalanceButton.setImage(UIImage(named: newImageName), for: .normal)
        
        let balance = userDataProvider?.balance ?? 0
        setBalanceTextField.text = isShowingImageOne ? "\(balance)" : ""
        totalBalance.text = "Balance USDC \(balance)"
        
        isShowingImageOne.toggle()
        continueButton.alpha = isShowingImageOne ? 0.50 : 1.00
    }
    
    func updateContinueButton(alpha: CGFloat) {
        DispatchQueue.main.async {
            self.continueButton.backgroundColor = UIColor(red: 0.43, green: 0.31, blue: 1.00, alpha: alpha)
        }
    }
    
    func updateBalanceDisplay(with text: String) {
        let inputValue = Double(text) ?? 0
        let balance = userDataProvider?.balance ?? 0
        
        if inputValue > balance {
            DispatchQueue.main.async {
                self.insufficientBalanceErrorLabel.isHidden = false
                self.addFundButton.isHidden = false
                self.addFundButton.alpha = 0.95
                self.addFundButton.isEnabled = false
                self.continueButton.alpha = 0.50
                self.view.endEditing(true)
            }
        } else {
            let remainingBalance = balance - inputValue
            DispatchQueue.main.async {
                self.totalBalance.text = "Balance USDC " + String(remainingBalance)
                self.insufficientBalanceErrorLabel.isHidden = true
                self.addFundButton.isHidden = true
                self.addFundButton.alpha = 1
                self.addFundButton.isEnabled = true
                self.continueButton.alpha = 1.00
            }
        }
    }
    
    private func updateUserData() {
        if let userDataProvider = userDataProvider {
            let userName = userDataProvider.userName ?? "N/A"
            let walletAddress = userDataProvider.userWalletAddress?.formattedWalletAddress() ?? "N/A"
            let fullString = "@\(userName) - \(walletAddress)"
            let userNameColor = UIColor(red: 0.43, green: 0.31, blue: 1.00, alpha: 1.00)
            let attributedString = fullString.attributedString(withColor: userNameColor, forSubstring: userName)
            walletAddressLabel.attributedText = attributedString
            
            currencyName.text = userDataProvider.currency ?? "N/A"
            totalBalance.text = "Balance USDC " + String(userDataProvider.balance ?? 0)
            
            if let imageUrlString = userDataProvider.userProfileImage,
               let imageUrl = URL(string: imageUrlString) {
                userImage.loadImage(from: imageUrl)
            }
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentValue: String = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.updateBalanceDisplay(with: currentValue)
        }
        
        let isEmpty = currentValue.isEmpty || (Double(currentValue) == 0)
        updateContinueButton(alpha: isEmpty ? 0.50 : 1.00)
        
        return true
    }
}
