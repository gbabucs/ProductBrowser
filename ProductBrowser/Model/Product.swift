//
//  Product.swift
//
//  Created by Babu Gangatharan on 7/14/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class Product: NSCoding {
	
	// MARK: Declaration for string constants to be used to decode and also serialize.
	private struct SerializationKeys {
		static let descriptionValue = "description"
		static let name = "name"
		static let itemsRemaining = "items_remaining"
		static let imageUrl = "image_url"
		static let category = "category"
	}
	
	// MARK: Properties
	public var descriptionValue: String?
	public var name: String?
	public var itemsRemaining: Int?
	public var imageUrl: String?
	public var category: String?
	
	public var url: URL? {
		return URL(string: imageUrl ?? "")
	}
	
	
	// MARK: SwiftyJSON Initializers
	/// Initiates the instance based on the object.
	///
	/// - parameter object: The object of either Dictionary or Array kind that was passed.
	/// - returns: An initialized instance of the class.
	public convenience init(object: Any) {
		self.init(json: JSON(object))
	}
	
	/// Initiates the instance based on the JSON that was passed.
	///
	/// - parameter json: JSON object from SwiftyJSON.
	public required init(json: JSON) {
		descriptionValue = json[SerializationKeys.descriptionValue].string
		name = json[SerializationKeys.name].string
		itemsRemaining = json[SerializationKeys.itemsRemaining].int
		imageUrl = json[SerializationKeys.imageUrl].string
		category = json[SerializationKeys.category].string
	}
	
	/// Generates description of the object in the form of a NSDictionary.
	///
	/// - returns: A Key value pair containing all valid values in the object.
	public func dictionaryRepresentation() -> [String: Any] {
		var dictionary: [String: Any] = [:]
		if let value = descriptionValue { dictionary[SerializationKeys.descriptionValue] = value }
		if let value = name { dictionary[SerializationKeys.name] = value }
		if let value = itemsRemaining { dictionary[SerializationKeys.itemsRemaining] = value }
		if let value = imageUrl { dictionary[SerializationKeys.imageUrl] = value }
		if let value = category { dictionary[SerializationKeys.category] = value }
		return dictionary
	}
	
	// MARK: NSCoding Protocol
	required public init(coder aDecoder: NSCoder) {
		self.descriptionValue = aDecoder.decodeObject(forKey: SerializationKeys.descriptionValue) as? String
		self.name = aDecoder.decodeObject(forKey: SerializationKeys.name) as? String
		self.itemsRemaining = aDecoder.decodeObject(forKey: SerializationKeys.itemsRemaining) as? Int
		self.imageUrl = aDecoder.decodeObject(forKey: SerializationKeys.imageUrl) as? String
		self.category = aDecoder.decodeObject(forKey: SerializationKeys.category) as? String
	}
	
	public func encode(with aCoder: NSCoder) {
		aCoder.encode(descriptionValue, forKey: SerializationKeys.descriptionValue)
		aCoder.encode(name, forKey: SerializationKeys.name)
		aCoder.encode(itemsRemaining, forKey: SerializationKeys.itemsRemaining)
		aCoder.encode(imageUrl, forKey: SerializationKeys.imageUrl)
		aCoder.encode(category, forKey: SerializationKeys.category)
	}
	
}
