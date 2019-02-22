//
//  ViewController.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Cocoa

class AlarmsViewController: NSViewController, EventsManagerVCDelegate {
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
            eventsManager!.run(getEventsTimeInterval: 3.0)
        } else if sender.state.rawValue == 0 {
            sender.title = "ACTIVATE                                                                           "
            eventsManager!.stop()
        }
    }
    
    func generateAlert(for accountAvents: AccountEvents) {
        if !accountAvents.generatedAlarm {
            eventAlertImage.image = accountAvents.priorityEventType!.image
            NSSound(named: "Glass")?.play()
            if accountAvents.priorityEvent!.priority < 7 {
                let narator = NSSpeechSynthesizer()
                narator.startSpeaking(accountAvents.priorityEvent!.name)
            }
            accountAvents.generatedAlarm = true
        }
    }
}

extension AlarmsViewController: NSTableViewDelegate, NSTableViewDataSource {
    
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
            
            let selectedAccountEventType = accountsEvents[accountTableSelectedRow].priorityEventType!
            let selectedAccountEvent = accountsEvents[accountTableSelectedRow].events[row]
            let selectedAccountEventTypeColor = eventsManager!.getEventType(event: selectedAccountEvent).color
            let selectedAccountDetailes = accountsEvents[accountTableSelectedRow].accountDetailes!
            
            
            
            if tableView == self.accountsTableView {

                generateAlert(for: accountsEvents[row])
                
                let priorityEventDateAndTime = accountsEvents[row].priorityEvent!.date.components(separatedBy: " ")
                let priorityEventTypeColor = accountsEvents[row].priorityEventType!.color
                
                if tableColumn?.identifier.rawValue == "accountTableViewAccountColumn" {
                    return generateCell(identifier: "AccountTableAccountCell", value: accountsEvents[row].id, color: priorityEventTypeColor)
                    
                }else if tableColumn?.identifier.rawValue == "accountTableViewTimeColumn" {
                    return generateCell(identifier: "AccountTableTimeCell", value: priorityEventDateAndTime[1], color: priorityEventTypeColor)
                    
                }else if tableColumn?.identifier.rawValue == "accountTableViewEventColumn" {
                    return generateCell(identifier: "AccountTableEventCell", value: accountsEvents[row].priorityEvent!.name, color: priorityEventTypeColor)
    
                }else if tableColumn?.identifier.rawValue == "accountTableViewObjectiveColumn" {
                    if let objectiveName = accountsEvents[row].accountDetailes!.objective {
                        return generateCell(identifier: "AccountTableObjectiveCell", value: objectiveName, color: priorityEventTypeColor)
                    } else {
                        return generateCell(identifier: "AccountTableObjectiveCell", value: "UNREGISTERED ACCOUNT", color: priorityEventTypeColor)
                    }
                }
                
            } else if tableView == self.eventsTableView {
                
                if tableColumn?.identifier.rawValue == "eventsTableDateColumn" {
                    return generateCell(identifier: "eventsTableDateCell", value: selectedAccountEvent.date, color: selectedAccountEventTypeColor)
                    
                } else if tableColumn?.identifier.rawValue == "eventsTableEventNameColumn" {
                    return generateCell(identifier: "eventsTableEventNameCell", value: selectedAccountEvent.name, color: selectedAccountEventTypeColor)
                    
                }else if tableColumn?.identifier.rawValue == "eventsTableCIDColumn" {
                    return generateCell(identifier: "eventsTableCIDCell", value: selectedAccountEvent.cid, color: selectedAccountEventTypeColor)
                    
                }else if tableColumn?.identifier.rawValue == "eventsTablePartitionColumn" {
                    return generateCell(identifier: "eventsTableCIDCell", value: selectedAccountEvent.partition, color: selectedAccountEventTypeColor)
                    
                }else if tableColumn?.identifier.rawValue == "eventsTableZoneUserColumn" {
                    return generateCell(identifier: "eventsTableZoneUserCell", value: selectedAccountEvent.zoneOrUser, color: selectedAccountEventTypeColor)
                    
                }else if tableColumn?.identifier.rawValue == "eventsTableGroupColumn" {
                    return generateCell(identifier: "eventsTableGroupCell", value: selectedAccountEvent.group, color: selectedAccountEventTypeColor)
                    
                }else if tableColumn?.identifier.rawValue == "eventsTableEventTypeColumn" {
                    return generateCell(identifier: "eventsTableEventTypeCell", value: selectedAccountEventType.name, color: selectedAccountEventTypeColor)
                    
                }
            } else if tableView == self.accountDetailesTableView {
                
                let priorityEventTypeColor = accountsEvents[row].priorityEventType!.color
                
                if tableColumn?.identifier.rawValue == "accountDetailesAccount" {
                    return generateCell(identifier: "accountDetailesAccountCell", value: selectedAccountDetailes.id!, color: priorityEventTypeColor)
    
                } else if tableColumn?.identifier.rawValue == "accountDetailesType" {
                    return generateCell(identifier: "accountDetailesTypeCell", value: selectedAccountDetailes.type!, color: priorityEventTypeColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesObjective" {
                    return generateCell(identifier: "accountDetailesObjectiveCell", value: selectedAccountDetailes.objective!, color: priorityEventTypeColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesClient" {
                    return generateCell(identifier: "accountDetailesClientCell", value: selectedAccountDetailes.client!, color: priorityEventTypeColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesAdress" {
                    return generateCell(identifier: "accountDetailesAdressCell", value: "\(selectedAccountDetailes.adress1! ) \(selectedAccountDetailes.adress2!)",
                        color: priorityEventTypeColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesCity" {
                    return generateCell(identifier: "accountDetailesCityCell", value: selectedAccountDetailes.city!, color: priorityEventTypeColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesCounty" {
                    return generateCell(identifier: "accountDetailesCountyCell", value: selectedAccountDetailes.county!, color: priorityEventTypeColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesSales" {
                    return generateCell(identifier: "accountDetailesSalesCell", value: selectedAccountDetailes.sales!, color: priorityEventTypeColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesContract" {
                    return generateCell(identifier: "accountDetailesContractCell", value: selectedAccountDetailes.contract!, color: priorityEventTypeColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesTechnic" {
                    return generateCell(identifier: "accountDetailesTechnicCell", value: selectedAccountDetailes.technic!, color: priorityEventTypeColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesArmed" {
                    return generateCell(identifier: "accountDetailesArmedCell", value: "Yes", color: priorityEventTypeColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesSystem" {
                    return generateCell(identifier: "accountDetailesSystemCell", value: selectedAccountDetailes.system!, color: priorityEventTypeColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesComunicator" {
                    return generateCell(identifier: "accountDetailesComunicatorCell", value: selectedAccountDetailes.comunicator!, color: priorityEventTypeColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesTest" {
                    return generateCell(identifier: "accountDetailesTestCell", value: selectedAccountDetailes.periodicTest!, color: priorityEventTypeColor)
                    
                }
            }
        }
        return cell
    }
}


