//
//  AddZoneVC.swift
//  DSP
//
//  Created by Sacuiu Dragos on 13/02/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//

import Cocoa

protocol AddZoneVCDelegate {
    func addZone(number: Int, name: String)
    func getZone() -> ZoneEntity
    func reloadZonesTableView()
}

class AddZoneVC: NSViewController {
    var delegate: AddZoneVCDelegate?
    
    var zone: ZoneEntity?
    var editButtonPressed = false
    
    @IBOutlet weak var addButtonOutlet: NSButton!
    @IBOutlet weak var zoneNameTextField: NSTextField!
    @IBOutlet weak var zoneNumberTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if editButtonPressed {
            addButtonOutlet.title = "SAVE"
            zone = delegate?.getZone()
            zoneNumberTextField.stringValue = String(zone!.number)
            zoneNameTextField.stringValue = zone!.name!
        }
    }
    override func viewDidAppear() {
        view.window!.styleMask.remove(.resizable)
    }
    
    @IBAction func addZoneButton(_ sender: NSButton) {
        if editButtonPressed {
            zone?.number = Int16(zoneNumberTextField.stringValue)!
            zone?.name = zoneNameTextField.stringValue
        } else {
            delegate?.addZone(number: Int(zoneNumberTextField.stringValue)!, name: zoneNameTextField.stringValue)
            clearFields()
        }
        delegate?.reloadZonesTableView()
    }

    func clearFields() {
        zoneNameTextField.stringValue = ""
        zoneNumberTextField.stringValue = ""
        zoneNameTextField.becomeFirstResponder()
    }
}
