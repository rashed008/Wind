//
//  UserDataProvider.swift
//  Wind App
//
//  Created by RASHED on 7/15/24.
//

import Foundation

struct UserDataModel: UserDataProvider {
    var userEmail: String?
    var userName: String?
    var userWalletAddress: String?
    var userProfileImage: String?
    var balance: Double?
    var currency: String?
}
