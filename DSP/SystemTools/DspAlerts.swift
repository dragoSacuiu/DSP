//
//  DspAlerts.swift
//  DSP
//
//  Created by Sacuiu Dragos on 10/02/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//

import Foundation
import Cocoa

class DspAlert {
    func showAlert(message: String) {
        let alert = NSAlert()
        alert.messageText = message
        alert.runModal()
    }
}

