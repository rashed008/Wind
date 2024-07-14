//
//  LoginViewModel.swift
//  Wind App
//
//  Created by RASHED on 7/14/24.
//

import Foundation

class LoginViewModel {
    
    private let loginService: LoginService
    private let user: String
    private let pin: String
    
    var loginResponse: LoginResponse?
    var errorResponse: ErrorResponse?
    
    init(loginService: LoginService, user: String, pin: String) {
        self.loginService = loginService
        self.user = user
        self.pin = pin
    }
    
    func performLogin(completion: @escaping (Bool, String?) -> Void) {
        loginService.login(user: user, pin: pin) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.loginResponse = response
                completion(true, response.messages.joined(separator: ", "))
            case .failure(let error):
                self.errorResponse = error
                completion(false, error.messages.joined(separator: ", "))
            }
        }
    }
}


