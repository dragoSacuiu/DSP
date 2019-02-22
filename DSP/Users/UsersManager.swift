//
//  UsersManager.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Foundation

class UsersManager {
    var defaultUser = User(Name: "admin", Password: "12345")
    static var activeUser = "Sacuiu Dragos"
    var users = [User]()
    
//    init(LoginUser: User) {
//        users.append(defaultUser)
//        self.activeUser = LoginUser
//    }
    
    func addUser(Name: String, Password: String) {
        let newUser = User(Name: Name, Password: Password)
        self.users.append(newUser)
    }
    
    func deleteUser(Name: String) {
        for index in 0..<users.count {
            if Name == users[index].name {
                users.remove(at: index)
            }
        }
    }
    
    func renameUser(OldName: String, NewName: String) {
        for index in 0..<users.count {
            if OldName == users[index].name {
                users[index].name = NewName
            }
        }
    }
    
    func changePassword(NewPassword: String, ConfirmPassword: String) {
        guard NewPassword == ConfirmPassword else {
            return print("Password doesn't match")
        }
        for index in 0..<users.count {
            if defaultUser.name == users[index].name {
                users[index].password = NewPassword
            }
        }
    }
}
