//
//  ManagerEntity+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 26/02/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension ManagerEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagerEntity> {
        return NSFetchRequest<ManagerEntity>(entityName: "ManagerEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var countys: String?

}
