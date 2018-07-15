//
//  ServiceManager.swift
//  ProductBrowser
//
//  Created by Babu Gangatharan on 7/14/18.
//  Copyright © 2018 Babu Gangatharan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public typealias ProductListResponse = (NSError?, Bool) -> ()

class ServiceManager {
	
	static let shared = ServiceManager()
	
	func getProductList(completion onCompletion: @escaping ProductListResponse) -> Void {
		let productListUrl = "https://gist.githubusercontent.com/anonymous/a3b3e50413fff111505a/raw/0522419f508e7ea506a8856586dce11a5664e9df/products.json"
		
		guard let url = NSURL(string: productListUrl) else {
			return
		}
		
		let searchTask = URLSession.shared.dataTask(with: url as URL, completionHandler: { data, response, error  in
			
			if error != nil {
				print("Error: \(error.debugDescription)")
				return
			}
			
			do {
				guard let results = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String: AnyObject]], results.count > 0 else { return }
				
				try CoreDataManager.shared.clean()
				
				results.forEach { item in
					let product = Product(object: item)
					CoreDataManager.shared.saveData(with: product)
				}
				
				onCompletion(nil, true)
			}
			catch let error as NSError {
				print("Error parsing JSON: \(error)")
				return
			}
			
		})
		searchTask.resume()
	}
}
