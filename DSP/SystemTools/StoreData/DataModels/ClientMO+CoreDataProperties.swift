//
//  ClientMO+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension ClientMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ClientMO> {
        return NSFetchRequest<ClientMO>(entityName: "ClientMO")
    }

    @NSManaged public var name: String?
    @NSManaged public var objective: ObjectiveMO?

}
