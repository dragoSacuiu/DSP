//
//  UsersManager.swift
//  DSP
//
//  Created by Sacuiu Dragos on 28/02/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//

import Foundation

class UsersManager {
    
    let storeUsers = StoreUsers()
    
    static var activeUser = String()
    
    func addDefaultUser() {
        storeUsers.storeUser(name: "DSP", password: "12345")
    }
    
    func userIsValid(name: String, password: String) -> Bool {
        let users = storeUsers.getUsers()
        for user in users {
            guard user.name != name || user.password != password else {
                return true
            }
        }
        return false
    }
}
