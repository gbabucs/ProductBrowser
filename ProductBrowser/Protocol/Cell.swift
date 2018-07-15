//
//  Cell.swift
//  ProductBrowser
//
//  Created by Babu G on 7/15/18.
//  Copyright © 2018 Babu Gangatharan. All rights reserved.
//

import Foundation
import CoreData

protocol Cell: class {
	
	static var reuseIdentifier: String { get }
	
	func configure(for item: Item)
}

extension Cell {
	
	static var reuseIdentifier: String {
		return String(describing: self)
	}
	
	func configure(for item: Item) {}
}
