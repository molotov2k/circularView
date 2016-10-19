//
//  Item+CoreDataProperties.swift
//  Youplus
//
//  Created by Astarta on 10/16/16.
//  Copyright © 2016 Anvil. All rights reserved.
//

import Foundation
import CoreData

extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item");
    }

    @NSManaged public var name: String
    @NSManaged public var originalPrice: Double
    @NSManaged public var image: NSData?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var type: Type?

}
