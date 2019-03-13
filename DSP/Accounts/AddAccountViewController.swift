//
//  AddAccountViewController.swift
//  DSP
//
//  Created by Sacuiu Dragos on 28/11/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Cocoa

protocol AddAcccountVCDelegate {
    func addToBlackList(accountID: String)
    func removeFromBlackList(accountID: String)
    func reloadTableViewsData()
}

class AddAccountViewController: NSViewController {
    
    var delegate: AddAcccountVCDelegate?
    
    var mazga = false
    
    let storeAccount = UserStoreData()
    let dateFormater = DateFormatter()
    let dspAlert = DspAlert()
    
    var zones = [ZoneEntity]()
    var longitude = Double()
    var latitude = Double()
    
    let numberSortDescriptor = NSSortDescriptor(key: "number", ascending: true)
    let dateSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
    let priorityDescriptor = NSSortDescriptor(key: "priority", ascending: true)
    
    var partirionsTableViewSelectedRow = 0
    var zonesTableViewselectedRow = 0
    var contactsTableViewSelectedRow = 0
    var emiDetailsTableViewselectedRow = 0
    var observationsTableViewselectedRow = 0
    var ticketsTableViewSelectedRow = 0

    @IBOutlet weak var accountIdTextField: NSTextField!
    @IBOutlet weak var objectiveTextField: NSTextField!
    @IBOutlet weak var clientTextField: NSTextField!
    @IBOutlet weak var objectiveTypeTextField: NSTextField!
    @IBOutlet weak var salesTextField: NSTextField!
    @IBOutlet weak var contractTextField: NSTextField!
    @IBOutlet weak var adress1TextField: NSTextField!
    @IBOutlet weak var adress2TextField: NSTextField!
    @IBOutlet weak var countyTextField: NSTextField!
    @IBOutlet weak var cityTextField: NSTextField!
    @IBOutlet weak var technicTextField: NSTextField!
    @IBOutlet weak var systemTextField: NSTextField!
    @IBOutlet weak var comunicatorTextField: NSTextField!
    @IBOutlet weak var longitudeTextField: NSTextField!
    @IBOutlet weak var latitudeTextField: NSTextField!
    
    @IBOutlet weak var daySelector: NSPopUpButton!
    @IBOutlet weak var startTimePicker: NSDatePicker!
    @IBOutlet weak var endTimePicker: NSDatePicker!

    @IBOutlet weak var test24HOutlet: NSButton!
    @IBOutlet weak var test12HOutlet: NSButton!
    @IBOutlet weak var test6HOutlet: NSButton!
    @IBOutlet weak var test3HOutlet: NSButton!
   
    @IBOutlet weak var scheduleTableView: NSTableView!
    @IBOutlet weak var partitionsTableView: NSTableView!
    @IBOutlet weak var zonesTableView: NSTableView!
    @IBOutlet weak var contactsTableView: NSTableView!
    @IBOutlet weak var emiDetailsTableView: NSTableView!
    @IBOutlet weak var observationsTableView: NSTableView!
    @IBOutlet weak var ticketsTableView: NSTableView!
    
    lazy var textFields: [NSTextField] = {
        return [objectiveTextField,clientTextField,objectiveTypeTextField,salesTextField,contractTextField,adress1TextField,adress2TextField,
                countyTextField,cityTextField,technicTextField,systemTextField,comunicatorTextField,longitudeTextField,latitudeTextField]
    }()
    
    @IBAction func periodicTestChanged(_ sender: AnyObject) {
        
    }
    
    @IBAction func addEmiLocation(_ sender: Any) {
    }
    @IBAction func addClientLocation(_ sender: Any) {
    }
    @IBAction func autoAddLocation(_ sender: Any) {
    }
    @IBAction func resetLocation(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storeAccount.createNewAccount()
        tableViewInit()
        dateFormater.timeStyle = .short
        dateFormater.dateStyle = .short
        
        longitudeTextField.isEditable = false
        latitudeTextField.isEditable = false
    }
    
    override func viewDidDisappear() {
        storeAccount.managedObjectContext.reset()
    }
    //
    func createAccount() {
        if accoutIsValid && allFieldsAreFill && periodicTest != nil {
            storeAccount.account!.id = accountIdTextField.stringValue; storeAccount.account!.objective = objectiveTextField.stringValue; storeAccount.account!.client = clientTextField.stringValue;
            storeAccount.account!.type = objectiveTypeTextField.stringValue; storeAccount.account!.sales = salesTextField.stringValue; storeAccount.account!.contract = contractTextField.stringValue;
            storeAccount.account!.technic = technicTextField.stringValue; storeAccount.account!.system = systemTextField.stringValue; storeAccount.account!.comunicator = comunicatorTextField.stringValue;
            storeAccount.account!.periodicTest = periodicTest
            storeAccount.storeLocation(county: countyTextField.stringValue, city: cityTextField.stringValue, adress1: adress1TextField.stringValue, adress2: adress2TextField.stringValue, longitude: longitude, latitude: latitude)
            delegate?.removeFromBlackList(accountID: accountIdTextField.stringValue)
            storeAccount.saveContext()
        }
    }
    
    @IBAction func saveAccountButton(_ sender: NSButton) {
        createAccount()
    }
    
    @IBAction func searchButton(_ sender: NSButton) {
        if accoutIsValid {
            storeAccount.createNewAccount()
            clearWindowData()
            storeAccount.getExistingAccount(accountID: accountIdTextField.stringValue)
            if storeAccount.account != nil {
                displayAccount()
            }
        }
    }
    
    @IBAction func deleteAccountButton(_ sender: NSButton) {
        storeAccount.deleteAccount()
        storeAccount.saveContext()
        clearWindowData()
        storeAccount.createNewAccount()
    }
    
    @IBAction func copyAccountButton(_ sender: NSButton) {
    }
    
    @IBAction func pasteAccountButton(_ sender: NSButton) {

    }

    @IBAction func addScheduleButton(_ sender: NSButton) {
        let daySelected = daySelector.titleOfSelectedItem!
        let startTime = dateFormater.string(from: startTimePicker.dateValue).components(separatedBy: " ")[1]
        let endTime = dateFormater.string(from: endTimePicker.dateValue).components(separatedBy: " ")[1]
        storeAccount.storeSchedule(day: daySelected, startTime: startTime, endTime: endTime)
        scheduleTableView.reloadData()
    }
    
    @IBAction func removeObservationButton(_ sender: NSButton) {
        storeAccount.removeObservation(selectedObservationIndex: observationsTableViewselectedRow)
        observationsTableView.reloadData()
    }
    @IBAction func removeEmiDetailButton(_ sender: NSButton) {
        storeAccount.removeEmiDetail(selectedEmiDetailIndex: emiDetailsTableViewselectedRow)
        emiDetailsTableView.reloadData()
    }
    
    @IBAction func closeTicketButton(_ sender: NSButton) {
        let tickets = storeAccount.account?.tickets?.sortedArray(using: [dateSortDescriptor]) as? [TicketEntity]
        tickets![ticketsTableViewSelectedRow].status = "CLOSE"
        ticketsTableView.reloadData()
    }
    
    
    lazy var periodicTest: String? = {
        let periodicTestOutlets = [test24HOutlet, test12HOutlet, test6HOutlet, test3HOutlet]
        var selectedPeriodicTestValue: NSButton?
        for periodicTestOutlet in periodicTestOutlets {
            if periodicTestOutlet!.state == .on {
                selectedPeriodicTestValue = periodicTestOutlet
                break
            }
        }
        switch selectedPeriodicTestValue {
        case test24HOutlet:
            return "24H"
        case test12HOutlet:
            return "12H"
        case test6HOutlet:
            return "6H"
        case test3HOutlet:
            return "3H"
        default:
            dspAlert.showAlert(message: "No periodic test selected!")
            return nil
        }
    }()
    
    func selectPeriodicTest(periodicTest: String) {
        let periodicTestOutlets = [test24HOutlet, test12HOutlet, test6HOutlet, test3HOutlet]
        for test in periodicTestOutlets {
            if test?.title == periodicTest {
                test?.state = .on
            }
        }
    }
    
    func displayAccount() {
        if let location = storeAccount.account!.location {
            longitude = location.longitude
            latitude = location.latitude
        }
        
        objectiveTextField.stringValue = storeAccount.account!.objective!
        clientTextField.stringValue = storeAccount.account!.client!
        objectiveTypeTextField.stringValue = storeAccount.account!.type!
        salesTextField.stringValue = storeAccount.account!.sales!
        contractTextField.stringValue = storeAccount.account!.contract!
        adress1TextField.stringValue = storeAccount.account!.location!.adress1!
        adress2TextField.stringValue = storeAccount.account!.location!.adress2!
        countyTextField.stringValue = storeAccount.account!.location!.county!
        cityTextField.stringValue = storeAccount.account!.location!.city!
        technicTextField.stringValue = storeAccount.account!.technic!
        systemTextField.stringValue = storeAccount.account!.system!
        comunicatorTextField.stringValue = storeAccount.account!.comunicator!
        longitudeTextField.stringValue = String(longitude)
        latitudeTextField.stringValue = String(latitude)
        selectPeriodicTest(periodicTest: storeAccount.account!.periodicTest!)
        
        reloadTablesViewData()
    }
    
    lazy var accoutIsValid: Bool = {
        guard accountIdIsValid else {
            guard allFieldsAreFill else {
                return false
            }
            return false
        }
        return true
    }()
    
    lazy var accountIdIsValid: Bool = {
        let validIdCharacters = "0123456789ABCDEF"
        for char in accountIdTextField.stringValue {
            guard validIdCharacters.contains(char) && accountIdTextField.stringValue.count == 4 else {
                dspAlert.showAlert(message: "Invalid Account ID: \(accountIdTextField.stringValue) \nID must contain 4 of these characters: \(validIdCharacters)")
                return false
            }
        }
        return true
    }()
    
    lazy var allFieldsAreFill: Bool = {
        for textField in textFields {
            guard textField.stringValue != "" else {
                dspAlert.showAlert(message: "Please fill all fields!")
                return false
            }
        }
        return true
    }()
    
    func clearWindowData() {
        for textField in textFields {
            textField.stringValue = ""
        }
        let periodicTestOutlets = [test24HOutlet, test12HOutlet, test6HOutlet, test3HOutlet]
        for periodicTestOutlet in periodicTestOutlets {
            if periodicTestOutlet!.state == .on {
                periodicTestOutlet?.state = .off
                break
            }
        }
        reloadTablesViewData()
    }
}

extension AddAccountViewController: AddPartitionVCDelegate, AddZoneVCDelegate, AddObservationVCDelegate, AddEmiDetailVCDelegate,
AddAccountLocationVCDelegate, AddContactVCDelegate, AddTicketVCDelegate {

    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "addPartitionsSegue" {
            if let viewController = segue.destinationController as? AddPartitionVC {
                viewController.delegate = self
            }
        } else if segue.identifier == "editPartitionSegue" {
            if let viewController = segue.destinationController as? AddPartitionVC {
                viewController.delegate = self
                viewController.editButtonPressed = true
            }
        } else if segue.identifier == "addZonesSegue" {
            if let viewController = segue.destinationController as? AddZoneVC {
                viewController.delegate = self
            }
        } else if segue.identifier == "editZoneSegue" {
            if let viewController = segue.destinationController as? AddZoneVC {
                viewController.delegate = self
                viewController.editButtonPressed = true
            }
        } else if segue.identifier == "addObservationSegue" {
            if let viewController = segue.destinationController as? AddObservationVC {
                viewController.delegate = self
            }
        } else if segue.identifier == "editObservationSegue" {
            if let viewController = segue.destinationController as? AddObservationVC {
                viewController.delegate = self
                viewController.editButtonPressed  = true
            }
        } else if segue.identifier == "addEmiDetailsSegue" {
            if let viewController = segue.destinationController as? AddEmiDetailVC {
                viewController.delegate = self
            }
        } else if segue.identifier == "editEmiDetailsSegue" {
            if let viewController = segue.destinationController as? AddEmiDetailVC {
                viewController.delegate = self
                viewController.editButtonPressed = true
            }
        } else if segue.identifier == "addContactSegue" {
            if let viewController = segue.destinationController as? AddContactVC {
                viewController.delegate = self
            }
        } else if segue.identifier == "editContactSegue" {
            if let viewController = segue.destinationController as? AddContactVC {
                viewController.delegate = self
                viewController.editButtonWasPressed = true
            }
        } else if segue.identifier == "addTicketSegue" {
            if let viewController = segue.destinationController as? AddTicketVC {
                viewController.delegate = self
            }
        } else if segue.identifier == "editTicketSegue" {
            if let viewController = segue.destinationController as? AddTicketVC {
                viewController.delegate = self
                viewController.editButtonPresed = true
            }
        } else if segue.identifier == "addAccountLocationSegue" {
            if let viewController = segue.destinationController as? AddAccountLocationVC {
                viewController.delegate = self
            }
        }
    }

    func addPartition(number: Int, name: String) {
        storeAccount.storePartition(number: number, name: name)
    }
    func addZone(number: Int, name: String) {
        storeAccount.storeZone(partitionNumber: partirionsTableViewSelectedRow, newZoneNumber: number, newZoneName: name)
    }
    func addObservation(observation: String) {
        storeAccount.storeObservation(observation: observation)
    }
    func addEmiDetail(detail: String) {
        storeAccount.storeEmiDetail(emiDetail: detail)
    }
    func addTicket(manager: String, type: String, status: String, content: String) {
        storeAccount.storeTicket(manager: manager, type: type, status: status, content: content)
    }
    func addContact(priority: Int16, name: String, UserNr: Int16, postion: String, phoneNr: String, email: String, observation: String) {
        storeAccount.storeContact(priority: priority, name: name, userNumber: UserNr, position: postion, phoneNumber: phoneNr, email: email, observations: observation)
    }
    
    func getPartition() -> PartitionEntity {
        return storeAccount.getPartition(selectedPartition: partirionsTableViewSelectedRow)
    }
    func getZone() -> ZoneEntity {
        return storeAccount.getZone(selectedPartition: partirionsTableViewSelectedRow, selectedZone: zonesTableViewselectedRow)
    }
    func getObservation() -> ObservationsEntity {
        return storeAccount.getObservation(selectedObservation: observationsTableViewselectedRow)
    }
    func getEmiDetail() -> EmiDetailesEntity {
        return storeAccount.getEmiDetail(selectedEmiDetailIndex: emiDetailsTableViewselectedRow)
    }
    func getContact() -> ContactEntity {
        return storeAccount.getContact(selectedContact: contactsTableViewSelectedRow)
    }
    func getTicket() -> TicketEntity {
        return storeAccount.getTicket(selectedTicket: ticketsTableViewSelectedRow)
    }
    func getManagersList() -> [ManagerEntity] {
        return storeAccount.getManagers()
    }
    
    func reloadPartitionsTableView() {
        partitionsTableView.reloadData()
    }
    func reloadZonesTableView() {
        zonesTableView.reloadData()
    }
    func reloadObservationsTableView() {
        observationsTableView.reloadData()
    }
    func reloadEmiDetailsTableView() {
        emiDetailsTableView.reloadData()
    }
    func reloadTicketsTableView() {
        ticketsTableView.reloadData()
    }
    func reloadContactstableView() {
        contactsTableView.reloadData()
    }
    
    func addLocation(longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
        self.longitudeTextField.stringValue = String(longitude)
        self.latitudeTextField.stringValue = String(latitude)
    }
}

extension AddAccountViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    func reloadTablesViewData() {
        scheduleTableView.reloadData()
        partitionsTableView.reloadData()
        zonesTableView.reloadData()
        observationsTableView.reloadData()
        emiDetailsTableView.reloadData()
        ticketsTableView.reloadData()
        contactsTableView.reloadData()
    }
    
    func tableViewInit() {
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        partitionsTableView.delegate = self
        partitionsTableView.dataSource = self
        zonesTableView.delegate = self
        zonesTableView.dataSource = self
        emiDetailsTableView.delegate = self
        emiDetailsTableView.dataSource = self
        observationsTableView.delegate = self
        observationsTableView.dataSource = self
        ticketsTableView.delegate = self
        ticketsTableView.dataSource = self
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let tableViewSelected = notification.object as! NSTableView
        if tableViewSelected == scheduleTableView {
            //tableViewSelectedRow = scheduleTableView.selectedRow
        } else if tableViewSelected == partitionsTableView {
            guard tableViewSelected.selectedRow == -1 else {
                partirionsTableViewSelectedRow = partitionsTableView.selectedRow
                let partitions = storeAccount.account!.partitions!.sortedArray(using: [numberSortDescriptor]) as! [PartitionEntity]
                zones = partitions[partirionsTableViewSelectedRow].zones!.sortedArray(using: [numberSortDescriptor]) as! [ZoneEntity]
                zonesTableView.reloadData()
                return
            }
        } else if tableViewSelected == zonesTableView {
            guard tableViewSelected.selectedRow == -1 else {
                return zonesTableViewselectedRow = zonesTableView.selectedRow
            }
        } else if tableViewSelected == contactsTableView {
            guard tableViewSelected.selectedRow == -1 else {
                return contactsTableViewSelectedRow = contactsTableView.selectedRow
            }
        } else if tableViewSelected == emiDetailsTableView {
            guard tableViewSelected.selectedRow == -1 else {
                return emiDetailsTableViewselectedRow = emiDetailsTableView.selectedRow
            }
        } else if tableViewSelected == observationsTableView {
            guard tableViewSelected.selectedRow == -1 else {
                return observationsTableViewselectedRow = observationsTableView.selectedRow
            }
        } else if tableViewSelected == ticketsTableView {
            guard tableViewSelected.selectedRow == -1 else {
                return ticketsTableViewSelectedRow = ticketsTableView.selectedRow
            }
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == scheduleTableView {
            return 7
        } else if tableView == partitionsTableView {
            if let partitions = storeAccount.account?.partitions {
                return partitions.count
            } else {return 0}
        } else if tableView == zonesTableView {
            if let partitions = storeAccount.account?.partitions {
                let sortedPartitions = partitions.sortedArray(using: [numberSortDescriptor]) as! [PartitionEntity]
                guard partitions.count == 0 else {
                    if let zones = sortedPartitions[partirionsTableViewSelectedRow].zones {
                        return zones.count
                    } else {return 0}
                }
            } else {return 0}
        } else if tableView == contactsTableView {
            if let contacts = storeAccount.account?.contacts {
                return contacts.count
            } else {return 0}
        } else if tableView == emiDetailsTableView {
            if let emiDetails = storeAccount.account?.emiDetails {
                return emiDetails.count
            } else {return 0}
        } else if tableView == observationsTableView {
            if let observations = storeAccount.account?.observations {
                return observations.count
            } else {return 0}
        } else if tableView == ticketsTableView {
            if let tickets = storeAccount.account?.tickets {
                return tickets.count
            } else {return 0}
        }
        return 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        func generateCell(identifier: String, value: String) -> NSTableCellView {
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: identifier), owner: self) as! NSTableCellView
            cell.textField?.stringValue = value
            return cell
        }

        if tableView == scheduleTableView {
            let weekDays = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"]
            if tableColumn?.identifier.rawValue == "dayColumn" {
                return generateCell(identifier: "dayCell", value: weekDays[row])
            }
            if let schedule = storeAccount.account!.schedeule {
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
        } else if tableView == partitionsTableView {
            if let partitions = storeAccount.account!.partitions {
                let sortedPartitions = partitions.sortedArray(using: [numberSortDescriptor]) as! [PartitionEntity]
                let partition = sortedPartitions[row]
                if tableColumn?.identifier.rawValue == "partitionsTableNumberColumn"{
                    return generateCell(identifier: "partitionTableNumberCell", value: String(partition.number))
                }
                if tableColumn?.identifier.rawValue == "partitionTableNamesColumn"{
                    return generateCell(identifier: "partitionTableNameCell", value: partition.name!)
                }
            }
        } else if tableView == zonesTableView {
            if let partitions = storeAccount.account!.partitions {
                let sortedPartitions = partitions.sortedArray(using: [numberSortDescriptor]) as! [PartitionEntity]
                let selectedPartition = sortedPartitions[partirionsTableViewSelectedRow]
                if let selectedZones = selectedPartition.zones {
                    zones = selectedZones.sortedArray(using: [numberSortDescriptor]) as! [ZoneEntity]
                    let zone = zones[row]
                    
                    if tableColumn?.identifier.rawValue == "zonesTableNumberColumn"{
                        return generateCell(identifier: "zonesTableNumberCell", value: String(zone.number))
                    }
                    if tableColumn?.identifier.rawValue == "zonesTableNamesColumn"{
                        return generateCell(identifier: "zonesTableNameCell", value: zone.name!)
                    }
                }
            }
        }  else if tableView == contactsTableView {
            if let contacts = storeAccount.account!.contacts {
                let sortedContacts = contacts.sortedArray(using: [priorityDescriptor]) as! [ContactEntity]
                let contact = sortedContacts[row]
                
                if tableColumn?.identifier.rawValue == "contactsPriorityColumn" {
                    return generateCell(identifier: "contactsPriorityCell", value: String(contact.priority))
                }
                if tableColumn?.identifier.rawValue == "contactsUsersColumn" {
                    return generateCell(identifier: "contactsUsersCell", value: contact.name!)
                }
                if tableColumn?.identifier.rawValue == "contactsUserNumberColumn" {
                    return generateCell(identifier: "contactsUserNumberCell", value: String(contact.userNumber))
                }
                if tableColumn?.identifier.rawValue == "contactsPositionColumn" {
                    return generateCell(identifier: "contactsPositionCell", value: contact.position!)
                }
                if tableColumn?.identifier.rawValue == "contactsPhoneNumberColumn" {
                    return generateCell(identifier: "contactsPhoneNumberCell", value: contact.phoneNumber!)
                }
                if tableColumn?.identifier.rawValue == "contactsEmailColumn" {
                    return generateCell(identifier: "contactsEmailCell", value: contact.email!)
                }
                if tableColumn?.identifier.rawValue == "contactsObservationsColumn" {
                    return generateCell(identifier: "contactsObservationsCell", value: contact.observations!)
                }
            }
        } else if tableView == emiDetailsTableView {
            if let emiDetails = storeAccount.account?.emiDetails {
                let sortedEmiDetails = emiDetails.sortedArray(using: [dateSortDescriptor]) as! [EmiDetailesEntity]
                let emiDetail = sortedEmiDetails[row]
                
                if tableColumn?.identifier.rawValue == "emiDetailsDatesColumn"{
                    return generateCell(identifier: "emiDetailsDatesCell", value: dateFormater.string(from: emiDetail.date! as Date))
                }
                if tableColumn?.identifier.rawValue == "emiDetailsUsersColumn"{
                    return generateCell(identifier: "emiDetailsUsersCell", value: emiDetail.user!)
                }
                if tableColumn?.identifier.rawValue == "emiDetailsDetailsColumn"{
                    return generateCell(identifier: "emiDetailsDetailsCell", value: emiDetail.detailes!)
                }
            }
        } else if tableView == observationsTableView {
            if let observations = storeAccount.account!.observations {
                let sortedObservations = observations.sortedArray(using: [dateSortDescriptor]) as! [ObservationsEntity]
                let observation = sortedObservations[row]
                
                if tableColumn?.identifier.rawValue == "observationsDatesColumn"{
                    return generateCell(identifier: "observationsDatesCell", value: dateFormater.string(from: observation.date! as Date))
                }
                if tableColumn?.identifier.rawValue == "observationsUsersColumn"{
                    return generateCell(identifier: "observationsUsersCell", value: observation.user!)
                }
                if tableColumn?.identifier.rawValue == "observationsObservationsColumn"{
                    return generateCell(identifier: "observationsObservationsCell", value: observation.observation!)
                }
            }
        } else if tableView == ticketsTableView {
            if let tickets = storeAccount.account!.tickets {
                let sortedTickets = tickets.sortedArray(using: [dateSortDescriptor]) as! [TicketEntity]
                let ticket = sortedTickets[row]
                
                if tableColumn?.identifier.rawValue == "ticketsDateColumn" {
                    return generateCell(identifier: "ticketsDateCell", value: dateFormater.string(from: ticket.date! as Date))
                }
                if tableColumn?.identifier.rawValue == "ticketsNumberColumn" {
                    return generateCell(identifier: "ticketsNumberCell", value: String(ticket.number))
                }
                if tableColumn?.identifier.rawValue == "ticketsUserColumn" {
                    return generateCell(identifier: "ticketsUserCell", value: ticket.user!)
                }
                if tableColumn?.identifier.rawValue == "ticketsManagerColumn" {
                    return generateCell(identifier: "ticketsManagerCell", value: ticket.manager!)
                }
                if tableColumn?.identifier.rawValue == "ticketsTypeColumn" {
                    return generateCell(identifier: "ticketsTypeCell", value: ticket.type!)
                }
                if tableColumn?.identifier.rawValue == "ticketsStatusColum" {
                    return generateCell(identifier: "ticketsStatusCell", value: ticket.status!)
                }
                if tableColumn?.identifier.rawValue == "ticketsContentColumn" {
                    return generateCell(identifier: "ticketsContentCell", value: ticket.details!)
                }
            }
        }
        return NSTableCellView()
    }
}
