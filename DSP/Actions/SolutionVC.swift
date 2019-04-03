//
//  CancelEmiVC.swift
//  DSP
//
//  Created by Sacuiu Dragos on 19/03/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//

import Cocoa

protocol SolutionVCDelegate {
    func setActionSolution(solution: String, details: String)
}

class SolutionVC: NSViewController {
    
    var delegate: DSPViewController?
    
    private let dspAlert = DspAlert()
    
    @IBOutlet weak var selectSolutionButton: NSPopUpButton!
    @IBOutlet weak var solutionDetailsTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func solvedButton(_ sender: NSButton) {
        if selectSolutionButton.titleOfSelectedItem != "SELECT SOLUTION"{
            delegate?.setActionSolution(solution: selectSolutionButton.titleOfSelectedItem!, details: solutionDetailsTextField.stringValue)
            self.view.window?.close()
        } else {
            dspAlert.showAlert(message: "Please add solution and solution details!")
        }
    }
    
}
