//
//  SendFundViewControllerTests.swift
//  Wind AppTests
//
//  Created by RASHED on 7/16/24.
//

import XCTest
@testable import Wind_App

class MockUserDataProvider: UserDataProvider {
    var userEmail: String?
    var userName: String?
    var userWalletAddress: String?
    var balance: Double?
    var userProfileImage: String?
    var currency: String?
}

final class SendFundViewControllerTests: XCTestCase {
    
    var viewController: SendFundViewController!
    var mockUserDataProvider: MockUserDataProvider!
    
    override func setUp() {
        super.setUp()
        viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "SendFundViewController") as? SendFundViewController
        viewController.loadViewIfNeeded()
        mockUserDataProvider = MockUserDataProvider()
        viewController.userDataProvider = mockUserDataProvider
    }
    
    override func tearDown() {
        viewController = nil
        mockUserDataProvider = nil
        super.tearDown()
    }

    func testViewDidLoad() {
        viewController.viewDidLoad()
        XCTAssertNotNil(viewController.setBalanceTextField.delegate)
        XCTAssertEqual(viewController.setBalanceTextField.font, UIFont.CircularBoldFont(ofSize: 48))
        XCTAssertEqual(viewController.totalBalance.text, "Balance USDC 0.0")
        XCTAssertTrue(viewController.insufficientBalanceErrorLabel.isHidden)
        XCTAssertTrue(viewController.addFundButton.isHidden)
    }
    
    func testToggleMaxBalance() {
        mockUserDataProvider.balance = 100.0
        viewController.setBalanceTextField.text = ""
        viewController.toggleMaxBalance()
        XCTAssertEqual(viewController.setBalanceTextField.text, "100.0")
        XCTAssertEqual(viewController.totalBalance.text, "Balance USDC 100.0")
        XCTAssertEqual(viewController.continueButton.alpha, 1.00)
    }
    
    func testUpdateBalanceDisplayWithInsufficientBalance() {
        mockUserDataProvider.balance = 100.0
        let expectation = XCTestExpectation(description: "UI updates")
        viewController.updateBalanceDisplay(with: "150")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.viewController.insufficientBalanceErrorLabel.isHidden)
            XCTAssertFalse(self.viewController.addFundButton.isHidden)
            XCTAssertEqual(self.viewController.continueButton.alpha, 0.50)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testUpdateBalanceDisplayWithSufficientBalance() {
        mockUserDataProvider.balance = 100.0
        viewController.updateBalanceDisplay(with: "50")
        XCTAssertTrue(viewController.insufficientBalanceErrorLabel.isHidden)
        XCTAssertTrue(viewController.addFundButton.isHidden)
        XCTAssertEqual(viewController.totalBalance.text, "Balance USDC 381.24")
        XCTAssertEqual(viewController.continueButton.alpha, 0.50)
    }
    
    func testTextFieldShouldChangeCharacters() {
        let textField = viewController.setBalanceTextField
        let range = NSRange(location: 0, length: 0)
        let result = viewController.textField(textField!, shouldChangeCharactersIn: range, replacementString: "50")
        XCTAssertTrue(result)
        XCTAssertEqual(viewController.setBalanceTextField.text, "")
        XCTAssertEqual(viewController.totalBalance.text, "Balance USDC 381.24")
        XCTAssertEqual(viewController.continueButton.alpha, 0.50)
    }
}
