//
//  AddPartitionVC.swift
//  DSP
//
//  Created by Sacuiu Dragos on 13/02/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//

import Cocoa

protocol AddPartitionVCDelegate {
    func addPartition(number: Int, name: String)
    func getPartition() -> PartitionEntity
}

class AddPartitionVC: NSViewController {
    var delegate: AddPartitionVCDelegate?
    
    var editButtonPressed = false

    @IBOutlet weak var partitionName: NSTextField!
    @IBOutlet weak var partitionNumber: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if editButtonPressed {
            let partitionToEdit = delegate?.getPartition()
            partitionNumber.stringValue = String(partitionToEdit!.number)
            partitionName.stringValue = partitionToEdit!.name!
        }
    }
    
    @IBAction func addPartitionButton(_ sender: NSButton) {
        addPartition()
        clearFields()
    }
    
    func addPartition() {
        delegate?.addPartition(number: Int(partitionNumber.stringValue)!, name: partitionName.stringValue)
    }
    
    func clearFields() {
        partitionName.stringValue = ""
        partitionNumber.stringValue = ""
    }
}
