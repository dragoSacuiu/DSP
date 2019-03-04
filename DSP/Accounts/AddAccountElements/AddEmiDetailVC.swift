//
//  AddEmiDetailVC.swift
//  DSP
//
//  Created by Sacuiu Dragos on 13/02/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//

import Cocoa

protocol AddEmiDetailVCDelegate {
    func addEmiDetail(detail: String)
    func getEmiDetail() -> EmiDetailesEntity
    func reloadEmiDetailsTableView()
}

class AddEmiDetailVC: NSViewController {
    
    var delegate: AddEmiDetailVCDelegate?
    
    
    @IBOutlet weak var addDetailButtonOutlet: NSButton!
    @IBOutlet weak var detailTextField: NSTextField!
    
    var emiDetail: EmiDetailesEntity?
    var editButtonPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if editButtonPressed {
            addDetailButtonOutlet.title = "SAVE"
            emiDetail = delegate?.getEmiDetail()
            detailTextField.stringValue = emiDetail!.detailes!
        }
    }
    override func viewDidAppear() {
        view.window!.styleMask.remove(.resizable)
    }
    
    @IBAction func addDetailButton(_ sender: NSButton) {
        if editButtonPressed {
            emiDetail?.detailes = detailTextField.stringValue
        } else {
            delegate?.addEmiDetail(detail: detailTextField.stringValue)
            detailTextField.stringValue = ""
        }
        delegate?.reloadEmiDetailsTableView()
    }
}
