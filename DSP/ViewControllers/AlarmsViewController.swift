//
//  ViewController.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Cocoa

class AlarmsViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    var accountEvents = [AccountEvents]()
    let reciversManager = ReciversManager()
    
    @IBOutlet weak var accountsTableView: NSTableView!
    
    @IBOutlet weak var eventsTableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        runTimer(TimeInterval: 3.0, Target: self, Selector: #selector(self.runDispatch) , Repeat: true)
    }
    
    @objc func runDispatch() {
        accountEvents.append(contentsOf: reciversManager.getEvents())
        
    }
    
    func tableViewsInit() {
        accountsTableView.delegate = self
        accountsTableView.dataSource = self
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == accountsTableView {
            return accountEvents.count
        } else if tableView == eventsTableView {
            
        }
        return 0
    }
    
}

extension AlarmsViewController {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
    }
    
}
