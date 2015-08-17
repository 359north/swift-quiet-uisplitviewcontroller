//
//  DetailViewController.swift
//  SplitViewWithContainer
//
//  Created by Steve Mykytyn on 8/14/15.
//  Copyright (c) 2015 359 North Inc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

	@IBOutlet weak var detailDescriptionLabel: UILabel!

	static var instanceCounter:Int = 0

	var instanceID:Int = -1

	var detailItem: AnyObject? {

		didSet {
		    // Update the view.
		    self.configureView()
		}
	}

	func configureView() {
		
		if ( instanceID == -1) { // capture the ID and update the counter once for each instance
		
			DetailViewController.instanceCounter++

			instanceID = DetailViewController.instanceCounter
			
		}
		
		if let detail: AnyObject = self.detailItem {
		
			if let label = self.detailDescriptionLabel {
			
				label.text = String(format:"DetailViewController\nhash = %lx\nitem = %@\ninstance %ld",self.hash,detailItem!.description, instanceID)

		    }
		}
	}
	
	// note the following method is essential: you can just rely on the super method being in place
	// the first set of detailItem occurs 
	// before DetailViewController.instanceCounter is available

	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		self.configureView()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	deinit {
				
		let someString = String(format: "DetailViewController deinit instanceID = %ld",instanceID)
		
		println(someString);
	}

}

