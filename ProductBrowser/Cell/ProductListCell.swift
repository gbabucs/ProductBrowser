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
	
	
}

extension ProductListCell: Cell {
	
	func configure(for item: Item) {
		self.title.text = item.name
		self.productImage.sd_setImage(with: item.url) { (image, error, cache, urls) in
			if (error != nil) {
				self.productImage.image = UIImage(named: "Placeholder")
			} else {
				self.productImage.image = image
			}
		}
	}
}
