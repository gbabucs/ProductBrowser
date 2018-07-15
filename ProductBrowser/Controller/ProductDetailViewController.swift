//
//  ProductDetailViewController.swift
//  ProductBrowser
//
//  Created by Babu Gangatharan on 7/14/18.
//  Copyright © 2018 Babu Gangatharan. All rights reserved.
//

import UIKit
import SDWebImage

class ProductDetailViewController: UIViewController {
	
	//--------------------------------------------------------------------------
	// MARK: - IBOutlets
	//--------------------------------------------------------------------------
	
	@IBOutlet weak var productImage: UIImageView!
	@IBOutlet weak var productDescription: UITextView!
	@IBOutlet weak var itemName: UILabel!
	
	//--------------------------------------------------------------------------
	// MARK: - Properties
	//--------------------------------------------------------------------------
	
	var item: Item? {
		didSet {
			self.updateView()
		}
	}
	
	//--------------------------------------------------------------------------
	// MARK: - ViewController life cycle
	//--------------------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.title = item?.name
		self.updateView()
    }
	
	//--------------------------------------------------------------------------
	// MARK: - Private functions
	//--------------------------------------------------------------------------
	
	private func updateView() {
		guard isViewLoaded == true, let item = self.item else { return }
		
		self.productImage.sd_setImage(with: item.url)
		self.itemName.text = item.name
		self.productDescription.text = item.itemDescription
	}

}
