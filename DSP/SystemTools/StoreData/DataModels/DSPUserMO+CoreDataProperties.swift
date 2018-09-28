//
//  DSPUserMO+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension DSPUserMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DSPUserMO> {
        return NSFetchRequest<DSPUserMO>(entityName: "DSPUserMO")
    }

    @NSManaged public var name: String?
    @NSManaged public var password: String?

}
