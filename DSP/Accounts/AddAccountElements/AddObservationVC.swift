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
    func getObservation() -> ObservationsEntity
    func reloadObservationsTableView()
}

class AddObservationVC: NSViewController {
    var delegate: AddObservationVCDelegate?
    
    @IBOutlet weak var addObservationButtonOutlet: NSButton!
    @IBOutlet weak var observationTextField: NSTextField!
    
    var editButtonPressed = false

    override func viewDidLoad() {
        super.viewDidLoad()
        if editButtonPressed {
            addObservationButtonOutlet.title = "SAVE"
            observationTextField.stringValue = delegate!.getObservation().observation!
        }
    }
    override func viewDidAppear() {
        view.window!.styleMask.remove(.resizable)
    }
    
    @IBAction func addObservationButton(_ sender: NSButton) {
        if editButtonPressed {
            delegate?.getObservation().observation! = observationTextField.stringValue
        } else {
            delegate?.addObservation(observation: observationTextField.stringValue)
            observationTextField.stringValue = ""
        }
        delegate?.reloadObservationsTableView()
    }
    
}
