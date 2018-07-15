//
//  ProductListCell.swift
//  ProductBrowser
//
//  Created by Babu Gangatharan on 7/14/18.
//  Copyright © 2018 Babu Gangatharan. All rights reserved.
//

import UIKit
import Foundation
import SDWebImage
import CoreData

class ProductListCell: UITableViewCell {
	
	//MARK: Outlets
	
	@IBOutlet weak var productImage: UIImageView!
	@IBOutlet weak var title: UILabel!
	
	//MARK: Static
	
	static let identifier = "ProductListCell"
	
	//MARK: Functions
	
	/**
	Configure Cell
	- parameters:
	- item: Item object
	*/
	
	func configureCell(for item: Item) {
		title.text = item.name
		productImage.sd_setImage(with: item.url)
	}
	
}
