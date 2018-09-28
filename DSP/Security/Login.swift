//
//  Login.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Foundation

struct Login {
    let admin = User(Name: "admin", Password: "12345")
    var users: [User]
    
    init() {
        self.users = [User]()
        self.users.append(admin)
    }
    
   mutating func addUser(Name: String, Password: String) {
        let newUser = User(Name: Name, Password: Password)
        self.users.append(newUser)
    }
}
