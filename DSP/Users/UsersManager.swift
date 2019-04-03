//
//  UsersManager.swift
//  DSP
//
//  Created by Sacuiu Dragos on 28/02/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//

import Foundation

class UsersManager {
    private let dspAlert = DspAlert()
    private let storeUsers = StoreUsers()
    static var activeUser = String()
    
    func userIsValid(name: String, password: String) -> Bool {
        let users = storeUsers.getUsers()
        guard users.count != 0 else {
            dspAlert.showAlert(message: "No user is created. Please create at least one user.")
            return true }
        for user in users {
            if user.name == name && user.password == password {
                UsersManager.activeUser = user.name!
                return true
            }
        }
        return false
    }
}
