//
//  UserPAsswordConfirmationVC.swift
//  DSP
//
//  Created by Sacuiu Dragos on 26/02/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//

import Cocoa

protocol UserPAsswordConfirmationVCDelegate {
    var accesGranted: Bool { get set }
    func getUser() -> UserEntity
    func showUserDetails()
}

class UserPAsswordConfirmationVC: NSViewController {
    let dspAlert = DspAlert()
    
    var user: UserEntity?
    var delegate: AddUserVC?

    @IBOutlet weak var passwordConfirmationTextField: NSSecureTextField!
    
    @IBOutlet weak var message: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = delegate?.getUser()
        message.stringValue = "Please enter password for user: \(user!.name!)"
    }
    @IBAction func confirmationButton(_ sender: NSButton) {
        if user?.password == passwordConfirmationTextField.stringValue {
            delegate?.accesGranted = true
            delegate?.showUserDetails()
            self.dismiss(UserPAsswordConfirmationVC.self)
        } else {
            dspAlert.showAlert(message: "Wrong password \nAccess denied!")
        }
    }
}
