//
//  SendFundOTPViewControllerTests.swift
//  Wind AppTests
//
//  Created by RASHED on 7/16/24.
//

import XCTest
@testable import Wind_App

final class SendFundOTPViewControllerTests: XCTestCase {
    
    var viewController: SendFundOTPViewController!
    var mockUserDataProvider: MockUserDataProvider!
    
    override func setUp() {
        super.setUp()
        viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "SendFundOTPViewController") as? SendFundOTPViewController
        viewController.loadViewIfNeeded()
        mockUserDataProvider = MockUserDataProvider()
        viewController.userDataProvider = mockUserDataProvider
    }
    
    override func tearDown() {
        viewController = nil
        mockUserDataProvider = nil
        super.tearDown()
    }
    
    func test_ViewDidLoad() {
        viewController.viewDidLoad()
        XCTAssertEqual(viewController.headerTtitleLabel.font, UIFont.CircularBoldFont(ofSize: 24))
        XCTAssertEqual(viewController.userNameTextField.font, UIFont.CircularBoldFont(ofSize: 16))
        XCTAssertEqual(viewController.loginButton.cornerRadius, 8)
        XCTAssertFalse(viewController.textField1.isEnabled)
        XCTAssertFalse(viewController.textField2.isEnabled)
        XCTAssertFalse(viewController.textField3.isEnabled)
        XCTAssertFalse(viewController.textField4.isEnabled)
    }
    
    func test_EnableOTPFields() {
        viewController.enableOTPFields()
        XCTAssertTrue(viewController.textField1.isEnabled)
        XCTAssertTrue(viewController.textField2.isEnabled)
        XCTAssertTrue(viewController.textField3.isEnabled)
        XCTAssertTrue(viewController.textField4.isEnabled)
    }
    
    func test_DisableOTPFields() {
        XCTAssertFalse(viewController.textField1.isEnabled)
        XCTAssertFalse(viewController.textField2.isEnabled)
        XCTAssertFalse(viewController.textField3.isEnabled)
        XCTAssertFalse(viewController.textField4.isEnabled)
    }
    
    func test_ValidateFormWithValidUsernameAndOTP() {
        viewController.userNameTextField.text = "ValidUsername"
        viewController.textField1.text = "1"
        viewController.textField2.text = "2"
        viewController.textField3.text = "3"
        viewController.textField4.text = "4"
        viewController.validateForm()
        XCTAssertEqual(viewController.loginButton.alpha, 0.50)
    }
    
    func test_ValidateFormWithInvalidUsername() {
        viewController.userNameTextField.text = "In@alid"
        viewController.textField1.text = "1"
        viewController.textField2.text = "2"
        viewController.textField3.text = "3"
        viewController.textField4.text = "4"
        viewController.validateForm()
        XCTAssertEqual(viewController.loginButton.alpha, 0.50)
        XCTAssertEqual(viewController.userNameErrorLabel.text, "Invalid User Name")
        XCTAssertFalse(viewController.userNameErrorLabel.isHidden)
    }
    
    func test_ValidateFormWithInvalidOTP() {
        viewController.userNameTextField.text = "ValidUsername"
        viewController.textField1.text = "1"
        viewController.textField2.text = "2"
        viewController.textField3.text = ""
        viewController.textField4.text = "4"
        viewController.validateForm()
        XCTAssertFalse(viewController.loginButton.isUserInteractionEnabled)
        XCTAssertEqual(viewController.loginButton.alpha, 0.50)
    }
    
    class MockUserDataProvider: UserDataProvider {
        var userEmail: String?
        var userName: String?
        var userWalletAddress: String?
        var userProfileImage: String?
        var balance: Double?
        var currency: String?
    }
}
