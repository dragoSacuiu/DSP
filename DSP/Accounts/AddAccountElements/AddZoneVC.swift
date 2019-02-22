//
//  AddZoneVC.swift
//  DSP
//
//  Created by Sacuiu Dragos on 13/02/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//

import Cocoa

protocol AddZoneDelegate {
    func addZone(number: Int, name: String)
    func getZone() -> ZoneEntity
}

class AddZoneVC: NSViewController {
    var delegate: AddZoneDelegate?
    
    var editButtonPressed = false
    
    @IBOutlet weak var zoneName: NSTextField!
    @IBOutlet weak var zoneNumber: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if editButtonPressed {
            let zoneToEdit = delegate?.getZone()
            zoneNumber.stringValue = String(zoneToEdit!.number)
            zoneName.stringValue = zoneToEdit!.name!
        }
    }
    
    @IBAction func addZoneButton(_ sender: NSButton) {
        addZone()
        clearFields()
    }
    
    func addZone() {
        delegate?.addZone(number: Int(zoneNumber.stringValue)!, name: zoneName.stringValue)
    }
    func clearFields() {
        zoneName.stringValue = ""
        zoneNumber.stringValue = ""
    }
}
