//
//  ViewController.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Cocoa

class AlarmsViewController: NSViewController, NSTableViewDataSource {
    var runDispatchTimer: Timer?
    var reloadEventsTableTimer: Timer?
    var reciversManager = ReciversManager()
    var accountEvents = [AccountEvents]()
    
    var accountTableSelectedRow = 0
    
    @IBOutlet weak var accountsTableView: NSTableView!
    @IBOutlet weak var eventsTableView: NSTableView!
    @IBOutlet weak var consoleView: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewsInit()
        
    }
    
    @IBAction func activate(_ sender: NSButton) {
        if sender.state.rawValue == 1 {
            sender.title = "DEACTIVATE                                                                         "
            run(dipatchTimeInterval: 2.0, reloadEventsTableViewTimer: 0.30)
        } else if sender.state.rawValue == 0 {
            sender.title = "ACTIVATE                                                                           "
            stop()
        }
    }
    
    @objc func runDispatch() {
        let events = reciversManager.getEvents()
        if events.count > 0 {
            filterAccountEvents(events: events)
            reloadTableViewdata()
        }
    }
    
    @objc func reloadEventsTableView() {
        if accountsTableView.selectedRow > -1 {
            let accountTableSelectedNewRow = accountsTableView.selectedRow
            if accountTableSelectedNewRow != accountTableSelectedRow {
                accountTableSelectedRow = accountTableSelectedNewRow
                eventsTableView.reloadData()
            }
        }
    }
    
    func run(dipatchTimeInterval: Double, reloadEventsTableViewTimer: Double) {
        runDispatchTimer = Timer.scheduledTimer(timeInterval: dipatchTimeInterval , target: self, selector: #selector(runDispatch), userInfo: nil, repeats: true)
        reloadEventsTableTimer = Timer.scheduledTimer(timeInterval: reloadEventsTableViewTimer, target: self, selector: #selector(reloadEventsTableView), userInfo: nil, repeats: true)
    }
    func stop() {
        runDispatchTimer!.invalidate()
    }
    
    func filterAccountEvents(events: [AccountEvents]) {
        let newAccountEvents = events
        if accountEvents.count == 0 {
            accountEvents.append(contentsOf: newAccountEvents)
        } else {
            for accountIndex in 0..<accountEvents.count {
                var matchAccount = false
                for newAccount in newAccountEvents {
                    if accountEvents[accountIndex].id == newAccount.id {
                        accountEvents[accountIndex].events.append(contentsOf: newAccount.events)
                        matchAccount = true
                        break
                    }
                }
                if !matchAccount {
                    accountEvents.append(contentsOf: newAccountEvents)
                }
            }
        }
    }
    
}

extension AlarmsViewController: NSTableViewDelegate {
    
    func tableViewsInit() {
        accountsTableView.dataSource = self
        eventsTableView.dataSource = self
        accountsTableView.delegate = self
        eventsTableView.delegate = self
    }
    
    func reloadTableViewdata() {
        accountsTableView.reloadData()
        eventsTableView.reloadData()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if accountEvents.count > 0 {
            if tableView == accountsTableView {
                return accountEvents.count
            } else if tableView == eventsTableView {
                return accountEvents[accountTableSelectedRow].events.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cell = NSTableCellView()
        
        if accountEvents.count > 0 {

            if tableView == self.accountsTableView {
                
                if tableColumn?.identifier.rawValue == "accountTableViewAccountColumn" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "AccountTableAccountCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = accountEvents[row].id
                    return cell
                }else if tableColumn?.identifier.rawValue == "accountTableViewObjectiveColumn" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "AccountTableObjectiveCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = "SACUIU DRAGOS"
                    return cell
                }else if tableColumn?.identifier.rawValue == "accountTableViewClientColumn" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "AccountTableClientCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = "SWIFT PROGRAMMING"
                    return cell
                }
            } else if tableView == self.eventsTableView {
                print(accountTableSelectedRow)
                if tableColumn?.identifier.rawValue == "eventsTableDateColumn" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "eventsTableDateCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = accountEvents[accountTableSelectedRow].events[row].date
                    return cell
                } else if tableColumn?.identifier.rawValue == "eventsTableEventNameColumn" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "eventsTableEventNameCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = accountEvents[accountTableSelectedRow].events[row].eventName
                    return cell
                }else if tableColumn?.identifier.rawValue == "eventsTableCIDColumn" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "eventsTableCIDCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = accountEvents[accountTableSelectedRow].events[row].cid
                    return cell
                }else if tableColumn?.identifier.rawValue == "eventsTablePartitionColumn" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "eventsTablePartitionCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = accountEvents[accountTableSelectedRow].events[row].partition
                    return cell
                }else if tableColumn?.identifier.rawValue == "eventsTableZoneUserColumn" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "eventsTableZoneUserCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = accountEvents[accountTableSelectedRow].events[row].zoneOrUser
                    return cell
                }else if tableColumn?.identifier.rawValue == "eventsTableGroupColumn" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "eventsTableGroupCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = accountEvents[accountTableSelectedRow].events[row].group
                    return cell
                }else if tableColumn?.identifier.rawValue == "eventsTableEventTypeColumn" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "eventsTableEventTypeCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = accountEvents[accountTableSelectedRow].events[row].eventType
                    return cell
                }
            }
        }
        return cell
    }

}


