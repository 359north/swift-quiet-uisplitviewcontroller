//
//  TrueDetailViewController.swift
//  SplitViewWithContainer
//
//  Created by Steve Mykytyn on 8/14/15.
//  Copyright (c) 2015 359 North Inc. All rights reserved.
//

import UIKit

class TrueDetailViewController: UIViewController {
	
	@IBOutlet weak var detailDescriptionLabel: UILabel!
	
	var colorA:[UIColor]?
	
	var hitCount = 0

	// note the following method is essential: you can just rely on the super method being in place
	// the first set of detailItem occurs
	// before DetailViewController.instanceCounter is available
	
	override func viewDidLoad() {
	
		super.viewDidLoad()

		colorA = [
			UIColor(red: 0.0, green: 0.35, blue: 0.38, alpha: 1.0),
			UIColor(red: 0.0, green: 0.1, blue: 0.5, alpha: 1.0),
			UIColor(red: 0.5, green: 0.0, blue: 0.0, alpha: 1.0),
			UIColor.orangeColor(),
			UIColor.purpleColor(),
			UIColor.darkGrayColor(),
			UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)]

		self.configureView()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	var detailItem: AnyObject? {
		didSet {
			// Update the view.
			hitCount++
			self.configureView()
		}
	}
	
	func configureView() {
		// Update the user interface for the detail item.
		if let detail: AnyObject = self.detailItem {
			if let label = self.detailDescriptionLabel {
				label.text = String(format:"TrueDetailViewController\nhash = %lx\nitem = %@\nconfigured %ld times",self.hash,detailItem!.description,hitCount)
				label.textColor = colorA![hitCount%(colorA!.count)]
			}
		}
	}
	


}
