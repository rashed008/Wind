//
//  APIClient.swift
//  Wind App
//
//  Created by RASHED on 7/14/24.
//

import Foundation
import Alamofire

protocol APIClient {
    func request<T: Decodable>(_ url: String, method: HTTPMethod, parameters: Parameters?, completion: @escaping (Result<T, AFError>) -> Void)
}

class AlamofireAPIClient: APIClient {
    func request<T: Decodable>(_ url: String, method: HTTPMethod, parameters: Parameters?, completion: @escaping (Result<T, AFError>) -> Void) {
        AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedObject = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedObject))
                } catch {
                    completion(.failure(AFError.responseSerializationFailed(reason: .decodingFailed(error: error))))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
