//
//  LoginResponse.swift
//  Wind App
//
//  Created by RASHED on 7/14/24.
//

import Foundation

struct LoginResponse: Codable {
    let status: Bool
    let messages: [String]
    let data: UserData?
}

struct UserData: Codable {
    let userInfo: UserInfo?
    let accountInfo: AccountInfo?
}

struct UserInfo: Codable {
    let id: Int?
    let email: String?
    let userName: String?
    let walletAddress: String?
    let smartContactWallet: String?
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case email = "Email"
        case userName = "UserName"
        case walletAddress = "WalletAddress"
        case smartContactWallet = "smartContactWallet"
        case profileImage = "ProfileImage"
    }
}

struct AccountInfo: Codable {
    let balance: Double?
    let currency: String?
    
    enum CodingKeys: String, CodingKey {
        case balance = "balance"
        case currency = "currency"
    }
}
