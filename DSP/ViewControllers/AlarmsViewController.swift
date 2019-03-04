//
//  ViewController.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Cocoa

class AlarmsViewController: NSViewController, EventsManagerVCDelegate, LoginVCDelegate {
    
    var eventsManager = EventsManager()
    
    var accesGranted = false
    
    let dateFormater = DateFormatter()
    
    var accountTableSelectedRow = 0
    var priorityEventPartition = 0
    let numberSortDescriptor = NSSortDescriptor(key: "number", ascending: true)
    
    @IBOutlet weak var accountsTableView: NSTableView!
    @IBOutlet weak var accountDetailesTableView: NSTableView!
    @IBOutlet weak var eventsTableView: NSTableView!
    @IBOutlet weak var scheduleTableView: NSTableView!
    @IBOutlet weak var partitionsTableView: NSTableView!
    @IBOutlet weak var zonesTableView: NSTableView!
    @IBOutlet weak var emiTableView: NSTableView!
    @IBOutlet weak var observationsTableView: NSTableView!
    @IBOutlet weak var emiDetailsTableView: NSTableView!
    @IBOutlet weak var interventionsDetailsTableView: NSTableView!
    @IBOutlet weak var serviceHistoryTableView: NSTableView!
    @IBOutlet weak var ticketsTableView: NSTableView!

    @IBOutlet weak var consoleView: NSTableView!

    @IBOutlet weak var activateButtonOutlet: NSButton!
    @IBOutlet weak var eventAlertImage: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        login()
        tableViewsInit()
        
        dateFormater.dateStyle = .short
        dateFormater.timeStyle = .medium
    }
    
    @IBAction func logoutButton(_ sender: NSButton) {
        deactivate()
        accesGranted = false
        login()
    }
    
    @IBAction func activateButton(_ sender: NSButton) {
        guard !accesGranted else {
            if activateButtonOutlet.state.rawValue == 1 {
                activate()
            } else if activateButtonOutlet.state.rawValue == 0 {
                deactivate()
            }
            return
        }
    }
    
    func login() {
        let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
        let loginVC = mainStoryBoard.instantiateController(withIdentifier: "loginVC") as! LoginVC
        loginVC.delegate = self
        self.presentAsModalWindow(loginVC)
    }
    
    func exitApplication() {
        NSApp.terminate(self)
    }
    
    func activate() {
        activateButtonOutlet.title = "DEACTIVATE"
        eventsManager.delegate = self
        eventsManager.run(getEventsTimeInterval: 3.0)
    }
    func deactivate() {
        activateButtonOutlet.title = "ACTIVATE"
        eventsManager.stop()
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
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        partitionsTableView.delegate = self
        partitionsTableView.dataSource = self
        zonesTableView.delegate = self
        zonesTableView.dataSource = self
    }
    
    func reloadTableViewData() {
        accountsTableView.reloadData()
        accountDetailesTableView.reloadData()
        eventsTableView.reloadData()
        scheduleTableView.reloadData()
        scheduleTableView.reloadData()
        partitionsTableView.reloadData()
        zonesTableView.reloadData()
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let tableViewSelected = notification.object as! NSTableView
        if tableViewSelected == self.accountsTableView {
            accountTableSelectedRow = accountsTableView.selectedRow
            accountDetailesTableView.reloadData()
            eventsTableView.reloadData()
            scheduleTableView.reloadData()
            partitionsTableView.reloadData()
            zonesTableView.reloadData()
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if eventsManager.accountsEvents.count > 0 {
            let selectedAccount = eventsManager.accountsEvents[accountTableSelectedRow]
            if tableView == accountsTableView {
                return eventsManager.accountsEvents.count
            } else if tableView == eventsTableView {
                return selectedAccount.events.count
            } else if tableView == accountDetailesTableView {
                return 1
            } else if tableView == scheduleTableView {
                return 7
            } else if tableView == partitionsTableView {
                if let partitions = selectedAccount.accountDetailes?.partitions {
                    return partitions.count
                } else {return 0}
            } else if tableView == zonesTableView {
                if let partitions = selectedAccount.accountDetailes?.partitions {
                    let sortedPartitions = partitions.sortedArray(using: [numberSortDescriptor]) as! [PartitionEntity]
                    for partition in sortedPartitions {
                        if partition.number == priorityEventPartition {
                            if let zones = partition.zones {
                                return zones.count
                            }
                        }
                    }
                } else {return 0}
            }
        }
        return 0
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        func generateCell(identifier: String, value: String) -> NSTableCellView {
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: identifier), owner: self) as! NSTableCellView
            cell.textField?.stringValue = value
            return cell
        }
        
        func generateColoredCell(identifier: String, value: String, color: CGColor) -> NSTableCellView {
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: identifier), owner: self) as! NSTableCellView
            cell.wantsLayer = true
            cell.layer?.backgroundColor = color
            cell.textField?.textColor = NSColor.black
            cell.textField?.stringValue = value
            return cell
        }
        
        if eventsManager.accountsEvents.count > 0 {
            
            let accountsEvents = eventsManager.accountsEvents
        
            let selectedAccountEvents = accountsEvents[accountTableSelectedRow]
            let selectedAccountDetailes = accountsEvents[accountTableSelectedRow].accountDetailes!
            let priorityEvent = selectedAccountEvents.priorityEvent
            let priorityEventType = eventsManager.getEventType(event: priorityEvent!)
            let priorityEventColor = priorityEventType.color
            let eventPriority = priorityEvent!.priority
            
            priorityEventPartition = priorityEvent!.partition

            if tableView == self.accountsTableView {

                generateAlert(for: accountsEvents[row])
                let priorityEventDate = dateFormater.string(from: priorityEvent!.date as Date)
                let date = priorityEventDate.components(separatedBy: " ")
                
                if tableColumn?.identifier.rawValue == "accountTableViewAccountColumn" {
                    return generateColoredCell(identifier: "AccountTableAccountCell", value: accountsEvents[row].id, color: priorityEventColor)
                    
                }else if tableColumn?.identifier.rawValue == "accountTableViewTimeColumn" {
                    return generateColoredCell(identifier: "AccountTableTimeCell", value: date[1], color: priorityEventColor)
                    
                }else if tableColumn?.identifier.rawValue == "accountTableViewEventColumn" {
                    return generateColoredCell(identifier: "AccountTableEventCell", value: accountsEvents[row].priorityEvent!.name, color: priorityEventColor)
    
                }else if tableColumn?.identifier.rawValue == "accountTableViewObjectiveColumn" {
                    if let objectiveName = accountsEvents[row].accountDetailes!.objective {
                        return generateColoredCell(identifier: "AccountTableObjectiveCell", value: objectiveName, color: priorityEventColor)
                    } else {
                        return generateColoredCell(identifier: "AccountTableObjectiveCell", value: "UNREGISTERED ACCOUNT", color: priorityEventColor)
                    }
                }
                
            } else if tableView == self.eventsTableView {
                let event = selectedAccountEvents.events[row]
                let color = eventsManager.getEventType(event: event).color
                
                if tableColumn?.identifier.rawValue == "eventsTableDateColumn" {
                    return generateColoredCell(identifier: "eventsTableDateCell", value:  dateFormater.string(from: event.date as Date), color: color)
                    
                } else if tableColumn?.identifier.rawValue == "eventsTableEventNameColumn" {
                    return generateColoredCell(identifier: "eventsTableEventNameCell", value: event.name, color: color)
                    
                }else if tableColumn?.identifier.rawValue == "eventsTableCIDColumn" {
                    return generateColoredCell(identifier: "eventsTableCIDCell", value: event.cid, color: color)
                    
                }else if tableColumn?.identifier.rawValue == "eventsTablePartitionColumn" {
                    return generateColoredCell(identifier: "eventsTableCIDCell", value: String(event.partition), color: color)
                    
                }else if tableColumn?.identifier.rawValue == "eventsTableZoneUserColumn" {
                    return generateColoredCell(identifier: "eventsTableZoneUserCell", value: String(event.zoneOrUser), color: color)
                    
                }else if tableColumn?.identifier.rawValue == "eventsTableGroupColumn" {
                    return generateColoredCell(identifier: "eventsTableGroupCell", value: String(event.group), color: color)
                    
                }else if tableColumn?.identifier.rawValue == "eventsTableEventTypeColumn" {
                    return generateColoredCell(identifier: "eventsTableEventTypeCell", value: event.name, color: color)
                    
                }
            } else if tableView == self.accountDetailesTableView {
                
                if tableColumn?.identifier.rawValue == "accountDetailesAccount" {
                    return generateColoredCell(identifier: "accountDetailesAccountCell", value: selectedAccountDetailes.id!, color: priorityEventColor)
    
                } else if tableColumn?.identifier.rawValue == "accountDetailesType" {
                    return generateColoredCell(identifier: "accountDetailesTypeCell", value: selectedAccountDetailes.type!, color: priorityEventColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesObjective" {
                    return generateColoredCell(identifier: "accountDetailesObjectiveCell", value: selectedAccountDetailes.objective!, color: priorityEventColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesClient" {
                    return generateColoredCell(identifier: "accountDetailesClientCell", value: selectedAccountDetailes.client!, color: priorityEventColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesAdress" {
                    return generateColoredCell(identifier: "accountDetailesAdressCell", value: "\(selectedAccountDetailes.adress1! ) \(selectedAccountDetailes.adress2!)",
                        color: priorityEventColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesCity" {
                    return generateColoredCell(identifier: "accountDetailesCityCell", value: selectedAccountDetailes.city!, color: priorityEventColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesCounty" {
                    return generateColoredCell(identifier: "accountDetailesCountyCell", value: selectedAccountDetailes.county!, color: priorityEventColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesSales" {
                    return generateColoredCell(identifier: "accountDetailesSalesCell", value: selectedAccountDetailes.sales!, color: priorityEventColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesContract" {
                    return generateColoredCell(identifier: "accountDetailesContractCell", value: selectedAccountDetailes.contract!, color: priorityEventColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesTechnic" {
                    return generateColoredCell(identifier: "accountDetailesTechnicCell", value: selectedAccountDetailes.technic!, color: priorityEventColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesArmed" {
                    return generateColoredCell(identifier: "accountDetailesArmedCell", value: "Yes", color: priorityEventColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesSystem" {
                    return generateColoredCell(identifier: "accountDetailesSystemCell", value: selectedAccountDetailes.system!, color: priorityEventColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesComunicator" {
                    return generateColoredCell(identifier: "accountDetailesComunicatorCell", value: selectedAccountDetailes.comunicator!, color: priorityEventColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesTest" {
                    return generateColoredCell(identifier: "accountDetailesTestCell", value: selectedAccountDetailes.periodicTest!, color: priorityEventColor)
                    
                }
            } else if tableView == scheduleTableView {
                if eventPriority <= 6 {
                    let weekDays = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"]
                    if tableColumn?.identifier.rawValue == "dayColumn" {
                        return generateCell(identifier: "dayCell", value: weekDays[row])
                    }
                    if let schedule = selectedAccountDetailes.schedeule {
                        let dayTimes = [schedule.monday, schedule.tuesday, schedule.wednesday, schedule.thursday, schedule.friday, schedule.saturday, schedule.sunday]
                        if dayTimes[row]! != "" {
                            let startTime = dayTimes[row]!.components(separatedBy: " ")[0]
                            let endTime = dayTimes[row]!.components(separatedBy: " ")[1]
                            if tableColumn?.identifier.rawValue == "openColumn" {
                                return generateCell(identifier: "openCell", value: startTime)
                            } else if tableColumn?.identifier.rawValue == "closedColumn" {
                                return generateCell(identifier: "closedCell", value: endTime)
                            }
                        }
                    }
                }
            } else if tableView == partitionsTableView {
                if eventPriority <= 20 {
                    if let partitions = selectedAccountDetailes.partitions {
                        let sortedPartitions = partitions.sortedArray(using: [numberSortDescriptor]) as! [PartitionEntity]
                        let partition = sortedPartitions[row]
                        
                        if partition.number == priorityEvent!.partition && partition.number != 0 {
                            if tableColumn?.identifier.rawValue == "partitionsTableNumberColumn"{
                                return generateColoredCell(identifier: "partitionTableNumberCell", value: String(partition.number), color: priorityEventColor)
                            }
                            if tableColumn?.identifier.rawValue == "partitionTableNamesColumn"{
                                return generateColoredCell(identifier: "partitionTableNameCell", value: partition.name!, color: priorityEventColor)
                            }
                            if tableColumn?.identifier.rawValue == "partitionTableArmedColumn"{
                                return generateColoredCell(identifier: "partitionTableArmedCell", value: "", color: priorityEventColor)
                            }
                        } else {
                            if tableColumn?.identifier.rawValue == "partitionsTableNumberColumn"{
                                return generateCell(identifier: "partitionTableNumberCell", value: String(partition.number))
                            }
                            if tableColumn?.identifier.rawValue == "partitionTableNamesColumn"{
                                return generateCell(identifier: "partitionTableNameCell", value: partition.name!)
                            }
                            if tableColumn?.identifier.rawValue == "partitionTableArmedColumn"{
                                return generateCell(identifier: "partitionTableArmedCell", value: "")
                            }
                        }
                    }
                }
            } else if tableView == zonesTableView {
                if eventPriority <= 20 {
                    if let partitions = selectedAccountDetailes.partitions {
                        let sortedPartitions = partitions.sortedArray(using: [numberSortDescriptor]) as! [PartitionEntity]
                        var sortedZones: [ZoneEntity]?
                        for partition in sortedPartitions {
                            if partition.number == priorityEventPartition {
                                if let zones = partition.zones {
                                    sortedZones = (zones.sortedArray(using: [numberSortDescriptor]) as! [ZoneEntity])
                                    break
                                }
                            }
                        }
                        let zone = sortedZones![row]
                        
                        if zone.number == priorityEvent!.zoneOrUser && zone.number != 0 {
                            if tableColumn?.identifier.rawValue == "zonesTableNumberColumn"{
                                return generateColoredCell(identifier: "zonesTableNumberCell", value: String(zone.number), color: priorityEventColor)
                            }
                            if tableColumn?.identifier.rawValue == "zonesTableNamesColumn"{
                                return generateColoredCell(identifier: "zonesTableNameCell", value: zone.name!, color: priorityEventColor)
                            }
                        } else {
                            if tableColumn?.identifier.rawValue == "zonesTableNumberColumn"{
                                return generateCell(identifier: "zonesTableNumberCell", value: String(zone.number))
                            }
                            if tableColumn?.identifier.rawValue == "zonesTableNamesColumn"{
                                return generateCell(identifier: "zonesTableNameCell", value: zone.name!)
                            }
                        }
                    }
                }
            }
        }
        return NSTableCellView()
    }
}


