//
//  ServiceModeAccountsVC.swift
//  DSP
//
//  Created by Sacuiu Dragos on 14/03/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//

import Cocoa

protocol ServiceModeVCDelegate {
    func getServiceModeAccounts() -> [AccountEvents]
    func removeFromServiceMode(index: Int)
}

class ServiceModeAccountsVC: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    var delegate: DSPViewController?
    private var serviceModeAccounts: [AccountEvents]?
    
    private let dateFormater = DateFormatter()
    
    @IBOutlet weak var serviceModeTableView: NSTableView!
    private var selectedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormater.dateStyle = .short
        dateFormater.timeStyle = .short
        
        serviceModeAccounts = delegate!.getServiceModeAccounts()
        
        serviceModeTableView.delegate = self
        serviceModeTableView.dataSource = self
    }
    
    @IBAction func removeFromServiceModeButton(_ sender: NSButton) {
        delegate?.removeFromServiceMode(index: selectedRow)
        serviceModeAccounts = delegate?.getServiceModeAccounts()
        serviceModeTableView.reloadData()
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if let selectedTable = notification.object as? NSTableView {
            if selectedTable.selectedRow != -1 {
                if selectedTable == serviceModeTableView {
                    selectedRow = selectedTable.selectedRow
                }
            }
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == serviceModeTableView {
            if let accounts = serviceModeAccounts {
                return accounts.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableView == serviceModeTableView {
            if tableColumn?.identifier.rawValue == "idColumn" {
                let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "idCell"), owner: self) as! NSTableCellView
                cell.textField?.stringValue = serviceModeAccounts![row].id
                return cell
            } else if tableColumn?.identifier.rawValue == "dateColumn" {
                let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "dateCell"), owner: self) as! NSTableCellView
                cell.textField?.stringValue = dateFormater.string(from: Date())
                return cell
            } else if tableColumn?.identifier.rawValue == "userColumn" {
                let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "userCell"), owner: self) as! NSTableCellView
                cell.textField?.stringValue = UsersManager.activeUser
                return cell
            } else if tableColumn?.identifier.rawValue == "objectiveColumn" {
                let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "objectiveCell"), owner: self) as! NSTableCellView
                cell.textField?.stringValue = serviceModeAccounts![row].details!.objective!
                return cell
            }
        }
        return NSTableCellView()
    }
    
}
