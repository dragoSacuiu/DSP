//
//  UsersVC.swift
//  DSP
//
//  Created by Sacuiu Dragos on 26/02/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//

import Cocoa

class UsersVC: NSViewController {

    private let storeData = StoreUsers()

    @IBOutlet weak var usersTableView: NSTableView!
    @IBOutlet weak var managersTableView: NSTableView!
    
    private var usersTableViewSelectedRow = 0
    private var managersTableViewSelectedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewsInit()
    }
    
    override func viewDidDisappear() {
        storeData.save()
    }
    
    @IBAction func removeUser(_ sender: NSButton) {
        guard usersTableView.selectedRow == -1 else {
            storeData.removeUser(selectedUserIndex: usersTableViewSelectedRow)
            usersTableView.reloadData()
            return
        }
    }
    @IBAction func removeManager(_ sender: NSButton) {
        guard managersTableView.selectedRow == -1 else {
            storeData.removeManager(selectedManagerIndex: managersTableViewSelectedRow)
            managersTableView.reloadData()
            return
        }
    }
}

extension UsersVC: AddUserVCDelegate, AddManagerVCDelegate {
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "addUserSegue" {
            if let viewController = segue.destinationController as? AddUserVC {
                print("user")
                viewController.delegate = self
            }
        } else if segue.identifier == "editUserSegue" {
            if let viewController = segue.destinationController as? AddUserVC {
                viewController.delegate = self
                viewController.editButtonPressed = true
            }
        } else if segue.identifier == "addManagerSegue" {
            if let viewController = segue.destinationController as? AddManagerVC {
                viewController.delegate = self
            }
        } else if segue.identifier == "editManagerSegue" {
            if let viewController = segue.destinationController as? AddManagerVC {
                viewController.delegate = self
                viewController.editButtonPressed = true
            }
        }
    }
    
    func addUser(name: String, password: String) {
        storeData.storeUser(name: name, password: password)
        usersTableView.reloadData()
    }
    func getUser() -> UserEntity {
        return storeData.getUser(selectedUserIndex: usersTableViewSelectedRow)
    }
    
    func addManager(name: String, email: String) {
        storeData.storeManager(name: name, email: email)
        managersTableView.reloadData()
    }
    func getManager() -> ManagerEntity {
        return storeData.getManager(selectedManagerIndex: managersTableViewSelectedRow)
    }
    
}

extension UsersVC: NSTableViewDelegate, NSTableViewDataSource {
    func tableViewsInit() {
        usersTableView.delegate = self
        usersTableView.dataSource = self
        managersTableView.delegate = self
        managersTableView.dataSource = self
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let tableViewSelected = notification.object as! NSTableView
        if tableViewSelected == usersTableView {
            if tableViewSelected.selectedRow > -1 {
                usersTableViewSelectedRow = tableViewSelected.selectedRow
            }
        } else if tableViewSelected == managersTableView {
            if tableViewSelected.selectedRow > -1 {
                managersTableViewSelectedRow = tableViewSelected.selectedRow
            }
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == usersTableView {
            return storeData.getUsers().count
        } else if tableView == managersTableView {
            return storeData.getManagers().count
        }
        return 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        func generateCell(identifier: String, value: String) -> NSTableCellView{
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: identifier), owner: self) as! NSTableCellView
            cell.textField?.stringValue = value
            return cell
        }
        
        if tableView == usersTableView {
            let users = storeData.getUsers()
            let user = users[row]
            if tableColumn?.identifier.rawValue == "usersColumn" {
                return generateCell(identifier: "usersCell", value: user.name!)
            }
        } else if tableView == managersTableView {
            let managers = storeData.getManagers()
            let manager = managers[row]
            if tableColumn?.identifier.rawValue == "managersNameColumn" {
                return generateCell(identifier: "managersNameCell", value: manager.name!)
            } else if tableColumn?.identifier.rawValue == "managersEmailColumn" {
                return generateCell(identifier: "managersEmailCell", value: manager.email!)
            }
        }
        
        return NSTableCellView()
    }
}
