//
//  BlackListEntity+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 19/02/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension BlackListEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BlackListEntity> {
        return NSFetchRequest<BlackListEntity>(entityName: "BlackListEntity")
    }

    @NSManaged public var accountId: String?
    @NSManaged public var reason: String?

}
