//
//  AddUserVC.swift
//  DSP
//
//  Created by Sacuiu Dragos on 26/02/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//

import Cocoa

protocol AddUserVCDelegate {
    func addUser(name: String, password: String)
    func getUser() -> UserEntity
}

class AddUserVC: NSViewController, UserPAsswordConfirmationVCDelegate {
    private let dspAlert = DspAlert()
    var delegate: UsersVC?
    
    @IBOutlet weak var addButtonOutlet: NSButton!
    
    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSSecureTextField!
    @IBOutlet weak var confirmPasswordTextField: NSSecureTextField!
    
    private var user: UserEntity?
    var editButtonPressed = false
    var accesGranted = false

    override func viewDidLoad() {
        super.viewDidLoad()
        if editButtonPressed {
            addButtonOutlet.title = "SAVE CHANGES"
            user = delegate?.getUser()
            let storyboard = NSStoryboard(name: "Main", bundle: nil)
            let passwordConfirmationVC = storyboard.instantiateController(withIdentifier: "passwordConfirmationVC") as! UserPAsswordConfirmationVC
            passwordConfirmationVC.delegate = self
            self.presentAsModalWindow(passwordConfirmationVC)
        }
    }
    
    @IBAction func addButton(_ sender: NSButton) {
        if !editButtonPressed {
            if allFieldsAreFill() && passwordMach() {
                delegate?.addUser(name: nameTextField.stringValue, password: passwordTextField.stringValue)
                clearFields()
            }
        } else {
            guard !accesGranted else {
                guard !allFieldsAreFill() && !passwordMach() else {
                    user?.name = nameTextField.stringValue
                    user?.password = passwordTextField.stringValue
                    return
                }
                return
            }
        }
    }
    
    func getUser() -> UserEntity {
        return user!
    }
    
    private func passwordMach() -> Bool {
        if passwordTextField.stringValue == confirmPasswordTextField.stringValue {
            return true
        } else {
            dspAlert.showAlert(message: "Password didn't match!")
            return false
        }
    }
    
    private func allFieldsAreFill() -> Bool {
        if nameTextField.stringValue != "" && passwordTextField.stringValue != "" && confirmPasswordTextField.stringValue != "" {
            return true
        } else {
            dspAlert.showAlert(message: "Please fill all fields!")
            return false
        }
    }
    
    func showUserDetails() {
        nameTextField.stringValue = user!.name!
    }
    
    private func clearFields() {
        confirmPasswordTextField.stringValue = ""
        passwordTextField.stringValue = ""
        nameTextField.stringValue = ""
        nameTextField.becomeFirstResponder()
    }
}
