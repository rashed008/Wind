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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        for family: String in UIFont.familyNames
        {
            print(family)
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }
        
        UpdateOTPView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.scrollView.updateContentView()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func UpdateOTPView() {
        headerTtitleLabel.font = UIFont.CircularBoldFont(ofSize: 24)
        userNameTextField.becomeFirstResponder()
        userNameTextField.font = UIFont.CircularBoldFont(ofSize: 16)
        
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
        }
        
        [underline1, underline2, underline3, underline4].forEach { underline in
            underline?.clipsToBounds = true
            underline?.layer.cornerRadius = 2
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let view = touch?.view, !(view is UITextField) {
            view.endEditing(true)
        }
    }
    
}

