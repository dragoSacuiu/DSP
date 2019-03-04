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
    func reloadPartitionsTableView()
}

class AddPartitionVC: NSViewController {
    var delegate: AddPartitionVCDelegate?
    
    var editButtonPressed = false
    var partition: PartitionEntity?

    @IBOutlet weak var partitionNameTextField: NSTextField!
    @IBOutlet weak var partitionNumberTextField: NSTextField!
    @IBOutlet weak var addButtonOutlet: NSButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if editButtonPressed {
            addButtonOutlet.title = "SAVE"
            partition = delegate?.getPartition()
            partitionNumberTextField.stringValue = String(partition!.number)
            partitionNameTextField.stringValue = partition!.name!
        }
    }
    override func viewDidAppear() {
        view.window!.styleMask.remove(.resizable)
    }
    
    @IBAction func addPartitionButton(_ sender: NSButton) {
        if editButtonPressed {
            partition?.number = Int16(partitionNumberTextField.stringValue)!
            partition?.name = partitionNameTextField.stringValue
        } else {
            delegate?.addPartition(number: Int(partitionNumberTextField.stringValue)!, name: partitionNameTextField.stringValue)
            clearFields()
        }
        delegate?.reloadPartitionsTableView()
    }
    
    func clearFields() {
        partitionNameTextField.stringValue = ""
        partitionNumberTextField.stringValue = ""
    }
}
