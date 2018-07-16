//
//  Item+CoreDataProperties.swift
//  
//
//  Created by Babu G on 7/15/18.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var itemDescription: String?
    @NSManaged public var image_url: String?
    @NSManaged public var items_remaining: Int16
    @NSManaged public var category: String?
    @NSManaged public var name: String?

}
