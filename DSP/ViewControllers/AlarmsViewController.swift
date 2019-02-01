//
//  ViewController.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Cocoa

class AlarmsViewController: NSViewController, NSTableViewDataSource, EventsManagerVCDelegate {
    var eventsManager: EventsManager?

    var accountTableSelectedRow = 0
    
    @IBOutlet weak var accountsTableView: NSTableView!
    @IBOutlet weak var accountDetailesTableView: NSTableView!
    @IBOutlet weak var eventsTableView: NSTableView!
    @IBOutlet weak var consoleView: NSTableView!

    @IBOutlet weak var eventAlertImage: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventsManager = EventsManager()
        tableViewsInit()
    }
    
    @IBAction func activate(_ sender: NSButton) {
        if sender.state.rawValue == 1 {
            sender.title = "DEACTIVATE                                                                         "
            eventsManager!.delegate = self
            eventsManager!.run(getEventsTimeInterval: 2.0)
        } else if sender.state.rawValue == 0 {
            sender.title = "ACTIVATE                                                                           "
            eventsManager!.stop()
        }
    }
    
}

extension AlarmsViewController: NSTableViewDelegate {
    
    func generateAlert(for eventType: EventType, event: Event) {
        eventAlertImage.image = eventType.image
        NSSound(named: "Glass")?.play()
        let narator = NSSpeechSynthesizer()
        narator.startSpeaking(event.name)
    }
    
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
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let tableViewSelected = notification.object as! NSTableView
        if tableViewSelected == self.accountsTableView {
            accountTableSelectedRow = accountsTableView.selectedRow
            accountDetailesTableView.reloadData()
            eventsTableView.reloadData()
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if eventsManager!.accountsEvents.count > 0 {
            if tableView == accountsTableView {
                return eventsManager!.accountsEvents.count
            } else if tableView == eventsTableView {
                return eventsManager!.accountsEvents[accountTableSelectedRow].events.count
            } else if tableView == accountDetailesTableView {
                return 1
            }
        }
        return 0
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cell = NSTableCellView()
        
        func generateCell(identifier: String, value: String, color: CGColor) -> NSTableCellView {
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: identifier), owner: self) as! NSTableCellView
            cell.wantsLayer = true
            cell.layer?.backgroundColor = color
            cell.textField?.textColor = NSColor.black
            cell.textField?.stringValue = value
            return cell
        }
        
        if eventsManager!.accountsEvents.count > 0 {
            
            let accountsEvents = eventsManager!.accountsEvents
            let accountDetailes = eventsManager!.accountsDetailes
            
            let selectedAccountEvent = accountsEvents[accountTableSelectedRow].events[row]
            let selectedAccountEventType = eventsManager!.getEventType(eventPriority: selectedAccountEvent.priority, eventGroup: selectedAccountEvent.group)
            let selectedAccountDetailes = accountDetailes[accountTableSelectedRow]
            
            if tableView == self.accountsTableView {
                
                let priorityEvent = getPriorityEvent(events: accountsEvents[row].events)
                let priorityEventType = eventsManager!.getEventType(eventPriority: priorityEvent.priority, eventGroup: priorityEvent.group)
                
                generateAlert(for: priorityEventType, event: priorityEvent)
                
                let priorityEventDateAndTime = priorityEvent.date.components(separatedBy: " ")
                
                if tableColumn?.identifier.rawValue == "accountTableViewAccountColumn" {
                    return generateCell(identifier: "AccountTableAccountCell", value: accountsEvents[row].id, color: priorityEventType.color)
                    
                }else if tableColumn?.identifier.rawValue == "accountTableViewTimeColumn" {
                    return generateCell(identifier: "AccountTableTimeCell", value: priorityEventDateAndTime[1], color: priorityEventType.color)
                    
                }else if tableColumn?.identifier.rawValue == "accountTableViewEventColumn" {
                    return generateCell(identifier: "AccountTableEventCell", value: priorityEvent.name, color: priorityEventType.color)
    
                }else if tableColumn?.identifier.rawValue == "accountTableViewObjectiveColumn" {
                    if let objectiveName = accountDetailes[row].name {
                        return generateCell(identifier: "AccountTableObjectiveCell", value: objectiveName, color: priorityEventType.color)
                    } else {
                        return generateCell(identifier: "AccountTableObjectiveCell", value: "UNREGISTERED ACCOUNT", color: priorityEventType.color)
                    }
                }
                
            } else if tableView == self.eventsTableView {
                
                if tableColumn?.identifier.rawValue == "eventsTableDateColumn" {
                    return generateCell(identifier: "eventsTableDateCell", value: selectedAccountEvent.date, color: selectedAccountEventType.color)
                    
                } else if tableColumn?.identifier.rawValue == "eventsTableEventNameColumn" {
                    return generateCell(identifier: "eventsTableEventNameCell", value: selectedAccountEvent.name, color: selectedAccountEventType.color)
                    
                }else if tableColumn?.identifier.rawValue == "eventsTableCIDColumn" {
                    return generateCell(identifier: "eventsTableCIDCell", value: selectedAccountEvent.cid, color: selectedAccountEventType.color)
                    
                }else if tableColumn?.identifier.rawValue == "eventsTablePartitionColumn" {
                    return generateCell(identifier: "eventsTableCIDCell", value: selectedAccountEvent.partition, color: selectedAccountEventType.color)
                    
                }else if tableColumn?.identifier.rawValue == "eventsTableZoneUserColumn" {
                    return generateCell(identifier: "eventsTableZoneUserCell", value: selectedAccountEvent.zoneOrUser, color: selectedAccountEventType.color)
                    
                }else if tableColumn?.identifier.rawValue == "eventsTableGroupColumn" {
                    return generateCell(identifier: "eventsTableGroupCell", value: selectedAccountEvent.group, color: selectedAccountEventType.color)
                    
                }else if tableColumn?.identifier.rawValue == "eventsTableEventTypeColumn" {
                    return generateCell(identifier: "eventsTableEventTypeCell", value: selectedAccountEventType.name, color: selectedAccountEventType.color)
                    
                }
            } else if tableView == self.accountDetailesTableView {
                
                let priorityEvent = getPriorityEvent(events: accountsEvents[accountTableSelectedRow].events)
                let priorityEventType = eventsManager!.getEventType(eventPriority: priorityEvent.priority, eventGroup: priorityEvent.group)
                
                if tableColumn?.identifier.rawValue == "accountDetailesAccount" {
                    return generateCell(identifier: "accountDetailesAccountCell", value: selectedAccountDetailes.id!, color: priorityEventType.color)
    
                } else if tableColumn?.identifier.rawValue == "accountDetailesType" {
                    return generateCell(identifier: "accountDetailesTypeCell", value: selectedAccountDetailes.type!, color:  priorityEventType.color)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesObjective" {
                    return generateCell(identifier: "accountDetailesObjectiveCell", value: selectedAccountDetailes.name!, color:  priorityEventType.color)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesClient" {
                    return generateCell(identifier: "accountDetailesClientCell", value: selectedAccountDetailes.client!, color:  priorityEventType.color)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesAdress" {
                    return generateCell(identifier: "accountDetailesAdressCell", value: "\(selectedAccountDetailes.adress1! ) \(selectedAccountDetailes.adress2!)", color:  priorityEventType.color)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesCity" {
                    return generateCell(identifier: "accountDetailesCityCell", value: selectedAccountDetailes.city!, color:  priorityEventType.color)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesCounty" {
                    return generateCell(identifier: "accountDetailesCountyCell", value: selectedAccountDetailes.county!, color:  priorityEventType.color)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesSales" {
                    return generateCell(identifier: "accountDetailesSalesCell", value: selectedAccountDetailes.sales!, color:  priorityEventType.color)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesContract" {
                    return generateCell(identifier: "accountDetailesContractCell", value: selectedAccountDetailes.contract!, color:  priorityEventType.color)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesTechnic" {
                    return generateCell(identifier: "accountDetailesTechnicCell", value: selectedAccountDetailes.technic!, color:  priorityEventType.color)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesArmed" {
                    return generateCell(identifier: "accountDetailesArmedCell", value: "Yes", color:  priorityEventType.color)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesReciver" {
                    return generateCell(identifier: "accountDetailesReciverCell", value: selectedAccountDetailes.reciver!, color:  priorityEventType.color)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesSystem" {
                    return generateCell(identifier: "accountDetailesSystemCell", value: selectedAccountDetailes.system!, color:  priorityEventType.color)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesComunicator" {
                    return generateCell(identifier: "accountDetailesComunicatorCell", value: selectedAccountDetailes.comunicator!, color:  priorityEventType.color)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesTest" {
                    return generateCell(identifier: "accountDetailesTestCell", value: selectedAccountDetailes.periodicTest!, color:  priorityEventType.color)
                    
                }
            }
        }
        return cell
    }
}


