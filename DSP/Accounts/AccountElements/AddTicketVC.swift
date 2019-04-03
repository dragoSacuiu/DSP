//
//  AddTicketVC.swift
//  DSP
//
//  Created by Sacuiu Dragos on 22/02/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//

import Cocoa

protocol AddTicketVCDelegate {
    var selectManagerPopUpButton: NSPopUpButton! {get}
    func addTicket(manager: String, type: String, status: String, content: String)
    func getTicket() -> TicketEntity
    func reloadTicketsTableView()
    func save()
}

class AddTicketVC: NSViewController {
    var delegate: AddTicketVCDelegate?
    
    private var ticket: TicketEntity?
    private var ticketTypes = ["MESSAGE","COMPLAINT"]
    
    var editButtonPresed = false

    @IBOutlet weak var selectTypePopUpButton: NSPopUpButton!
    @IBOutlet weak var ticketTextField: NSTextField!
    @IBOutlet weak var addTcicketButtonOutlet: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectTypePopUpButton.addItems(withTitles: ticketTypes)
        if editButtonPresed {
            ticket = delegate!.getTicket()
            addTcicketButtonOutlet.title = "SAVE"
            ticketTextField.stringValue = ticket!.details!
            selectTypePopUpButton.title = ticket!.type!
        }
    }
    override func viewDidAppear() {
        view.window!.styleMask.remove(.resizable)
    }
    
    @IBAction func addTicketButton(_ sender: NSButton) {
        if editButtonPresed {
            ticket?.type = selectTypePopUpButton.titleOfSelectedItem
            ticket?.details = ticketTextField.stringValue
            ticket?.type = selectTypePopUpButton.titleOfSelectedItem
        } else {
            delegate?.addTicket(manager: delegate!.selectManagerPopUpButton.titleOfSelectedItem! ,type: selectTypePopUpButton.titleOfSelectedItem!, status: "OPEN", content: ticketTextField.stringValue)
            clearFields()
        }
        delegate?.save()
        delegate?.reloadTicketsTableView()
    }
    func clearFields() {
        selectTypePopUpButton.title = selectTypePopUpButton.itemTitle(at: 0)
        ticketTextField.stringValue = ""
    }
}
