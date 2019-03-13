//
//  AddEmiVC.swift
//  DSP
//
//  Created by Sacuiu Dragos on 11/03/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//

import Cocoa

protocol AddEmiVCDelegate {
    func addEmi(id: String, phone: String, active: Bool, statusDetails: String, longitude: Double, latitude: Double)
    func getEmi() -> EmiEntity
}

class AddEmiVC: NSViewController, AddEmiLocationVCDelegate {    
    
    var delegate: DSPViewController?
    
    var coordinate = (long: Double(), lat: Double())
    
    @IBOutlet weak var idTextField: NSTextField!
    @IBOutlet weak var phoneTextField: NSTextField!
    @IBOutlet weak var statusButtonOutlet: NSPopUpButton!
    @IBOutlet weak var statusDetailsTextField: NSTextField!
    
    var editButtonPresed = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "addEmiLocationVCSegue" {
            if let viewController = segue.destinationController as? AddEmiLocationVC {
                viewController.delegate = self
            }
        }
    }

    @IBAction func addEmi(_ sender: NSButton) {
        let active: Bool = {
            guard self.statusButtonOutlet.title == "ACTIVE" else {
                return false
            }
            return true
        }()
        delegate!.addEmi(id: idTextField.stringValue, phone: phoneTextField.stringValue, active: active,
                         statusDetails: statusDetailsTextField.stringValue, longitude: coordinate.long, latitude: coordinate.lat)
    }
}
