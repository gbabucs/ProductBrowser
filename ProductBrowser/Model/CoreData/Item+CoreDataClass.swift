//
//  Item+CoreDataClass.swift
//  
//
//  Created by Babu G on 7/15/18.
//
//

import Foundation
import CoreData

public class Item: NSManagedObject {
	
	public var url: URL? {
		return URL(string: self.image_url ?? "")
	}

}
