//
//  AddEmiVC.swift
//  DSP
//
//  Created by Sacuiu Dragos on 11/03/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//

import Cocoa

protocol AddEmiVCDelegate {
    func addEmi(id: String, phone: String, status: String, statusDetails: String, longitude: Double, latitude: Double)
    func getEmi() -> EmiEntity
    func saveEmi()
}

class AddEmiVC: NSViewController, AddEmiLocationVCDelegate {    
    let dspAlert = DspAlert()
    var delegate: DSPViewController?
    
    var coordinate = (long: Double(), lat: Double())
    
    @IBOutlet weak var idTextField: NSTextField!
    @IBOutlet weak var phoneTextField: NSTextField!
    @IBOutlet weak var statusButtonOutlet: NSPopUpButton!
    @IBOutlet weak var statusDetailsTextField: NSTextField!
    
    @IBOutlet weak var addEmiButtonOutlet: NSButton!
    var editButtonPresed = false

    var emi: EmiEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addEmiButtonOutlet.title = "SAVE"
        if editButtonPresed {
            emi = delegate?.getEmi()
            if emi != nil {
                idTextField.stringValue = emi!.id!
                phoneTextField.stringValue = emi!.phone!
                statusButtonOutlet.title = emi!.status!
                statusDetailsTextField.stringValue = emi!.statusDetails!
            }
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "addEmiLocationVCSegue" {
            if let viewController = segue.destinationController as? AddEmiLocationVC {
                viewController.delegate = self
            }
        }
    }

    @IBAction func addEmi(_ sender: NSButton) {
        if editButtonPresed {
            guard emi != nil else { dspAlert.showAlert(message: "Cannot edit EMI"); return }
            emi?.id = idTextField.stringValue
            emi?.phone = phoneTextField.stringValue
            emi?.status = statusButtonOutlet.titleOfSelectedItem
            if emi?.status == "AVAILABLE" {
                emi?.statusDetails = "WAITING"
            }
            emi?.statusDetails = statusDetailsTextField.stringValue
            emi?.latitude = coordinate.lat
            emi?.longitude = coordinate.long
            delegate?.saveEmi()
        } else {
            if statusButtonOutlet.titleOfSelectedItem == "AVAILABLE" {
                statusDetailsTextField.stringValue = "WAITING"
            }
            delegate!.addEmi(id: idTextField.stringValue, phone: phoneTextField.stringValue, status: statusButtonOutlet.titleOfSelectedItem!,
                             statusDetails: statusDetailsTextField.stringValue, longitude: coordinate.long, latitude: coordinate.lat)
        }
    }
    
}
