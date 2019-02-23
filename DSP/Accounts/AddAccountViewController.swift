//
//  AddAccountViewController.swift
//  DSP
//
//  Created by Sacuiu Dragos on 28/11/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Cocoa

class AddAccountViewController: NSViewController {
    
    let storeData = StoreData()
    let dateFormater = DateFormatter()
    let dspAlert = DspAlert()
    
    var account: AccountEntity?
    var zones = [ZoneEntity]()
    
    let numberSortDescriptor = NSSortDescriptor(key: "number", ascending: true)
    let dateSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
    let priorityDescriptor = NSSortDescriptor(key: "priority", ascending: true)
    
    var partirionsTableViewSelectedRow = 0
    var zonesTableViewselectedRow = 0
    var contactsTableViewSelectedRow = 0
    var emiDetailsTableViewselectedRow = 0
    var observationsTableViewselectedRow = 0
    var ticketsTableViewSelectedRow = 0

    @IBOutlet weak var accountId: NSTextField!
    @IBOutlet weak var objective: NSTextField!
    @IBOutlet weak var client: NSTextField!
    @IBOutlet weak var type: NSTextField!
    @IBOutlet weak var sales: NSTextField!
    @IBOutlet weak var contract: NSTextField!
    @IBOutlet weak var street: NSTextField!
    @IBOutlet weak var building: NSTextField!
    @IBOutlet weak var county: NSTextField!
    @IBOutlet weak var city: NSTextField!
    @IBOutlet weak var technic: NSTextField!
    @IBOutlet weak var system: NSTextField!
    @IBOutlet weak var comunicator: NSTextField!
    @IBOutlet weak var longitude: NSTextField!
    @IBOutlet weak var latitude: NSTextField!
    
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
        storeData.createNewAccount()
        tableViewInit()
        
        dateFormater.timeStyle = .short
        dateFormater.dateStyle = .short
    }
    
    func createAccount() {
        if accoutIsValid() {
            let periodicTest = getPeriodicTest()
            account!.id = accountId.stringValue; account!.objective = objective.stringValue; account!.client = client.stringValue; account!.type = type.stringValue; account!.sales = sales.stringValue
            account!.contract = contract.stringValue; account!.adress1 = street.stringValue; account!.adress2 = building.stringValue; account!.county = county.stringValue; account!.city = city.stringValue; account!.technic = technic.stringValue
            account!.system = system.stringValue; account!.comunicator = comunicator.stringValue; account!.longitude = longitude.stringValue; account!.latitude = latitude.stringValue; account!.periodicTest = periodicTest
        }
    }
    
    @IBAction func saveAccountButton(_ sender: NSButton) {
        createAccount()
        
    }
    
    @IBAction func searchButton(_ sender: NSButton) {
        storeData.createExistingAccount(accountID: accountId.stringValue)
        if account != nil {
            displayAccount()
        }
    }
    
    @IBAction func deleteAccountButton(_ sender: NSButton) {
        
        clearFields()
    }
    
    @IBAction func copyAccountButton(_ sender: NSButton) {
        
    }
    
    @IBAction func pasteAccountButton(_ sender: NSButton) {

    }
    
    @IBAction func addScheduleButton(_ sender: NSButton) {
        let daySelected = daySelector.titleOfSelectedItem!
        let startTime = dateFormater.string(from: startTimePicker.dateValue).components(separatedBy: " ")[1]
        let endTime = dateFormater.string(from: endTimePicker.dateValue).components(separatedBy: " ")[1]
        storeData.storeSchedule(day: daySelected, startTime: startTime, endTime: endTime)
        scheduleTableView.reloadData()
    }
    
    func getPeriodicTest() -> String {
        let periodicTestOutlets = [test24HOutlet, test12HOutlet, test6HOutlet, test3HOutlet]
        var selectedPeriodicTestValue: NSButton?
        for periodicTestOutlet in periodicTestOutlets {
            if periodicTestOutlet!.state == .on {
                selectedPeriodicTestValue = periodicTestOutlet
                break
            } else {
                print("No periodic test selected")
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
            return ""
        }
    }
    
    func selectPeriodicTest(periodicTest: String) {
        let periodicTestOutlets = [test24HOutlet, test12HOutlet, test6HOutlet, test3HOutlet]
        for test in periodicTestOutlets {
            if test?.title == periodicTest {
                test?.state = .on
            }
        }
    }
    
    func displayAccount() {
        objective.stringValue = account!.objective!
        client.stringValue = account!.client!
        type.stringValue = account!.type!
        sales.stringValue = account!.sales!
        contract.stringValue = account!.contract!
        street.stringValue = account!.adress1!
        building.stringValue = account!.adress2!
        county.stringValue = account!.county!
        city.stringValue = account!.city!
        technic.stringValue = account!.technic!
        system.stringValue = account!.system!
        comunicator.stringValue = account!.comunicator!
        longitude.stringValue = account!.longitude!
        latitude.stringValue = account!.longitude!
        selectPeriodicTest(periodicTest: account!.periodicTest!)
    }
    
    func accoutIsValid() -> Bool {
        guard accountIdIsValid() else {
            guard allFieldsAreFill() else {
                return false
            }
            return false
        }
        return true
    }
    
    func accountIdIsValid() -> Bool {
        let validIdCharacters = "0123456789ABCDEF"
        for char in accountId.stringValue {
            guard validIdCharacters.contains(char) && accountId.stringValue.count == 4 else {
                dspAlert.showAlert(message: "Invalid Account ID: \(accountId.stringValue) \nID must contain 4 of these characters: \(validIdCharacters)")
                return false
            }
        }
        return true
    }
    
    func allFieldsAreFill() -> Bool {
        let textFields = [objective,client,type,sales,contract,street,building,county,city,technic,system,comunicator,longitude,latitude]
        for textField in textFields {
            guard textField?.stringValue != "" else {
                dspAlert.showAlert(message: "Please fill all fields!")
                return false
            }
        }
        return true
    }
    
    func clearFields() {
        let textFields = [objective,client,type,sales,contract,street,building,county,city,technic,system,comunicator,longitude,latitude]
        for textField in textFields {
            textField?.stringValue = ""
        }
    }
}

extension AddAccountViewController: AddPartitionVCDelegate, AddZoneVCDelegate, AddObservationVCDelegate {
    
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
                viewController.editButtonPressed = true
            }
        }
    }

    func addPartition(number: Int, name: String) {
        storeData.storePartition(number: number, name: name)
        partitionsTableView.reloadData()
    }
    
    func getPartition() -> PartitionEntity {
        return storeData.getPartition(selectedPartition: partirionsTableViewSelectedRow)
    }
    
    func addZone(number: Int, name: String) {
        storeData.storeZone(partitionNumber: partirionsTableViewSelectedRow, newZoneNumber: number, newZoneName: name)
        zonesTableView.reloadData()
    }
    
    func getZone() -> ZoneEntity {
        return storeData.getZone(selectedPartition: partirionsTableViewSelectedRow, selectedZone: zonesTableViewselectedRow)
    }
    
    func addObservation(observation: String) {
        storeData.storeObservation(observation: observation)
        observationsTableView.reloadData()
    }
    
    func getObservation() -> String {
        let observations = account?.observations!.sortedArray(using: [dateSortDescriptor]) as! [ObservationsEntity]
        return observations[observationsTableViewselectedRow].observation!
    }
}

extension AddAccountViewController: NSTableViewDataSource, NSTableViewDelegate {
    
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
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let tableViewSelected = notification.object as! NSTableView
        if tableViewSelected == scheduleTableView {
            //tableViewSelectedRow = scheduleTableView.selectedRow
        } else if tableViewSelected == partitionsTableView {
            guard tableViewSelected.selectedRow == -1 else {
                partirionsTableViewSelectedRow = partitionsTableView.selectedRow
                let partitions = storeData.account!.partitions!.sortedArray(using: [numberSortDescriptor]) as! [PartitionEntity]
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
            return storeData.account!.partitions!.sortedArray(using: [numberSortDescriptor]).count
        } else if tableView == zonesTableView {
            let partitions = storeData.account!.partitions!.sortedArray(using: [numberSortDescriptor]) as! [PartitionEntity]
            guard partitions.count == 0 else {
                return partitions[partirionsTableViewSelectedRow].zones!.sortedArray(using: [numberSortDescriptor]).count
            }
        } else if tableView == contactsTableView {
            return storeData.account!.contacts!.sortedArray(using: [priorityDescriptor]).count
        } else if tableView == emiDetailsTableView {
            return storeData.account!.emiDetails!.sortedArray(using: [dateSortDescriptor]).count
        } else if tableView == observationsTableView {
            return storeData.account!.observations!.sortedArray(using: [dateSortDescriptor]).count
        } else if tableView == ticketsTableView {
            return storeData.account!.tickets!.sortedArray(using: [dateSortDescriptor]).count
        }
        return 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cell = NSTableCellView()
        
        func generateCell(identifier: String, value: String) -> NSTableCellView {
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: identifier), owner: self) as! NSTableCellView
            cell.textField?.stringValue = value
            return cell
        }

        if tableView == scheduleTableView {
            let weekDays = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"]
            let schedule = storeData.account!.schedeule!
            let dayTimes = [schedule.monday, schedule.tuesday, schedule.wednesday, schedule.thursday, schedule.friday, schedule.saturday, schedule.sunday]
            
            if tableColumn?.identifier.rawValue == "dayColumn" {
                return generateCell(identifier: "dayCell", value: weekDays[row])
            }
            if dayTimes[row]! != "" {
                let startTime = dayTimes[row]!.components(separatedBy: " ")[0]
                let endTime = dayTimes[row]!.components(separatedBy: " ")[1]
                
                if tableColumn?.identifier.rawValue == "openColumn" {
                    return generateCell(identifier: "openCell", value: startTime)
                } else if tableColumn?.identifier.rawValue == "closedColumn" {
                    return generateCell(identifier: "closedCell", value: endTime)
                }
            }
        } else if tableView == partitionsTableView {
            let partitions = storeData.account!.partitions!.sortedArray(using: [numberSortDescriptor]) as! [PartitionEntity]
            let partition = partitions[row]
            if tableColumn?.identifier.rawValue == "partitionsTableNumberColumn"{
                return generateCell(identifier: "partitionTableNumberCell", value: String(partition.number))
            }
            if tableColumn?.identifier.rawValue == "partitionTableNamesColumn"{
                return generateCell(identifier: "partitionTableNameCell", value: partition.name!)
            }
        } else if tableView == zonesTableView {
            let partitions = storeData.account!.partitions!.sortedArray(using: [numberSortDescriptor]) as! [PartitionEntity]
            let selectedPartition = partitions[partirionsTableViewSelectedRow]
            zones = selectedPartition.zones!.sortedArray(using: [numberSortDescriptor]) as! [ZoneEntity]
            let zone = zones[row]
            
            if tableColumn?.identifier.rawValue == "zonesTableNumberColumn"{
                return generateCell(identifier: "zonesTableNumberCell", value: String(zone.number))
            }
            if tableColumn?.identifier.rawValue == "zonesTableNamesColumn"{
                return generateCell(identifier: "zonesTableNameCell", value: zone.name!)
            }
        }  else if tableView == contactsTableView {
            let contacts = storeData.account!.contacts!.sortedArray(using: [priorityDescriptor]) as! [ContactEntity]
            if tableColumn?.identifier.rawValue == "contactsPriorityColumn" {
                return generateCell(identifier: "contactsPriorityCell", value: String(contacts[row].priority))
            }
            if tableColumn?.identifier.rawValue == "contactsUsersColumn" {
                return generateCell(identifier: "contactsUsersCell", value: contacts[row].name!)
            }
            if tableColumn?.identifier.rawValue == "contactsUserNumberColumn" {
                return generateCell(identifier: "contactsUserNumberCell", value: String(contacts[row].userNumber))
            }
            if tableColumn?.identifier.rawValue == "contactsPositionColumn" {
                return generateCell(identifier: "contactsPositionCell", value: contacts[row].position!)
            }
            if tableColumn?.identifier.rawValue == "contactsPhoneNumberColumn" {
                return generateCell(identifier: "contactsPhoneNumberCell", value: contacts[row].phoneNumber!)
            }
            if tableColumn?.identifier.rawValue == "contactsEmailColumn" {
                return generateCell(identifier: "contactsEmailCell", value: contacts[row].email!)
            }
            if tableColumn?.identifier.rawValue == "contactsObservationsColumn" {
                return generateCell(identifier: "contactsObservationsCell", value: contacts[row].observations!)
            }
        } else if tableView == emiDetailsTableView {
            let emiDetail = account?.emiDetails?.sortedArray(using: [dateSortDescriptor])[row] as! EmiDetailesEntity
        
            if tableColumn?.identifier.rawValue == "emiDetailesDateColumn"{
                return generateCell(identifier: "emiDetailesDateCell", value: dateFormater.string(from: emiDetail.date! as Date))
            }
            if tableColumn?.identifier.rawValue == "emiDetailesUsersColumn"{
                return generateCell(identifier: "emiDetailesUserCell", value: emiDetail.user!)
            }
            if tableColumn?.identifier.rawValue == "emiDetailesEmiDetailesColumn"{
                return generateCell(identifier: "emiDetailesEmiDetailCell", value: emiDetail.detailes!)
            }
        } else if tableView == observationsTableView {
            let observations = storeData.account!.observations!.sortedArray(using: [dateSortDescriptor]) as! [ObservationsEntity]
            let observation = observations[row]
        
            if tableColumn?.identifier.rawValue == "observationsDateColumn"{
                return generateCell(identifier: "observationsDateCell", value: dateFormater.string(from: observation.date! as Date))
            }
            if tableColumn?.identifier.rawValue == "observationsUserColumn"{
                return generateCell(identifier: "observationsUserCell", value: observation.user!)
            }
            if tableColumn?.identifier.rawValue == "observationsObservationsColumn"{
                return generateCell(identifier: "observationsObservationsCell", value: "aiurea")
            }
        } else if tableView == ticketsTableView {
            let tickets = storeData.account!.tickets!.sortedArray(using: [dateSortDescriptor]) as! [TicketEntity]
            
            if tableColumn?.identifier.rawValue == "ticketsDateColumn" {
                return generateCell(identifier: "ticketsDateCell", value: dateFormater.string(from: tickets[row].date! as Date))
            }
            if tableColumn?.identifier.rawValue == "ticketsUserColumn" {
                return generateCell(identifier: "ticketsUserCell", value: tickets[row].user!)
            }
            if tableColumn?.identifier.rawValue == "ticketsManagerColumn" {
                return generateCell(identifier: "ticketsManagerCell", value: tickets[row].manager!)
            }
            if tableColumn?.identifier.rawValue == "ticketsTypeColumn" {
                return generateCell(identifier: "ticketsTypeCell", value: tickets[row].type!)
            }
            if tableColumn?.identifier.rawValue == "ticketsStatusColum" {
                return generateCell(identifier: "ticketsStatusCell", value: tickets[row].status!)
            }
            if tableColumn?.identifier.rawValue == "ticketsContentColumn" {
                return generateCell(identifier: "ticketsContentCell", value: tickets[row].content!)
            }
        }
        return cell
    }
}

