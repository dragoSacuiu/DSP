//
//  Users.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Foundation

struct User {
    var name: String
    var password: String
    
    init(Name: String, Password: String) {
        self.name = Name
        self.password = Password
    }
    
    mutating func changeName(NewName: String) {
        self.name = NewName
    }
    mutating func changePassword(NewPassword: String){
        self.password = NewPassword
    }
}
