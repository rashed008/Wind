//
//  LoginService.swift
//  Wind App
//
//  Created by RASHED on 7/14/24.
//

import Foundation
import Alamofire

protocol LoginService {
    func login(user: String, pin: String, completion: @escaping (Result<LoginResponse, ErrorResponse>) -> Void)
}

class AlamofireLoginService: LoginService {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func login(user: String, pin: String, completion: @escaping (Result<LoginResponse, ErrorResponse>) -> Void) {
        let url = "\(APIConstants.baseURL)\(APIConstants.loginEndpoint)"
        let parameters: [String: Any] = [
            "user": user,
            "pin": pin
        ]
        
        apiClient.request(url, method: .post, parameters: parameters) { (result: Result<LoginResponse, AFError>) in
            switch result {
            case .success(let response):
                if response.status {
                    completion(.success(response))
                } else {
                    let errorResponse = ErrorResponse(status: false, messages: response.messages, statusCode: 400)
                    completion(.failure(errorResponse))
                }
            case .failure(let error):
                if let data = error.underlyingError as? Data {
                    if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        completion(.failure(errorResponse))
                    } else {
                        completion(.failure(ErrorResponse.genericError))
                    }
                } else {
                    completion(.failure(ErrorResponse.genericError))
                }
            }
        }
    }
}

