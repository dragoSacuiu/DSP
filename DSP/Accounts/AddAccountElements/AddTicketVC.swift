//
//  AddTicketVC.swift
//  DSP
//
//  Created by Sacuiu Dragos on 22/02/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//

import Cocoa

protocol AddTicketVCDelegate {
    func addTicket(manager: String, type: String, status: String, content: String)
    func getTicket() -> TicketEntity
    func getManagersList() -> [ManagerEntity]
    func reloadTicketsTableView()
}

class AddTicketVC: NSViewController {
    var delegate: AddTicketVCDelegate?
    
    var ticket: TicketEntity?
    var ticketTypes = ["MESSAGE","COMPLAINT"]
    var managers: [ManagerEntity]?
    
    var editButtonPresed = false

    @IBOutlet weak var selectManagerPopUpButton: NSPopUpButton!
    @IBOutlet weak var selectTypePopUpButton: NSPopUpButton!
    @IBOutlet weak var ticketTextField: NSTextField!
    @IBOutlet weak var addTcicketButtonOutlet: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectTypePopUpButton.addItems(withTitles: ticketTypes)
        managers = delegate!.getManagersList()
        for manager in managers! {
            selectManagerPopUpButton.addItem(withTitle: manager.name!)
        }
        if editButtonPresed {
            ticket = delegate!.getTicket()
            addTcicketButtonOutlet.title = "SAVE"
            ticketTextField.stringValue = ticket!.content!
            for manager in managers! {
                if manager.name! == ticket!.manager! {
                    selectManagerPopUpButton.title = manager.name!
                    break
                }
            }
            for ticketType in ticketTypes {
                if ticketType == ticket?.type {
                    selectTypePopUpButton.title = ticketType
                }
            }
        }
    }
    override func viewDidAppear() {
        view.window!.styleMask.remove(.resizable)
    }
    
    @IBAction func addTicketButton(_ sender: NSButton) {
        if editButtonPresed {
            ticket?.manager = selectManagerPopUpButton.titleOfSelectedItem
            ticket?.type = selectTypePopUpButton.titleOfSelectedItem
            ticket?.content = ticketTextField.stringValue
        } else {
            delegate?.addTicket(manager: selectManagerPopUpButton.titleOfSelectedItem!, type: selectTypePopUpButton.titleOfSelectedItem!,
                                status: "OPEN", content: ticketTextField.stringValue)
            clearFields()
        }
        delegate?.reloadTicketsTableView()
    }
    func clearFields() {
        selectManagerPopUpButton.title = selectManagerPopUpButton.itemTitle(at: 0)
        selectTypePopUpButton.title = selectTypePopUpButton.itemTitle(at: 0)
        ticketTextField.stringValue = ""
    }
}
