//
//  ViewController.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Cocoa
import MapKit
import CoreLocation

class DSPViewController: NSViewController, MKMapViewDelegate, DspVCDelegate, LoginVCDelegate, NSSpeechSynthesizerDelegate {
    var narator = NSSpeechSynthesizer()
    var dspManager = DspManager()
    
    var accesGranted = true
    
    let dateFormater = DateFormatter()
    
    let locationManager = CLLocationManager()
    let bucharestCenterCoordinate = CLLocationCoordinate2D(latitude: 44.42676678769212 ,longitude: 26.10243551496884)
    let annotationSpan = MKCoordinateSpan(latitudeDelta: 0.0050, longitudeDelta: 0.0050)
    let areaSpan = MKCoordinateSpan(latitudeDelta: 0.10, longitudeDelta: 0.10)
    
    var priorityEventPartition = 0
    var accountTableSelectedRow = 0
    var partitionTableSelectedRow = 0
    var emiTableSelectedRow = 0
    
    lazy var accountsEvents = dspManager.accountsEvents
    lazy var selectedAccount = accountsEvents[accountTableSelectedRow]
    lazy var accountDetailes = selectedAccount.accountDetailes!
    lazy var priorityEvent = selectedAccount.priorityEvent
    lazy var priorityEventType = dspManager.getEventType(event: priorityEvent!)
    lazy var priorityEventColor = priorityEventType.color
    lazy var priorityHigh: Bool = { return priorityEvent!.priority <= 6 }()
    
    let numberSortDescriptor = NSSortDescriptor(key: "number", ascending: true)
    let dateSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
    
    @IBOutlet weak var mapView: MKMapView!
    
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
    @IBOutlet weak var ticketsTableView: NSTableView!

    @IBOutlet weak var activateButtonOutlet: NSButton!
    @IBOutlet weak var eventAlertImage: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //login()
        tableViewsInit()
        dspManager.dspVCDelegate = self
        mapView.delegate = self
        setMapRegion(coordinate: bucharestCenterCoordinate, span: areaSpan)
        narator.delegate = self
        emiTableView.reloadData()
        
        dateFormater.dateStyle = .short
        dateFormater.timeStyle = .short
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
        dspManager.run(getEventsTimeInterval: 3.0)
    }
    func deactivate() {
        activateButtonOutlet.title = "ACTIVATE"
        dspManager.stop()
    }
    
    func generateAlert() {
        accountsEvents = dspManager.accountsEvents
        for account in accountsEvents {
            if !account.generatedAlarm {
                setAccount(account: account)
                generateAlarm(account: account)
            }
            eventsTableView.reloadData()
        }
    }
    
    @IBAction func cancelAlarmButton(_ sender: NSButton) {
        dspManager.removeAlarm(selectedAccountIndex: accountTableSelectedRow)
        accountTableSelectedRow = 0
        reloadTableViewData()
    }
    
    func setMapRegion(coordinate: CLLocationCoordinate2D, span: MKCoordinateSpan) {
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.region = region
    }
    
    func showItemOnMap(name: String, coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = name
        mapView.addAnnotation(annotation)
        setMapRegion(coordinate: annotation.coordinate, span: annotationSpan)
        mapView.selectAnnotation(annotation, animated: true)
    }
    @IBAction func removeEmiButton(_ sender: NSButton) {
        dspManager.storeData.deleteEmi(selectedEmiIndex: emiTableSelectedRow)
        emiTableView.reloadData()
    }
    
    func setAccount(account: AccountEvents) {
        selectedAccount = account
        accountDetailes = account.accountDetailes!
        priorityEvent = account.priorityEvent
        priorityEventType = dspManager.getEventType(event: priorityEvent!)
        priorityEventColor = priorityEventType.color
        eventAlertImage.image = account.priorityEventType?.image
        let coordinate = CLLocationCoordinate2D(latitude: accountDetailes.location!.latitude, longitude: accountDetailes.location!.longitude)
        showItemOnMap(name: accountDetailes.objective! ,coordinate: coordinate)
        reloadTableViewData()
    }
    
    func generateAlarm(account: AccountEvents) {
        NSSound(named: "Glass")?.play()
        if account.priorityEvent!.priority < 7 {
            narator.startSpeaking(account.priorityEvent!.name)
        }
        account.generatedAlarm = true
    }
}

extension DSPViewController: AddEmiVCDelegate {
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "addAccountSegue" {
            if let viewcontroller = segue.destinationController as? AddAccountViewController {
                viewcontroller.delegate = dspManager
                viewcontroller.mazga = true
            }
        } else if segue.identifier == "addEmiSegue" {
            if let viewController = segue.destinationController as? AddEmiVC {
                viewController.delegate = self
            }
        }
    }
    
    func addEmi(id: String, phone: String, active: Bool, statusDetails: String, longitude: Double, latitude: Double) {
        dspManager.storeData.storeEmi(id: id, phone: phone, active: active, statusDetails: statusDetails, longitude: longitude, latitude: latitude)
        emiTableView.reloadData()
    }
    
    func getEmi() -> EmiEntity {
        return EmiEntity()
    }
    
}

extension DSPViewController: NSTableViewDelegate, NSTableViewDataSource {
    
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
        emiTableView.delegate = self
        emiTableView.dataSource = self
        observationsTableView.delegate = self
        observationsTableView.dataSource = self
        emiDetailsTableView.delegate = self
        emiDetailsTableView.dataSource = self
        ticketsTableView.delegate = self
        ticketsTableView.dataSource = self
    }
    
    func reloadTableViewData() {
        accountsTableView.reloadData()
        accountDetailesTableView.reloadData()
        eventsTableView.reloadData()
        scheduleTableView.reloadData()
        scheduleTableView.reloadData()
        partitionsTableView.reloadData()
        zonesTableView.reloadData()
        emiTableView.reloadData()
        observationsTableView.reloadData()
        emiDetailsTableView.reloadData()
        ticketsTableView.reloadData()
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let tableViewSelected = notification.object as! NSTableView
        if tableViewSelected == accountsTableView {
            guard accountsTableView.selectedRow == -1 else {
                accountTableSelectedRow = accountsTableView.selectedRow
                setAccount(account: accountsEvents[accountTableSelectedRow])
                return
            }
        } else if tableViewSelected == partitionsTableView {
            guard partitionsTableView.selectedRow == -1 else {
                partitionTableSelectedRow = partitionsTableView.selectedRow
                zonesTableView.reloadData()
                return
            }
        } else if tableViewSelected == emiTableView {
            guard emiTableView.selectedRow == -1 else {
                emiTableSelectedRow = emiTableView.selectedRow
                return
            }
        } else if 
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if dspManager.accountsEvents.count > 0 {
            if tableView == accountsTableView {
                return dspManager.accountsEvents.count
            } else if tableView == eventsTableView {
                return selectedAccount.events.count
            } else if tableView == accountDetailesTableView {
                return 1
            } else if tableView == scheduleTableView {
                return 7
            } else if tableView == partitionsTableView {
                if let partitions = accountDetailes.partitions {
                    return partitions.count
                } else {return 0}
            } else if tableView == zonesTableView {
                if let partitions = accountDetailes.partitions {
                    let sortedPartitions = partitions.sortedArray(using: [numberSortDescriptor]) as! [PartitionEntity]
                    guard priorityEvent?.partition != 0 && sortedPartitions.count == 0 else {
                        if let zones = sortedPartitions[partitionTableSelectedRow].zones {
                            return zones.count
                        }
                        return 0
                    }
                    for partition in sortedPartitions {
                        guard partition.number != priorityEvent!.partition else {
                            if let zones = partition.zones {
                                return zones.count
                            }
                            return 0
                        }
                    }
                } else {return 0}
            } else if tableView == emiTableView {
                if let emis = dspManager.storeData.getEmis() {
                    return emis.count
                } else {return 0}
            } else if tableView == observationsTableView {
                if let observations = accountDetailes.observations {
                    return observations.count
                } else {return 0}
            } else if tableView == emiDetailsTableView {
                if let emiDetails = accountDetailes.emiDetails {
                    return emiDetails.count
                } else {return 0}
            } else if tableView == ticketsTableView {
                if let tickets = accountDetailes.tickets {
                    return tickets.count
                } else {return 0}
            }
        }
        return 0
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        func generateCell(identifier: String, value: String) -> NSTableCellView {
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: identifier), owner: self) as! NSTableCellView
            cell.wantsLayer = true
            cell.layer?.backgroundColor = NSColor.clear.cgColor
            cell.textField?.textColor = NSColor.white
            cell.textField?.stringValue = value
            return cell
        }
        
        func generateBackgroundColoredCell(identifier: String, value: String, color: CGColor) -> NSTableCellView {
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: identifier), owner: self) as! NSTableCellView
            cell.wantsLayer = true
            cell.layer?.backgroundColor = color
            cell.textField?.textColor = NSColor.black
            cell.textField?.stringValue = value
            return cell
        }

        if dspManager.accountsEvents.count > 0 {

            if tableView == self.accountsTableView {
                
                let priorityEventDate = dateFormater.string(from: priorityEvent!.date as Date)
                let date = priorityEventDate.components(separatedBy: " ")
                let eventType = accountsEvents[row].priorityEvent
                let color = dspManager.getEventType(event: eventType!).color
                
                if tableColumn?.identifier.rawValue == "accountTableViewAccountColumn" {
                    return generateBackgroundColoredCell(identifier: "AccountTableAccountCell", value: accountsEvents[row].id, color: color)
                    
                }else if tableColumn?.identifier.rawValue == "accountTableViewTimeColumn" {
                    return generateBackgroundColoredCell(identifier: "AccountTableTimeCell", value: date[1], color: color)
                    
                }else if tableColumn?.identifier.rawValue == "accountTableViewEventColumn" {
                    return generateBackgroundColoredCell(identifier: "AccountTableEventCell", value: accountsEvents[row].priorityEvent!.name, color: color)
    
                }else if tableColumn?.identifier.rawValue == "accountTableViewObjectiveColumn" {
                    if let objectiveName = accountsEvents[row].accountDetailes!.objective {
                        return generateBackgroundColoredCell(identifier: "AccountTableObjectiveCell", value: objectiveName, color: color)
                    } else {
                        return generateBackgroundColoredCell(identifier: "AccountTableObjectiveCell", value: "UNREGISTERED ACCOUNT", color: color)
                    }
                }
                
            } else if tableView == self.eventsTableView {
                let event = selectedAccount.events[row]
                
                let color = dspManager.getEventType(event: event).color
                
                if tableColumn?.identifier.rawValue == "eventsTableDateColumn" {
                    return generateBackgroundColoredCell(identifier: "eventsTableDateCell", value:  dateFormater.string(from: event.date as Date), color: color)
                    
                } else if tableColumn?.identifier.rawValue == "eventsTableEventNameColumn" {
                    return generateBackgroundColoredCell(identifier: "eventsTableEventNameCell", value: event.name, color: color)
                    
                }else if tableColumn?.identifier.rawValue == "eventsTableCIDColumn" {
                    return generateBackgroundColoredCell(identifier: "eventsTableCIDCell", value: event.cid, color: color)
                    
                }else if tableColumn?.identifier.rawValue == "eventsTablePartitionColumn" {
                    return generateBackgroundColoredCell(identifier: "eventsTableCIDCell", value: String(event.partition), color: color)
                    
                }else if tableColumn?.identifier.rawValue == "eventsTableZoneUserColumn" {
                    return generateBackgroundColoredCell(identifier: "eventsTableZoneUserCell", value: String(event.zoneOrUser), color: color)
                    
                }else if tableColumn?.identifier.rawValue == "eventsTableGroupColumn" {
                    return generateBackgroundColoredCell(identifier: "eventsTableGroupCell", value: String(event.group), color: color)
                    
                }else if tableColumn?.identifier.rawValue == "eventsTableEventTypeColumn" {
                    return generateBackgroundColoredCell(identifier: "eventsTableEventTypeCell", value: event.name, color: color)
                    
                }
            } else if tableView == self.accountDetailesTableView {
    
                if tableColumn?.identifier.rawValue == "accountDetailesAccount" {
                    return generateBackgroundColoredCell(identifier: "accountDetailesAccountCell", value: accountDetailes.id!, color: priorityEventColor)
    
                } else if tableColumn?.identifier.rawValue == "accountDetailesType" {
                    return generateBackgroundColoredCell(identifier: "accountDetailesTypeCell", value: accountDetailes.type!, color: priorityEventColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesObjective" {
                    return generateBackgroundColoredCell(identifier: "accountDetailesObjectiveCell", value: accountDetailes.objective!, color: priorityEventColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesClient" {
                    return generateBackgroundColoredCell(identifier: "accountDetailesClientCell", value: accountDetailes.client!, color: priorityEventColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesAdress" {
                    return generateBackgroundColoredCell(identifier: "accountDetailesAdressCell", value: "\(accountDetailes.location!.adress1! ) \(accountDetailes.location!.adress2!)",
                        color: priorityEventColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesCity" {
                    return generateBackgroundColoredCell(identifier: "accountDetailesCityCell", value: accountDetailes.location!.city!, color: priorityEventColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesCounty" {
                    return generateBackgroundColoredCell(identifier: "accountDetailesCountyCell", value: accountDetailes.location!.county!, color: priorityEventColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesSales" {
                    return generateBackgroundColoredCell(identifier: "accountDetailesSalesCell", value: accountDetailes.sales!, color: priorityEventColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesContract" {
                    return generateBackgroundColoredCell(identifier: "accountDetailesContractCell", value: accountDetailes.contract!, color: priorityEventColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesTechnic" {
                    return generateBackgroundColoredCell(identifier: "accountDetailesTechnicCell", value: accountDetailes.technic!, color: priorityEventColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesArmed" {
                    return generateBackgroundColoredCell(identifier: "accountDetailesArmedCell", value: "Yes", color: priorityEventColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesSystem" {
                    return generateBackgroundColoredCell(identifier: "accountDetailesSystemCell", value: accountDetailes.system!, color: priorityEventColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesComunicator" {
                    return generateBackgroundColoredCell(identifier: "accountDetailesComunicatorCell", value: accountDetailes.comunicator!, color: priorityEventColor)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesTest" {
                    return generateBackgroundColoredCell(identifier: "accountDetailesTestCell", value: accountDetailes.periodicTest!, color: priorityEventColor)
                    
                }
            } else if tableView == scheduleTableView {
                if priorityHigh {
                    let calendar = NSCalendar(identifier: .gregorian)
                    calendar?.firstWeekday = 2
                    let weekDay = (calendar?.component(.weekday, from: NSDate() as Date))! - 2
                    let weekDays = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"]
                    if weekDay == row {
                        if tableColumn?.identifier.rawValue == "dayColumn" {
                            return generateBackgroundColoredCell(identifier: "dayCell", value: weekDays[row], color: priorityEventColor)
                        }
                    } else {
                        if tableColumn?.identifier.rawValue == "dayColumn" {
                            return generateCell(identifier: "dayCell", value: weekDays[row])
                        }
                    }
                    if let schedule = accountDetailes.schedeule {
                        let dayTimes = [schedule.monday, schedule.tuesday, schedule.wednesday, schedule.thursday, schedule.friday, schedule.saturday, schedule.sunday]
                        if dayTimes[row]! != "" {
                            let startTime = dayTimes[row]!.components(separatedBy: " ")[0]
                            let endTime = dayTimes[row]!.components(separatedBy: " ")[1]
                            if weekDay == row {
                                if tableColumn?.identifier.rawValue == "openColumn" {
                                    return generateBackgroundColoredCell(identifier: "openCell", value: startTime, color: priorityEventColor)
                                } else if tableColumn?.identifier.rawValue == "closedColumn" {
                                    return generateBackgroundColoredCell(identifier: "closedCell", value: endTime, color: priorityEventColor)
                                } else if tableColumn?.identifier.rawValue == "disarmedColulmn" {
                                    return generateBackgroundColoredCell(identifier: "disarmedCell", value: "", color: priorityEventColor)
                                } else if tableColumn?.identifier.rawValue == "armedColumn" {
                                    return generateBackgroundColoredCell(identifier: "armedCell", value: "", color: priorityEventColor)
                                }
                            } else {
                                if tableColumn?.identifier.rawValue == "openColumn" {
                                    return generateCell(identifier: "openCell", value: startTime)
                                } else if tableColumn?.identifier.rawValue == "closedColumn" {
                                    return generateCell(identifier: "closedCell", value: endTime)
                                } else if tableColumn?.identifier.rawValue == "disarmedColulmn" {
                                    return generateCell(identifier: "disarmedCell", value: "")
                                } else if tableColumn?.identifier.rawValue == "armedColumn" {
                                    return generateCell(identifier: "armedCell", value: "")
                                }
                            }
                        }
                    }
                }
            } else if tableView == partitionsTableView {
                if priorityHigh {
                    if let partitions = accountDetailes.partitions {
                        let sortedPartitions = partitions.sortedArray(using: [numberSortDescriptor]) as! [PartitionEntity]
                        let partition = sortedPartitions[row]
                        
                        if partition.number == priorityEvent!.partition {
                            if tableColumn?.identifier.rawValue == "partitionsTableNumberColumn"{
                                return generateBackgroundColoredCell(identifier: "partitionTableNumberCell", value: String(partition.number), color: priorityEventColor)
                            }
                            if tableColumn?.identifier.rawValue == "partitionTableNamesColumn"{
                                return generateBackgroundColoredCell(identifier: "partitionTableNameCell", value: partition.name!, color: priorityEventColor)
                            }
                            if tableColumn?.identifier.rawValue == "partitionTableArmedColumn"{
                                return generateBackgroundColoredCell(identifier: "partitionTableArmedCell", value: "", color: priorityEventColor)
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
                if priorityHigh {
                    if let partitions = accountDetailes.partitions {
                        let sortedPartitions = partitions.sortedArray(using: [numberSortDescriptor]) as! [PartitionEntity]
                        var sortedZones: [ZoneEntity]?
                        if priorityEventPartition == 0 {
                            if let zones = sortedPartitions[partitionTableSelectedRow].zones {
                                sortedZones = (zones.sortedArray(using: [numberSortDescriptor]) as! [ZoneEntity])
                            }
                        } else {
                            for partition in sortedPartitions {
                                if partition.number == priorityEventPartition {
                                    if let zones = partition.zones {
                                        sortedZones = (zones.sortedArray(using: [numberSortDescriptor]) as! [ZoneEntity])
                                        break
                                    }
                                }
                            }
                        }
                        
                        let zone = sortedZones![row]
                        
                        if zone.number == priorityEvent!.zoneOrUser && zone.number != 0 {
                            if tableColumn?.identifier.rawValue == "zonesTableNumberColumn"{
                                return generateBackgroundColoredCell(identifier: "zonesTableNumberCell", value: String(zone.number), color: priorityEventColor)
                            }
                            if tableColumn?.identifier.rawValue == "zonesTableNamesColumn"{
                                return generateBackgroundColoredCell(identifier: "zonesTableNameCell", value: zone.name!, color: priorityEventColor)
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
            } else if tableView == emiTableView {
                if let emis = dspManager.storeData.getEmis() {
                    let emi = emis[row]
                    let color: CGColor = {
                        if emi.active {
                            return NSColor.systemGreen.cgColor
                        } else { return NSColor.systemRed.cgColor}}()
                    if tableColumn?.identifier.rawValue == "emiTableIdColumn" {
                        return generateBackgroundColoredCell(identifier: "emiTableIdCell", value: emi.id!, color: color)
                    } else if tableColumn?.identifier.rawValue == "emiTablePhoneColumn" {
                        return generateBackgroundColoredCell(identifier: "emiTablePhoneCell", value: emi.phone!, color: color)
                    } else if tableColumn?.identifier.rawValue == "emiTableDistancColumn" {
                        return generateBackgroundColoredCell(identifier: "emiTableDistancCell", value: "", color: color)
                    } else if tableColumn?.identifier.rawValue == "emiTableStatusDetailsColumn" {
                        return generateBackgroundColoredCell(identifier: "emiTableStatusDetailsCell", value: emi.statusDetails!, color: color)
                    }
                }
            } else if tableView == observationsTableView {
                if priorityHigh {
                    if let observations = accountDetailes.observations {
                        let sortedObservations = observations.sortedArray(using: [dateSortDescriptor]) as! [ObservationsEntity]
                        let observation = sortedObservations[row]
                        if tableColumn?.identifier.rawValue == "observationsTableColumn" {
                            return generateCell(identifier: "observationsTableCell", value: observation.observation!)
                        }
                    }
                }
            } else if tableView == emiDetailsTableView {
                if priorityHigh {
                    if let emiDetails = accountDetailes.emiDetails {
                        let sortedEmiDetails = emiDetails.sortedArray(using: [dateSortDescriptor]) as! [EmiDetailesEntity]
                        let emiDetail = sortedEmiDetails[row]
                        if tableColumn?.identifier.rawValue == "emiDetailsTableColumn" {
                            return generateCell(identifier: "emiDetailsTableCell", value: emiDetail.detailes!)
                        }
                    }
                }
            } else if tableView == ticketsTableView {
                if priorityHigh {
                    if let tickets = accountDetailes.tickets {
                        let sortedTickets = tickets.sortedArray(using: [dateSortDescriptor]) as! [TicketEntity]
                        let ticket = sortedTickets[row]
                        if tableColumn?.identifier.rawValue == "dateTicketsTableColumn" {
                            return generateCell(identifier: "dateTicketsTableCell", value: dateFormater.string(from: ticket.date! as Date))
                        } else if tableColumn?.identifier.rawValue == "numberTicketsTableColumn" {
                            return generateCell(identifier: "numberTicketsTableCell", value: String(ticket.number))
                        } else if tableColumn?.identifier.rawValue == "userTicketsTableColumn" {
                            return generateCell(identifier: "userTicketsTableCell", value: ticket.user!)
                        } else if tableColumn?.identifier.rawValue == "managerTicketsTableColumn" {
                            return generateCell(identifier: "managerTicketsTableCell", value: ticket.manager!)
                        } else if tableColumn?.identifier.rawValue == "typeTicketsTableColumn" {
                            return generateCell(identifier: "typeTicketsTableCell", value: ticket.type!)
                        } else if tableColumn?.identifier.rawValue == "statusTicketsTableColumn" {
                            return generateCell(identifier: "statusTicketsTableCell", value: ticket.status!)
                        } else if tableColumn?.identifier.rawValue == "detailsTicketsTableColumn" {
                            return generateCell(identifier: "detailsTicketsTableCell", value: ticket.details!)
                        }
                    }
                }
            }
        }
        return NSTableCellView()
    }
}


