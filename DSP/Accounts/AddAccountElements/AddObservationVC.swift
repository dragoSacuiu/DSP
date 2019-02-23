//
//  AddObservationVC.swift
//  DSP
//
//  Created by Sacuiu Dragos on 13/02/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//

import Cocoa

protocol AddObservationVCDelegate {
    func addObservation(observation: String)
    func getObservation() -> String
}

class AddObservationVC: NSViewController {
    var delegate: AddObservationVCDelegate?
    
    @IBOutlet weak var observationTextField: NSTextField!
    
    var editButtonPressed = false

    override func viewDidLoad() {
        super.viewDidLoad()
        if editButtonPressed {
            observationTextField.stringValue = delegate!.getObservation()
        }
    }
    
    @IBAction func addObservationButton(_ sender: NSButton) {
        delegate?.addObservation(observation: observationTextField.stringValue)
    }
    
}
