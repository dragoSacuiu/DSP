//
//  AddContactVC.swift
//  DSP
//
//  Created by Sacuiu Dragos on 22/02/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//

import Cocoa

protocol AddContactVCDelegate {
    func addContact(priority: Int16, name: String, UserNr: Int16, postion: String, phoneNr: String, email: String, observation: String)
    func getContact() -> ContactEntity
    func reloadContactstableView()
}

class AddContactVC: NSViewController {
    var delegate: AddContactVCDelegate?
    
    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var priorityTextField: NSTextField!
    @IBOutlet weak var userNrTextField: NSTextField!
    @IBOutlet weak var positionTextField: NSTextField!
    @IBOutlet weak var phoneNrTextField: NSTextField!
    @IBOutlet weak var emailTextField: NSTextField!
    @IBOutlet weak var observationTextField: NSTextField!
    
    @IBOutlet weak var addContactButtonOutlet: NSButton!
    
    var contact: ContactEntity?
    var editButtonWasPressed = false

    override func viewDidLoad() {
        super.viewDidLoad()
        if editButtonWasPressed {
            addContactButtonOutlet.title = "SAVE"
            let contact = delegate!.getContact()
            priorityTextField.stringValue = String(contact.priority)
            nameTextField.stringValue = contact.name!
            userNrTextField.stringValue = String(contact.userNumber)
            positionTextField.stringValue = contact.position!
            phoneNrTextField.stringValue = contact.phoneNumber!
            emailTextField.stringValue = contact.email!
            observationTextField.stringValue = contact.observations!
        }
    }
    
    override func viewDidAppear() {
        view.window!.styleMask.remove(.resizable)
    }
    
    @IBAction func addContactButton(_ sender: NSButton) {
        if editButtonWasPressed {
            editContact()
        } else {
            delegate?.addContact(priority: Int16(priorityTextField.stringValue)!, name: nameTextField.stringValue, UserNr: Int16(userNrTextField.stringValue)!,
                                 postion: positionTextField.stringValue, phoneNr: phoneNrTextField.stringValue, email: emailTextField.stringValue, observation: observationTextField.stringValue)
        }
        delegate?.reloadContactstableView()
    }
    func editContact() {
        contact?.priority = Int16(priorityTextField.stringValue)!
        contact?.name = nameTextField.stringValue
        contact?.userNumber = Int16(userNrTextField.stringValue)!
        contact?.position = positionTextField.stringValue
        contact?.phoneNumber = phoneNrTextField.stringValue
        contact?.email = emailTextField.stringValue
        contact?.observations = observationTextField.stringValue
    }
}
