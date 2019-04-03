//
//  AddManagerVC.swift
//  DSP
//
//  Created by Sacuiu Dragos on 26/02/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//

import Cocoa

protocol AddManagerVCDelegate {
    func addManager(name: String, email: String)
    func getManager() -> ManagerEntity
}

class AddManagerVC: NSViewController {
    
    var delegate: UsersVC?
    
    var editButtonPressed = false
    private var manager: ManagerEntity?

    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var emailTextField: NSTextField!
    @IBOutlet weak var addManagerButtonOutlet: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if editButtonPressed {
            addManagerButtonOutlet.title = "SAVE CHANGES"
            manager = delegate?.getManager()
            nameTextField.stringValue = manager!.name!
            emailTextField.stringValue = manager!.email!
        }
        
    }
    @IBAction func addManagerButton(_ sender: NSButton) {
        if editButtonPressed {
            manager?.name = nameTextField.stringValue
            manager?.email = emailTextField.stringValue
            self.dismiss(AddManagerVC.self)
        } else {
            delegate?.addManager(name: nameTextField.stringValue, email: emailTextField.stringValue)
            clearTextFields()
        }
    }
    private func clearTextFields() {
        nameTextField.stringValue = ""
        emailTextField.stringValue = ""
        nameTextField.becomeFirstResponder()
    }
    
}
