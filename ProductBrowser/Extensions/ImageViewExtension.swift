//
//  ImageViewExtension.swift
//  ProductBrowser
//
//  Created by Babu G on 7/15/18.
//  Copyright © 2018 Babu Gangatharan. All rights reserved.
//

import Foundation
import UIKit


extension UIImageView {
	
	var imageWithFade: UIImage? {
		get {
			return self.image
		}
		set {
			UIView.transition(with: self,
							  duration: 1.0, options: .curveEaseInOut, animations: {
								self.image = newValue
			}, completion: nil)
		}
	}
}
