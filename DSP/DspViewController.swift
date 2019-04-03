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

class DSPViewController: NSViewController, MKMapViewDelegate, NSSpeechSynthesizerDelegate, DspVCDelegate, LoginVCDelegate {
    private let narator = NSSpeechSynthesizer()
    private let dspManager = DspManager()
    private let mapManager = MapManager()
    private let email = SendEmail()
    private let dspAlert = DspAlert()
    
    var accesGranted = false
    
    private let dateFormater = DateFormatter()
    
    private let locationManager = CLLocationManager()
     
    private var priorityEventPartition = 0
    private var accountTableSelectedRow = 0
    private var partitionTableSelectedRow = 0
    private var emiTableSelectedRow = 0
    
    private var emis = [EmiEntity]()
    private var selectedEmi: EmiEntity?
    private var selectedEmiCLCoordinate: CLLocationCoordinate2D?
    private var selectedEmiCLLocation: CLLocation?
    
    private  enum emiStatus: String {
        case available = "AVAILABLE"
        case unavailable = "UNAVAILABLE"
        case inAction = "IN ACTION"
        case waiting = "WAITING"
    }
    
    private var selectedAccount: AccountEvents?
    private var priorityEventType: EventType?
    private var priorityEventColor: CGColor?
    private var priorityHigh: Bool?
    private var selectedAccountCLCoordinate: CLLocationCoordinate2D?
    private var selectedAccountCLLocation: CLLocation?
    
    let numberSortDescriptor = NSSortDescriptor(key: "number", ascending: true)
    let dateSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
    
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
    @IBOutlet weak var actionDetailsTableView: NSTableView!
    @IBOutlet weak var ticketsTableView: NSTableView!

    @IBOutlet weak var activateButtonOutlet: NSButton!
    @IBOutlet weak var eventAlertImage: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        login()
        dspManager.dspVCDelegate = self
        mapView.delegate = self
        narator.delegate = self
        mapManager.setDefault(map: mapView)
        emis = dspManager.getEmis()
        dateFormater.dateStyle = .short
        dateFormater.timeStyle = .short
        tableViewsInit()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.title = "DSP                                                                              "
    }
    
    func exitApplication() {
        NSApp.terminate(self)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = NSColor.systemRed
        return renderer
    }
    
    private func login() {
        let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
        let loginVC = mainStoryBoard.instantiateController(withIdentifier: "loginVC") as! LoginVC
        loginVC.delegate = self
        self.presentAsModalWindow(loginVC)
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
    
    private func activate() {
        activateButtonOutlet.title = "DEACTIVATE                         "
        dspManager.run(getEventsTimeInterval: 3.0)
    }
    
    private func deactivate() {
        activateButtonOutlet.title = "ACTIVATE                           "
        dspManager.stop()
    }
    
    func generateAlert() {
        for account in dspManager.accountsEvents {
            if !account.generatedAlarm {
                setSelectedAccount(account: account)
                generateAlarm(account: account)
            }
            eventsTableView.reloadData()
        }
    }
    
    private func generateAlarm(account: AccountEvents) {
        NSSound(named: "Glass")?.play()
        if account.priorityEvent!.priority < 7 {
            narator.startSpeaking(account.priorityEvent!.name)
        }
        account.generatedAlarm = true
    }
    
    @IBAction func autoActionButton(_ sender: NSButton) {
        if emis.count > 0 {
            setSelectedEmi(emi: emis[0])
            sendEmi(emi: selectedEmi!)
        }
    }
    
    @IBAction func sendEmiButton(_ sender: NSButton) {
        if selectedEmi != nil {
            sendEmi(emi: selectedEmi!)
        }
    }
    
    @IBAction func notifyClientButton(_ sender: NSButton) {
        
    }

    @IBAction func serviceModeButton(_ sender: NSButton) {
        dspManager.addToServiceMode(index: accountTableSelectedRow)
        cancelAlarm()
    }
    
    @IBAction func addTicketButton(_ sender: NSButton) {
        if let event = selectedAccount?.priorityEvent {
            if event.priority == 6 {
                dspManager.storeData.storeTicket(account: selectedAccount!.details!, content: event.name)
                let message = "Event: \(event.name) partition: \(event.partition) zone/user: \(event.zoneOrUser)"
                emailTicket(message: message)
                actionDetailsTableView.reloadData()
                ticketsTableView.reloadData()
            } else {
                dspAlert.showAlert(message: "Event must be of type TROUBLE")
            }
        }
    }
    
    private func emailTicket(message: String) {
        let managers = dspManager.storeData.getManagers()
        for manager in managers {
            if manager.name == selectedAccount?.details?.manager {
                let subject = "DSP: QUICK TICKET FOR: \(selectedAccount!.details!.objective!)"
                email.sendTicket(emails: [manager.email!], subject: subject, account: selectedAccount!.details!, message: message)
            }
        }
    }
    
    private func sendEmi(emi: EmiEntity) {
        guard selectedAccount?.emi == nil else { dspAlert.showAlert(message: "Already sent SECURITY: \(selectedAccount!.emi!.id!)"); return }
        guard emi.status == emiStatus.available.rawValue else { dspAlert.showAlert(message: "SECURITY ID: \(emi.id!) isn't avaialable!"); return }
        selectedAccount?.emi = emi
        selectedEmi?.status = emiStatus.inAction.rawValue
        selectedEmi?.statusDetails = "SENT TO: \(selectedAccount!.details!.objective!) FOR: \(selectedAccount!.priorityEvent!.name)"
        dspManager.storeData.storeActionDetails(account: selectedAccount!.details!, emiId: selectedEmi!.id!, solution: "SENT SECURITY", details: selectedAccount!.priorityEvent!.name)
        mapManager.calculatingRout(map: mapView, source: selectedEmiCLCoordinate!, destination: selectedAccountCLCoordinate!)
        sortEmi()
        emiTableView.reloadData()
        actionDetailsTableView.reloadData()
    }
    
    private func cancelEmi() {
        if let emi = selectedAccount?.emi {
            emi.status = emiStatus.available.rawValue
            emi.statusDetails = emiStatus.waiting.rawValue
            dspManager.storeData.saveContext()
            selectedAccount?.emi = nil
            resetDspInterface()
            showSelectedAccountOnMap()
        }
    }

    private func resetDspInterface() {
        reloadTableViewData()
        let annotations = mapView.annotations
        let overLays = mapView.overlays
        mapView.removeAnnotations(annotations)
        mapView.removeOverlays(overLays)
        mapManager.setDefault(map: mapView)
    }
    
    @IBAction func removeEmiButton(_ sender: NSButton) {
        //guard selectedEmi?.status != emiStatus.inAction.rawValue else { dspAlert.showAlert(message: "EMI IN ACTION.\nDeleting is denied! "); return }
        dspManager.storeData.deleteEmi(emi: selectedEmi!)
        emis = dspManager.storeData.getEmis()!
        sortEmi()
        resetDspInterface()
    }
    
    private func cancelAlarm() {
        if dspManager.accountsEvents.count != 0 {
            dspManager.accountsEvents.remove(at: accountTableSelectedRow)
            accountTableSelectedRow = 0
            setSelectedAccount(account: dspManager.accountsEvents[accountTableSelectedRow])
        } else { selectedAccount = nil }
        resetDspInterface()
        eventAlertImage.image = nil
    }
    
    private func setSelectedAccount(account: AccountEvents) {
        selectedAccount = account
        priorityEventType = dspManager.getEventType(event: selectedAccount!.priorityEvent!)
        priorityEventColor = priorityEventType!.color
        priorityHigh = { return selectedAccount!.priorityEvent!.priority <= 6 }()
        eventAlertImage.image = account.priorityEventType?.image
        let accountLocation = account.details!.location!
        selectedAccountCLCoordinate = CLLocationCoordinate2D(latitude: accountLocation.latitude , longitude: accountLocation.longitude)
        selectedAccountCLLocation = CLLocation(latitude: accountLocation.latitude, longitude: accountLocation.longitude)
        sortEmi()
        reloadTableViewData()
        mapManager.showItemOnMap(map: mapView, name: selectedAccount!.details!.objective! ,coordinate: selectedAccountCLCoordinate!)
    }
    
    private func setSelectedEmi(emi: EmiEntity) {
        selectedEmi = emi
        selectedEmiCLCoordinate = CLLocationCoordinate2D(latitude: emi.latitude, longitude: emi.longitude)
        selectedEmiCLLocation = CLLocation(latitude: emi.latitude, longitude: emi.longitude)
        mapManager.showItemOnMap(map: mapView, name: emis[emiTableSelectedRow].id!, coordinate: selectedEmiCLCoordinate!)
    }
    
    private func showSelectedEmiOnMap() {
        mapManager.showItemOnMap(map: mapView, name: selectedEmi!.id!, coordinate: selectedEmiCLCoordinate!)
    }
    
    private func showSelectedAccountOnMap() {
        mapManager.showItemOnMap(map: mapView, name: selectedAccount!.details!.objective!, coordinate: selectedAccountCLCoordinate!)
    }
    
    private func sortEmi() {
        for emi in emis {
            let emiCLLocation = CLLocation(latitude: emi.latitude, longitude: emi.longitude)
            emi.distance = mapManager.calculateDistance(map: mapView, source: emiCLLocation, destination: selectedAccountCLLocation!)
        }
        var availableEmi = [EmiEntity]()
        var unavailableEmi = [EmiEntity]()
        var inActionEmi = [EmiEntity]()
        for emi in emis {
            switch emi.status {
            case emiStatus.available.rawValue : availableEmi.append(emi)
            case emiStatus.unavailable.rawValue: unavailableEmi.append(emi)
            case emiStatus.inAction.rawValue: inActionEmi.append(emi)
            default: dspAlert.showAlert(message: "Something went worong sorting EMI")
            }
        }
        emis = availableEmi.sorted(by: {($0.distance < $1.distance)}) + inActionEmi + unavailableEmi
        emiTableView.reloadData()
    }

    @IBAction func removeAction(_ sender: NSButton) {
        dspManager.storeData.deleteActions()
        actionDetailsTableView.reloadData()
    }
}

extension DSPViewController: AddEmiVCDelegate, ServiceModeVCDelegate, SolutionVCDelegate {
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "addAccountSegue" {
            if let viewcontroller = segue.destinationController as? AddAccountViewController {
                viewcontroller.delegate = dspManager
            }
        } else if segue.identifier == "addEmiSegue" {
            if let viewController = segue.destinationController as? AddEmiVC {
                viewController.delegate = self
            }
        } else if segue.identifier == "editEmiSegue" {
            if let viewController = segue.destinationController as? AddEmiVC {
                viewController.delegate = self
                viewController.editButtonPresed = true
            }
        } else if segue.identifier == "serviceModeSegue" {
            if let viewController = segue.destinationController as? ServiceModeAccountsVC {
                viewController.delegate = self
            }
        } else if segue.identifier == "solutionVCSegue" {
            if let viewController = segue.destinationController as? SolutionVC {
                viewController.delegate = self
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: NSStoryboardSegue.Identifier, sender: Any?) -> Bool {
        if identifier == "editEmiSegue" {
            if selectedEmi?.status == emiStatus.inAction.rawValue {
                dspAlert.showAlert(message: "EMI IN ACTION.\nEditing is denied! ")
                return false
            }
        }
        return true
    }
    
    func getServiceModeAccounts() -> [AccountEvents] {
        return dspManager.serviceModeAccounts
    }
    
    func removeFromServiceMode(index: Int) {
        dspManager.removeFromServiceMode(index: index)
    }
    
    func addEmi(id: String, phone: String, status: String, statusDetails: String, longitude: Double, latitude: Double) {
        dspManager.storeData.storeEmi(id: id, phone: phone, status: status, statusDetails: statusDetails, longitude: longitude, latitude: latitude)
        emis = dspManager.getEmis()
        emiTableView.reloadData()
    }
    
    func getEmi() -> EmiEntity {
        return selectedEmi!
    }
    
    func saveEmi() {
        dspManager.storeData.saveContext()
        sortEmi()
    }
    
    func setActionSolution(solution: String, details: String) {
        var emi = String()
        if selectedAccount?.emi == nil {
            emi = "NO"
        } else {
            emi = selectedAccount!.emi!.id!
        }
        if solution == "TICKET CREATED" {
            dspManager.storeData.storeActionDetails(account: selectedAccount!.details!, emiId: emi, solution: solution, details: selectedAccount!.priorityEvent!.name)
        } else {
            dspManager.storeData.storeActionDetails(account: selectedAccount!.details!, emiId: emi, solution: solution, details: details)
        }
        cancelEmi()
        cancelAlarm()
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
        actionDetailsTableView.delegate = self
        actionDetailsTableView.dataSource = self
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
        actionDetailsTableView.reloadData()
        ticketsTableView.reloadData()
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let tableViewSelected = notification.object as! NSTableView
        if tableViewSelected == accountsTableView {
            guard accountsTableView.selectedRow == -1 else {
                accountTableSelectedRow = accountsTableView.selectedRow
                setSelectedAccount(account: dspManager.accountsEvents[accountTableSelectedRow])
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
                setSelectedEmi(emi: emis[emiTableSelectedRow])
                return
            }
        }
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == accountsTableView { return dspManager.accountsEvents.count }
        else if tableView == accountDetailesTableView { return 1 }
        else if tableView == scheduleTableView { return 7 }
        
        guard let account = selectedAccount else { return 0 }
        if tableView == eventsTableView {
            return account.events.count
        } else if tableView == partitionsTableView {
            guard let partitions = account.details!.partitions else { return 0 }
            return partitions.count
        } else if tableView == zonesTableView {
            guard let partitions = account.details!.partitions else { return 0 }
            guard partitions.count != 0 else {return 0}
            let sortedPartitions = partitions.sortedArray(using: [numberSortDescriptor]) as! [PartitionEntity]
            guard account.priorityEvent!.partition != 0 && sortedPartitions.count == 0 else {
                if let zones = sortedPartitions[partitionTableSelectedRow].zones { return zones.count }
                return 0
            }
        } else if tableView == emiTableView {
            guard let emis = dspManager.storeData.getEmis() else { return 0 }
            return emis.count
        } else if tableView == observationsTableView {
            guard let observations = account.details!.observations else { return 0 }
            return observations.count
        } else if tableView == emiDetailsTableView {
            guard let emiDetails = account.details!.emiDetails else { return 0 }
            return emiDetails.count
        } else if tableView == ticketsTableView {
            guard let tickets = account.details!.tickets else { return 0 }
            return tickets.count
        } else if tableView == actionDetailsTableView {
            guard let actionDetails = account.details!.actionDetailes else { return 0 }
            return actionDetails.count
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

        if tableView == self.accountsTableView {
            if selectedAccount != nil {
                let priorityEventDate = dateFormater.string(from: selectedAccount!.priorityEvent!.date as Date)
                let date = priorityEventDate.components(separatedBy: " ")
                let eventType = dspManager.accountsEvents[row].priorityEvent
                let color = dspManager.getEventType(event: eventType!).color
                
                if tableColumn?.identifier.rawValue == "accountTableViewAccountColumn" {
                    return generateBackgroundColoredCell(identifier: "AccountTableAccountCell", value: dspManager.accountsEvents[row].id, color: color)
                    
                }else if tableColumn?.identifier.rawValue == "accountTableViewTimeColumn" {
                    return generateBackgroundColoredCell(identifier: "AccountTableTimeCell", value: date[1], color: color)
                    
                }else if tableColumn?.identifier.rawValue == "accountTableViewEventColumn" {
                    return generateBackgroundColoredCell(identifier: "AccountTableEventCell", value: dspManager.accountsEvents[row].priorityEvent!.name, color: color)
                    
                }else if tableColumn?.identifier.rawValue == "accountTableViewObjectiveColumn" {
                    if let objectiveName = dspManager.accountsEvents[row].details!.objective {
                        return generateBackgroundColoredCell(identifier: "AccountTableObjectiveCell", value: objectiveName, color: color)
                    } else {
                        return generateBackgroundColoredCell(identifier: "AccountTableObjectiveCell", value: "UNREGISTERED ACCOUNT", color: color)
                    }
                }
            }
        } else if tableView == self.eventsTableView {
            if selectedAccount != nil {
                let event = selectedAccount!.events[row]
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
            }
        } else if tableView == self.accountDetailesTableView {
            if selectedAccount != nil {
                if tableColumn?.identifier.rawValue == "accountDetailesAccount" {
                    return generateBackgroundColoredCell(identifier: "accountDetailesAccountCell", value: selectedAccount!.details!.id!, color: priorityEventColor!)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesType" {
                    return generateBackgroundColoredCell(identifier: "accountDetailesTypeCell", value: selectedAccount!.details!.type!, color: priorityEventColor!)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesObjective" {
                    return generateBackgroundColoredCell(identifier: "accountDetailesObjectiveCell", value: selectedAccount!.details!.objective!, color: priorityEventColor!)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesClient" {
                    return generateBackgroundColoredCell(identifier: "accountDetailesClientCell", value: selectedAccount!.details!.client!, color: priorityEventColor!)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesAdress" {
                    return generateBackgroundColoredCell(identifier: "accountDetailesAdressCell", value: "\(selectedAccount!.details!.location!.adress1! ) \(selectedAccount!.details!.location!.adress2!)",
                        color: priorityEventColor!)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesCity" {
                    return generateBackgroundColoredCell(identifier: "accountDetailesCityCell", value: selectedAccount!.details!.location!.city!, color: priorityEventColor!)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesCounty" {
                    return generateBackgroundColoredCell(identifier: "accountDetailesCountyCell", value: selectedAccount!.details!.location!.county!, color: priorityEventColor!)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesSales" {
                    return generateBackgroundColoredCell(identifier: "accountDetailesSalesCell", value: selectedAccount!.details!.sales!, color: priorityEventColor!)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesContract" {
                    return generateBackgroundColoredCell(identifier: "accountDetailesContractCell", value: selectedAccount!.details!.contract!, color: priorityEventColor!)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesTechnic" {
                    return generateBackgroundColoredCell(identifier: "accountDetailesTechnicCell", value: selectedAccount!.details!.technic!, color: priorityEventColor!)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesArmed" {
                    return generateBackgroundColoredCell(identifier: "accountDetailesArmedCell", value: "", color: priorityEventColor!)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesSystem" {
                    return generateBackgroundColoredCell(identifier: "accountDetailesSystemCell", value: selectedAccount!.details!.system!, color: priorityEventColor!)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesComunicator" {
                    return generateBackgroundColoredCell(identifier: "accountDetailesComunicatorCell", value: selectedAccount!.details!.comunicator!, color: priorityEventColor!)
                    
                } else if tableColumn?.identifier.rawValue == "accountDetailesTest" {
                    return generateBackgroundColoredCell(identifier: "accountDetailesTestCell", value: selectedAccount!.details!.periodicTest!, color: priorityEventColor!)
                    
                }
            }
        } else if tableView == scheduleTableView {
            if selectedAccount != nil && priorityHigh! {
                let calendar = NSCalendar(identifier: .gregorian)
                calendar?.firstWeekday = 2
                let weekDay = (calendar?.component(.weekday, from: NSDate() as Date))! - 2
                let weekDays = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"]
                if weekDay == row {
                    if tableColumn?.identifier.rawValue == "dayColumn" {
                        return generateBackgroundColoredCell(identifier: "dayCell", value: weekDays[row], color: priorityEventColor!)
                    }
                } else {
                    if tableColumn?.identifier.rawValue == "dayColumn" {
                        return generateCell(identifier: "dayCell", value: weekDays[row])
                    }
                }
                if let schedule = selectedAccount!.details!.schedeule {
                    let dayTimes = [schedule.monday, schedule.tuesday, schedule.wednesday, schedule.thursday, schedule.friday, schedule.saturday, schedule.sunday]
                    if dayTimes[row]! != "" {
                        let startTime = dayTimes[row]!.components(separatedBy: " ")[0]
                        let endTime = dayTimes[row]!.components(separatedBy: " ")[1]
                        if weekDay == row {
                            if tableColumn?.identifier.rawValue == "openColumn" {
                                return generateBackgroundColoredCell(identifier: "openCell", value: startTime, color: priorityEventColor!)
                            } else if tableColumn?.identifier.rawValue == "closedColumn" {
                                return generateBackgroundColoredCell(identifier: "closedCell", value: endTime, color: priorityEventColor!)
                            } else if tableColumn?.identifier.rawValue == "disarmedColulmn" {
                                return generateBackgroundColoredCell(identifier: "disarmedCell", value: "", color: priorityEventColor!)
                            } else if tableColumn?.identifier.rawValue == "armedColumn" {
                                return generateBackgroundColoredCell(identifier: "armedCell", value: "", color: priorityEventColor!)
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
            if selectedAccount != nil && priorityHigh! {
                if let partitions = selectedAccount!.details!.partitions {
                    let sortedPartitions = partitions.sortedArray(using: [numberSortDescriptor]) as! [PartitionEntity]
                    let partition = sortedPartitions[row]
                    
                    if partition.number == selectedAccount!.priorityEvent!.partition {
                        if tableColumn?.identifier.rawValue == "partitionsTableNumberColumn"{
                            return generateBackgroundColoredCell(identifier: "partitionTableNumberCell", value: String(partition.number), color: priorityEventColor!)
                        }
                        if tableColumn?.identifier.rawValue == "partitionTableNamesColumn"{
                            return generateBackgroundColoredCell(identifier: "partitionTableNameCell", value: partition.name!, color: priorityEventColor!)
                        }
                        if tableColumn?.identifier.rawValue == "partitionTableArmedColumn"{
                            return generateBackgroundColoredCell(identifier: "partitionTableArmedCell", value: "", color: priorityEventColor!)
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
            if selectedAccount != nil && priorityHigh! {
                if let partitions = selectedAccount!.details!.partitions {
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
                    
                    if zone.number == selectedAccount!.priorityEvent!.zoneOrUser && zone.number != 0 {
                        if tableColumn?.identifier.rawValue == "zonesTableNumberColumn"{
                            return generateBackgroundColoredCell(identifier: "zonesTableNumberCell", value: String(zone.number), color: priorityEventColor!)
                        }
                        if tableColumn?.identifier.rawValue == "zonesTableNamesColumn"{
                            return generateBackgroundColoredCell(identifier: "zonesTableNameCell", value: zone.name!, color: priorityEventColor!)
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
            let emi = emis[row]
            let color: CGColor = {
                switch emi.status {
                case "IN ACTION": return NSColor.systemRed.cgColor
                case "AVAILABLE": return NSColor.systemGreen.cgColor
                case "UNAVAILABLE": return NSColor.systemBlue.cgColor
                default: return NSColor.black.cgColor
                }
            }()
            if tableColumn?.identifier.rawValue == "emiTableIdColumn" {
                return generateBackgroundColoredCell(identifier: "emiTableIdCell", value: emi.id!, color: color)
            } else if tableColumn?.identifier.rawValue == "emiTablePhoneColumn" {
                return generateBackgroundColoredCell(identifier: "emiTablePhoneCell", value: emi.phone!, color: color)
            } else if tableColumn?.identifier.rawValue == "emiTableDistancColumn" {
                return generateBackgroundColoredCell(identifier: "emiTableDistancCell", value: String(format: "%.3f", emi.distance), color: color)
            } else if tableColumn?.identifier.rawValue == "emiTableStatusColumn" {
                return generateBackgroundColoredCell(identifier: "emiTableStatusCell", value: emi.status!, color: color)
            } else if tableColumn?.identifier.rawValue == "emiTableStatusDetailsColumn" {
                return generateBackgroundColoredCell(identifier: "emiTableStatusDetailsCell", value: emi.statusDetails!, color: color)
            }
        } else if tableView == observationsTableView {
            if selectedAccount != nil && priorityHigh! {
                if let observations = selectedAccount!.details!.observations {
                    let sortedObservations = observations.sortedArray(using: [dateSortDescriptor]) as! [ObservationsEntity]
                    let observation = sortedObservations[row]
                    if tableColumn?.identifier.rawValue == "observationsTableColumn" {
                        return generateCell(identifier: "observationsTableCell", value: observation.observation!)
                    }
                }
            }
        } else if tableView == emiDetailsTableView {
            if selectedAccount != nil && priorityHigh! {
                if let emiDetails = selectedAccount!.details!.emiDetails {
                    let sortedEmidetails = emiDetails.sortedArray(using: [dateSortDescriptor]) as! [EmiDetailesEntity]
                    let emiDetail = sortedEmidetails[row]
                    if tableColumn?.identifier.rawValue == "emiDetailsTableColumn" {
                        return generateCell(identifier: "emiDetailsTableCell", value: emiDetail.detailes!)
                    }
                }
            }
        } else if tableView == actionDetailsTableView {
            if selectedAccount != nil && priorityHigh! {
                if let actionDetails = selectedAccount!.details!.actionDetailes {
                    let descendingDateSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
                    let sortedActionDetails = actionDetails.sortedArray(using: [descendingDateSortDescriptor]) as! [ActionDetailesEntity]
                    let actionDetail = sortedActionDetails[row]
                    if tableColumn?.identifier.rawValue == "actionDetailsTableDateColumn" {
                        return generateCell(identifier: "actionDetailsTableDateCell", value: dateFormater.string(from: actionDetail.date! as Date))
                    } else if tableColumn?.identifier.rawValue == "actionDetailsTableUserColumn" {
                        return generateCell(identifier: "actionDetailsTableUserCell", value: actionDetail.user!)
                    } else if tableColumn?.identifier.rawValue == "actionDetailsTableEmiColumn" {
                        return generateCell(identifier: "actionDetailsTableEmiCell", value: actionDetail.emi!)
                    } else if tableColumn?.identifier.rawValue == "actionDetailsTableSolutionColumn" {
                        return generateCell(identifier: "actionDetailsTableSolutionCell", value: actionDetail.solution!)
                    } else if tableColumn?.identifier.rawValue == "actionDetailsTableSolutionDetailsColumn" {
                        return generateCell(identifier: "actionDetailsTableSolutionDetailsCell", value: actionDetail.detailes!)
                    }
                }
            }
        } else if tableView == ticketsTableView {
            if selectedAccount != nil && priorityHigh! {
                if let tickets = selectedAccount!.details!.tickets {
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
        return NSTableCellView()
    }
}


