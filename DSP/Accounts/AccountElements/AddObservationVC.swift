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
    var observation: ObservationsEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if editButtonPressed {
            observation = delegate?.getObservation()
            addObservationButtonOutlet.title = "SAVE"
            if observation != nil {
                observationTextField.stringValue = observation!.observation!
            }
        }
    }
    override func viewDidAppear() {
        view.window!.styleMask.remove(.resizable)
    }
    
    @IBAction func addObservationButton(_ sender: NSButton) {
        if editButtonPressed {
            if observation != nil {
                observation!.observation! = observationTextField.stringValue
                observation!.date = NSDate()
                observation?.user = UsersManager.activeUser
            }
        } else {
            delegate?.addObservation(observation: observationTextField.stringValue)
            observationTextField.stringValue = ""
        }
        delegate?.reloadObservationsTableView()
    }
    
}
