//
//  ViewController.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Cocoa

class AlarmsViewController: NSViewController, NSTableViewDataSource, ReciversManagerVCDelegate {
    var reciversManager: ReciversManager?
    var eventsManager: EventsManager?

    var accountTableSelectedRow = 0
    
    @IBOutlet weak var accountsTableView: NSTableView!
    @IBOutlet weak var accountDetailesTableView: NSTableView!
    @IBOutlet weak var eventsTableView: NSTableView!
    @IBOutlet weak var consoleView: NSTableView!

    @IBOutlet weak var eventImage: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventsManager = EventsManager()
        self.reciversManager = ReciversManager()
        tableViewsInit()
    }
    
    @IBAction func activate(_ sender: NSButton) {
        if sender.state.rawValue == 1 {
            sender.title = "DEACTIVATE                                                                         "
            if reciversManager != nil {
                reciversManager!.delegate = self
                reciversManager!.run(dipatchTimeInterval: 2.0)
            }
        } else if sender.state.rawValue == 0 {
            sender.title = "ACTIVATE                                                                           "
            reciversManager!.stop()
        }
    }
    
    func generateAlert(eventPriority: Int) {
        
    }
}

extension AlarmsViewController: NSTableViewDelegate {
    
    func getPriorityEvent(events: [Event]) -> Event {
        var sortedEvents = events.sorted(by: {$0.priority < $1.priority })
        return sortedEvents[0]
    }
    
    func tableViewsInit() {
        accountsTableView.dataSource = self
        accountsTableView.delegate = self
        accountDetailesTableView.dataSource = self
        accountDetailesTableView.delegate = self
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
    }
    
    func reloadTableViewData() {
        accountsTableView.reloadData()
        accountDetailesTableView.reloadData()
        eventsTableView.reloadData()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if reciversManager!.accountsEvents.count > 0 {
            if tableView == accountsTableView {
                return reciversManager!.accountsEvents.count
            } else if tableView == eventsTableView {
                return reciversManager!.accountsEvents[accountTableSelectedRow].events.count
            } else if tableView == accountDetailesTableView {
                return 1
            }
        }
        return 0
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let tableViewSelected = notification.object as! NSTableView
        if tableViewSelected == self.accountsTableView {
            accountTableSelectedRow = accountsTableView.selectedRow
            accountDetailesTableView.reloadData()
            eventsTableView.reloadData()
        }
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cell = NSTableCellView()
        
        if reciversManager!.accountsEvents.count > 0 {
            
            let accountsEvents = reciversManager!.accountsEvents
            let accountDetailes = reciversManager!.accountsDetailes
            let event = accountsEvents[accountTableSelectedRow].events[row]
            let cid = event.cid
            let group = event.group
            
            if tableView == self.accountsTableView {
                
                let priorityEvent = getPriorityEvent(events: accountsEvents[row].events)
                
                let id = accountsEvents[row].id
                let dateAndTime = priorityEvent.date.components(separatedBy: " ")
                let name = priorityEvent.name
                let objectiveName = accountDetailes[accountsEvents[row].id]!.name!
                
                
                if tableColumn?.identifier.rawValue == "accountTableViewAccountColumn" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "AccountTableAccountCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = id
                    cell.wantsLayer = true
                    cell.layer?.backgroundColor = NSColor.red.cgColor
                    return cell
                }else if tableColumn?.identifier.rawValue == "accountTableViewTimeColumn" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "AccountTableTimeCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = dateAndTime[1]
                    cell.wantsLayer = true
                    cell.layer?.backgroundColor = NSColor.red.cgColor
                    return cell
                }else if tableColumn?.identifier.rawValue == "accountTableViewEventColumn" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "AccountTableEventCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = name
                    cell.wantsLayer = true
                    cell.layer?.backgroundColor = NSColor.red.cgColor
                    return cell
                }else if tableColumn?.identifier.rawValue == "accountTableViewObjectiveColumn" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "AccountTableObjectiveCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = objectiveName
                    cell.wantsLayer = true
                    cell.layer?.backgroundColor = NSColor.red.cgColor
                    return cell
                }
            } else if tableView == self.eventsTableView {
                
                let dateAndTime = event.date.components(separatedBy: " ")
                let eventType = eventsManager?.getEventType(eventCode: Int(cid)!, eventGroup: group)
                let eventColor = eventType?.color
                
                if tableColumn?.identifier.rawValue == "eventsTableDateColumn" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "eventsTableDateCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = "\(dateAndTime[0]) \\ \(dateAndTime[1])"
                    cell.wantsLayer = true
                    cell.layer?.backgroundColor = eventColor
                    return cell
                } else if tableColumn?.identifier.rawValue == "eventsTableEventNameColumn" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "eventsTableEventNameCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = event.name
                    cell.wantsLayer = true
                    cell.layer?.backgroundColor = eventColor
                    return cell
                }else if tableColumn?.identifier.rawValue == "eventsTableCIDColumn" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "eventsTableCIDCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = cid
                    cell.wantsLayer = true
                    cell.layer?.backgroundColor = eventColor
                    return cell
                }else if tableColumn?.identifier.rawValue == "eventsTablePartitionColumn" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "eventsTablePartitionCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = event.partition
                    cell.wantsLayer = true
                    cell.layer?.backgroundColor = eventColor
                    return cell
                }else if tableColumn?.identifier.rawValue == "eventsTableZoneUserColumn" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "eventsTableZoneUserCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = event.zoneOrUser
                    cell.wantsLayer = true
                    cell.layer?.backgroundColor = eventColor
                    return cell
                }else if tableColumn?.identifier.rawValue == "eventsTableGroupColumn" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "eventsTableGroupCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = group
                    cell.wantsLayer = true
                    cell.layer?.backgroundColor = eventColor
                    return cell
                }else if tableColumn?.identifier.rawValue == "eventsTableEventTypeColumn" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "eventsTableEventTypeCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = event.type
                    cell.wantsLayer = true
                    cell.layer?.backgroundColor = eventColor
                    return cell
                }
            } else if tableView == self.accountDetailesTableView {
                
                let selectedAccount = accountDetailes[accountsEvents[accountTableSelectedRow].id]
                
                if tableColumn?.identifier.rawValue == "accountDetailesAccount" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "accountDetailesAccountCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = selectedAccount!.id!
                    cell.wantsLayer = true
                    cell.layer?.backgroundColor = NSColor.red.cgColor
                    return cell
                } else if tableColumn?.identifier.rawValue == "accountDetailesType" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "accountDetailesTypeCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = selectedAccount!.type!
                    cell.wantsLayer = true
                    cell.layer?.backgroundColor = NSColor.red.cgColor
                    return cell
                } else if tableColumn?.identifier.rawValue == "accountDetailesObjective" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "accountDetailesObjectiveCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = selectedAccount!.name!
                    cell.wantsLayer = true
                    cell.layer?.backgroundColor = NSColor.red.cgColor
                    return cell
                } else if tableColumn?.identifier.rawValue == "accountDetailesClient" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "accountDetailesClientCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = selectedAccount!.client!
                    cell.wantsLayer = true
                    cell.layer?.backgroundColor = NSColor.red.cgColor
                    return cell
                } else if tableColumn?.identifier.rawValue == "accountDetailesAdress" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "accountDetailesAdressCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = ("\(selectedAccount!.adress1! ) \(selectedAccount!.adress2!)")
                    cell.wantsLayer = true
                    cell.layer?.backgroundColor = NSColor.red.cgColor
                    return cell
                } else if tableColumn?.identifier.rawValue == "accountDetailesCity" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "accountDetailesCityCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = selectedAccount!.city!
                    cell.wantsLayer = true
                    cell.layer?.backgroundColor = NSColor.red.cgColor
                    return cell
                } else if tableColumn?.identifier.rawValue == "accountDetailesCounty" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "accountDetailesCountyCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = selectedAccount!.county!
                    cell.wantsLayer = true
                    cell.layer?.backgroundColor = NSColor.red.cgColor
                    return cell
                } else if tableColumn?.identifier.rawValue == "accountDetailesSales" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "accountDetailesSalesCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = selectedAccount!.sales!
                    cell.wantsLayer = true
                    cell.layer?.backgroundColor = NSColor.red.cgColor
                    return cell
                } else if tableColumn?.identifier.rawValue == "accountDetailesContract" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "accountDetailesContractCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = selectedAccount!.contract!
                    cell.wantsLayer = true
                    cell.layer?.backgroundColor = NSColor.red.cgColor
                    return cell
                } else if tableColumn?.identifier.rawValue == "accountDetailesTechnic" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "accountDetailesTechnicCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = selectedAccount!.technic!
                    cell.wantsLayer = true
                    cell.layer?.backgroundColor = NSColor.red.cgColor
                    return cell
                } else if tableColumn?.identifier.rawValue == "accountDetailesArmed" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "accountDetailesArmedCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = "Yes"
                    cell.wantsLayer = true
                    cell.layer?.backgroundColor = NSColor.red.cgColor
                    return cell
                } else if tableColumn?.identifier.rawValue == "accountDetailesReciver" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "accountDetailesReciverCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = selectedAccount!.reciver!
                    cell.wantsLayer = true
                    cell.layer?.backgroundColor = NSColor.red.cgColor
                    return cell
                } else if tableColumn?.identifier.rawValue == "accountDetailesSystem" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "accountDetailesSystemCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = selectedAccount!.system!
                    cell.wantsLayer = true
                    cell.layer?.backgroundColor = NSColor.red.cgColor
                    return cell
                } else if tableColumn?.identifier.rawValue == "accountDetailesComunicator" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "accountDetailesComunicatorCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = selectedAccount!.comunicator!
                    cell.wantsLayer = true
                    cell.layer?.backgroundColor = NSColor.red.cgColor
                    return cell
                } else if tableColumn?.identifier.rawValue == "accountDetailesTest" {
                    cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "accountDetailesTestCell"), owner: self) as! NSTableCellView
                    cell.textField?.stringValue = selectedAccount!.periodicTest!
                    cell.wantsLayer = true
                    cell.layer?.backgroundColor = NSColor.red.cgColor
                    return cell
                }
            }
        }
        return cell
    }
}


