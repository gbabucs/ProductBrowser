//
//  ProductListViewController.swift
//  ProductBrowser
//
//  Created by Babu Gangatharan on 7/13/18.
//  Copyright © 2018 Babu Gangatharan. All rights reserved.
//

import UIKit
import Reachability
import CoreData

class ProductListViewController: UIViewController {
	
	//--------------------------------------------------------------------------
	// MARK: - IBOutlets
	//--------------------------------------------------------------------------
	
    @IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var lastUpdateTime: UILabel!
	@IBOutlet weak var totalItem:UILabel!
	@IBOutlet weak var globalHeader: UIView!
	
	//--------------------------------------------------------------------------
	// MARK: - properties
	//--------------------------------------------------------------------------
	
	let reachability : Reachability! = Reachability()
	
	let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "hh:mm a"
		return formatter
	}()
	
	var timer: Timer!
	
	var products: [Product] = []
	private var selectedItem: Item?
	
	private var results: NSFetchedResultsController<Item>!
	private var fetchRequest: NSFetchRequest<Item>?
	
	private var isReachable: Bool {
		guard reachability.connection != .none else {
			return false
		}
		return true
	}
	
	//--------------------------------------------------------------------------
	// MARK: - ViewController life cycle
	//--------------------------------------------------------------------------
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.setup()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Product List"
		
		if isReachable {
			self.getProductList()
		} else {
			self.showErrorAlert(fot: "No Internet Connection", message: "Please try again later")
		}
		
		self.updateView()
		self.attemptFetch()
		self.retry()
		self.startWatchingReachability()
		self.getTotalNumberOfItems()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showProductDetailScreen", let detailScreenViewController = segue.destination as? ProductDetailViewController {
			
			detailScreenViewController.item = self.selectedItem
		}
	}
	
	//--------------------------------------------------------------------------
	// MARK: - Helper functions
	//--------------------------------------------------------------------------
	
	func startWatchingReachability() {
		NotificationCenter.default.addObserver(self, selector: #selector(ProductListViewController.reachabilityChanged), name: Notification.Name.reachabilityChanged, object: nil)
		try? self.reachability.startNotifier()
	}
	
	@objc func reachabilityChanged() {
		if isReachable {
			self.retry()
		}
	}
	
	//--------------------------------------------------------------------------
	// MARK: - Private functions
	//--------------------------------------------------------------------------
	
	@objc private func getProductList() {
		if isReachable {
			UIApplication.shared.isNetworkActivityIndicatorVisible = true
			ServiceManager.shared.getProductList(completion: { (error, success) -> Void in
				if success == true {
					DispatchQueue.main.async {
						UIApplication.shared.isNetworkActivityIndicatorVisible = false
						self.updateTimeStamp()
					}
				}
			})
		} else {
			timer.invalidate()
		}
	}
	
	private func setup() {
		if self.fetchRequest == nil {
			let resultsFetchRequest = NSFetchRequest<Item>(entityName: "Item")
		
			self.fetchRequest = resultsFetchRequest
			self.fetchRequest?.returnsDistinctResults = true
		}
		
		self.fetchRequest?.sortDescriptors = [
			NSSortDescriptor(key: "itemDescription", ascending: false),
		]
		
		if self.results == nil, let request = self.fetchRequest {
			let context = CoreDataManager.shared.persistentContainer.viewContext
				self.results = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
				self.results.delegate = self
		}
		
		self.attemptFetch()
	}
	
	private func updateView() {
		self.globalHeader.layer.borderWidth = 2.0
		self.globalHeader.layer.borderColor = UIColor.black.cgColor
	}
	
	private func attemptFetch() {
		guard isViewLoaded else { return }
		try? self.results.performFetch()
		
		DispatchQueue.main.async {
			self.tableView?.reloadData()
			self.getTotalNumberOfItems()
		}
	}
	
	private func retry() {
		timer = Timer.scheduledTimer(timeInterval: 300.0, target: self, selector: #selector(ProductListViewController.getProductList), userInfo: nil, repeats: true)
	}
	
	private func updateTimeStamp() {
		// update "last updated" title for refresh control
		let now = Date()
		let updateString = "Last Updated at " + self.dateFormatter.string(from: now)
		
		self.lastUpdateTime.text = updateString
	}
	
	private func getTotalNumberOfItems() {
		guard let results = self.results.fetchedObjects else { return }
		
		DispatchQueue.main.async {
			self.totalItem.text = "Total Items in the list: \(results.count )"
		}
	}
	
	private func showErrorAlert(fot title: String, message: String) {
		let alertController = UIAlertController(title: title , message: message , preferredStyle: .alert)
		let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
		
		alertController.addAction(dismissAction)
		
		self.present(alertController, animated: true, completion: nil)
	}
}

//--------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//--------------------------------------------------------------------------


extension ProductListViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let item = self.results?.object(at: indexPath)
			else { return }
		
		self.selectedItem = item
		
		performSegue(withIdentifier: "showProductDetailScreen", sender: self)
	}
}

//--------------------------------------------------------------------------
// MARK: - UITableViewDataSource
//--------------------------------------------------------------------------

extension ProductListViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.results.fetchedObjects?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductListCell.reuseIdentifier, for: indexPath) as? ProductListCell else { return UITableViewCell() }
		
		self.update(cell, at: indexPath)
		
		return cell
	}
	
	func update(_ cell: ProductListCell, at indexPath: IndexPath) {
		guard let item = self.results?.object(at: indexPath)
			else { return }
		cell.configure(for: item)
	}
}

//--------------------------------------------------------------------------
// MARK: - NSFetchedResultsControllerDelegate
//--------------------------------------------------------------------------

extension ProductListViewController: NSFetchedResultsControllerDelegate {
	
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
		self.preferredContentSize = CGSize(width: 320.0, height: self.tableView.contentSize.height)
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
		return nil
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		switch (type) {
		case .insert:
			guard let indexPath = newIndexPath else { return }
			self.tableView.insertRows(at: [indexPath], with: .fade)
			break
			
		case .delete:
			guard let indexPath = indexPath else { return }
			self.tableView.deleteRows(at: [indexPath], with: .fade)
			break
			
		case .update:
			if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? ProductListCell {
				self.update(cell, at: indexPath)
			}
			break
			
		case .move:
			if let indexPath = indexPath {
				self.tableView.deleteRows(at: [indexPath], with: .fade)
			}
			
			if let newIndexPath = newIndexPath {
				self.tableView.insertRows(at: [newIndexPath], with: .fade)
			}
			break
			
		}
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
		self.tableView.reloadSections([sectionIndex], with: .fade)
	}
	
}
