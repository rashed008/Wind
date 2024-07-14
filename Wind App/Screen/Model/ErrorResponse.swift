//
//  ErrorResponse.swift
//  Wind App
//
//  Created by RASHED on 7/14/24.
//

import Foundation

struct ErrorResponse: Codable, Error {
    let status: Bool
    let messages: [String]
    let statusCode: Int
    
    static var genericError: ErrorResponse {
        return ErrorResponse(status: false, messages: ["Something went wrong"], statusCode: 400)
    }
}
