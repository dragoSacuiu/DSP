//
//  LoginVC.swift
//  DSP
//
//  Created by Sacuiu Dragos on 28/02/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//

import Cocoa

protocol LoginVCDelegate {
    var accesGranted: Bool { get set }
    func exitApplication()
}

class LoginVC: NSViewController {
    
    var delegate: AlarmsViewController?
    let usersManager = UsersManager()
    let dspAlert = DspAlert()
    

    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        self.view.window?.styleMask.remove(.closable)
        self.view.window?.styleMask.remove(.resizable)
    }
    
    @IBAction func loginButton(_ sender: NSButton) {
        usersManager.addDefaultUser()
        if usersManager.userIsValid(name: nameTextField.stringValue, password: passwordTextField.stringValue) {
            UsersManager.activeUser = nameTextField.stringValue
            delegate!.accesGranted = true
            self.dismiss(self)
        } else {
            dspAlert.showAlert(message: "Wrong name or password!")
        }
    }
    
    @IBAction func exitApplicationButton(_ sender: NSButton) {
        delegate?.exitApplication()
    }
}
