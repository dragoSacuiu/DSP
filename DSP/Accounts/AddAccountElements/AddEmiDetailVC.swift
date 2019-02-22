//
//  AddEmiDetailVC.swift
//  DSP
//
//  Created by Sacuiu Dragos on 13/02/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//

import Cocoa

protocol AddEmiDetailVCProtocol {
    func addEmiDetail(content: String)
    func getEmiDetail(content: String)
}

class AddEmiDetailVC: NSViewController {
    
    @IBOutlet weak var detail: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addDetailButton(_ sender: NSButton) {
        
    }
    
}
