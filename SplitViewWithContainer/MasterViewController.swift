//
//  MasterViewController.swift
//  SplitViewWithContainer
//
//  Created by Steve Mykytyn on 8/14/15.
//  Copyright (c) 2015 359 North Inc. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UISplitViewControllerDelegate {

	var detailViewController: DetailViewController? = nil
	var trueDetailViewController: TrueDetailViewController? = nil
	var objects = [AnyObject]()
	
	var lastSelectedRow = -1, lastSelectedSection = -1


	override func awakeFromNib() {
		super.awakeFromNib()
		if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
		    self.clearsSelectionOnViewWillAppear = false
		    self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.navigationItem.leftBarButtonItem = self.editButtonItem()

		let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
		self.navigationItem.rightBarButtonItem = addButton
		if let split = self.splitViewController {
			
			split.delegate = self

		    let controllers = split.viewControllers
		    self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
		}
		
		// create the persistent true detail controller
		
		var mainBoard = UIStoryboard.init(name: "Main", bundle: nil)
		
		trueDetailViewController = mainBoard.instantiateViewControllerWithIdentifier("TrueDetailViewController") as? TrueDetailViewController
		
		trueDetailViewController?.detailItem = nil
		
		trueDetailViewController!.configureView()
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func insertNewObject(sender: AnyObject) {
		objects.insert(NSDate(), atIndex: 0)
		let indexPath = NSIndexPath(forRow: 0, inSection: 0)
		self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
		self.resetLastItemSelection()
	}

	// MARK: - Segues and related support
	
	func addTrueDetailControllerToContainer() {
		
		detailViewController?.addChildViewController(trueDetailViewController!)
		
		trueDetailViewController?.view.frame = detailViewController!.view.frame
		
		detailViewController?.view.addSubview(trueDetailViewController!.view)
		
		trueDetailViewController?.didMoveToParentViewController(detailViewController!)
	}
	
	func resetLastItemSelection() { // when inserting or deleting rows, altering the position of selection, if any
		
		if let indexPath = self.tableView.indexPathForSelectedRow() {
		
			lastSelectedRow = indexPath.row
			lastSelectedSection = indexPath.section
		}
		else {
			
			lastSelectedRow = -1
			lastSelectedSection = -1
		}
	}
	
	override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
		
		if let svc = self.splitViewController {
			
			if svc.collapsed {return true}  // if collapsed we need to perform segue
		}
		
		// from here on, we know the splitViewController is not collapsed
		
		if let indexPath = self.tableView.indexPathForSelectedRow() {
		
			if ((indexPath.row == lastSelectedRow) && (indexPath.section == lastSelectedSection)) {
				
				return false  // if selection has not changed no need to perform segue
				
			}
			
			lastSelectedRow = indexPath.row
			lastSelectedSection = indexPath.section

			if (trueDetailViewController?.parentViewController != nil) {
				
				let object = objects[indexPath.row] as! NSDate
					
				trueDetailViewController!.detailItem = object
				
				return false; // if selection has not changed no need to perform segue
			}
		}
		
		return true; // if no row is selected in master, we need to perform the
		
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		if segue.identifier == "showDetail" {
		
			if let indexPath = self.tableView.indexPathForSelectedRow() { // if a row is selected
				
				let object = objects[indexPath.row] as! NSDate
				
				detailViewController = (segue.destinationViewController as! UINavigationController).topViewController as? DetailViewController
				
				detailViewController?.detailItem = object
				
				detailViewController?.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
				
				detailViewController?.navigationItem.leftItemsSupplementBackButton = true
				
				self.addTrueDetailControllerToContainer()
				
				trueDetailViewController?.detailItem = object

		    }
		}
	}

	// MARK: - Table View

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return objects.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

		let object = objects[indexPath.row] as! NSDate
		cell.textLabel!.text = object.description
		return cell
	}

	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return true
	}

	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete {
		    objects.removeAtIndex(indexPath.row)
		    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
			self.resetLastItemSelection()
		} else if editingStyle == .Insert {
		    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
		}
	}
	
	// MARK: - Split view
	
	func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:
		UIViewController!, ontoPrimaryViewController primaryViewController:UIViewController!) -> Bool {
			
		if let indexPath = self.tableView.indexPathForSelectedRow() { // a row is selected
			
			if ( self.trueDetailViewController != nil ) {
				
				return false; // don't collapse if trueDetailController is set

			}
		}
			
		return true // collapse otherwise
	}



}

