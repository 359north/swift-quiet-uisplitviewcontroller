## A Quiet UISplitViewController Example in Swift ##

Xcode generates a **Master-Detail** project from its built-in templates, but there are a few behaviors in that project that can be improved.

The **UISplitViewController** Class Reference states that

> When designing your split view interface, it is best to install primary and secondary view controllers **that do not change**. A common technique is to install navigation controllers in both positions and then push and pop new content as needed. Having these types of anchor view controllers makes it easier to focus on your content and let the split view controller apply its default behavior to the overall interface.

But in Apple's standard template using UISplitViewController in a storyboard, the **Show Detail** segue creates a new instance of the secondary view controller every time you tap an item in the primary UITableView to select it.

Good apps are ***quiet*** - they don't perform unneeded operations.  So can we avoid all this activity around the DetailViewController?

Yes, we can!  By using view containment, we make a single copy of the **TrueDetailViewController** whose contents are updated by the **Show Detail** segue.

We can further reduce unnecessary operations with appropriate use of the **shouldPerformSegueWithIdentifier** and a UISplitViewControllerDelegate method that checks whether or not any items are selected in the master view.


### Our example does the following: ###

* Creates a single, persistent **TrueDetailViewController** owned by the **MasterViewController**

* Makes the **MasterViewController** the **UISplitViewControllerDelegate** and only allows it to discard the secondary view controller in **splitViewController: collapseSecondaryViewController: ontoPrimaryViewController:** when no row is selected, or no object has been set for **TrueDetailViewController**

* When a new **DetailViewController** is created by a segue, adds the **TrueDetailViewController** to it as a child controller

* Adds **shouldPerformSegueWithIdentifier**() method to suppress the segue when the user taps the same item and a view controller is already displayed.

* Suppresses the segue and updates the **TrueDetailViewController** when the **UISplitViewController** is not in the *collapsed* state.



### The Result ###

We display the hash IDs and creation dates of both the DetailViewController and the child TrueDetailViewController so you can see their behavior as you create and tap items in the master list.

**Before**

* Allocate a (possibly very) complex detail view controller every time a new item is selected
	
* Allocate detail controllers whether you need them or not
	
**After**

* Allocate a (possibly very) complex detail view controller ONCE
	
* Allocate a simple view controller in the segue when needed, and use view controller containment to insert the persistent complex view controller as a child controller.
	
* Avoid the segue in situations where it is not needed


### Note for Testing ###

The iPhone 6 Plus, real or simulated, is great for testing this app as you can see all the possible split view cases on one device.

On an iPad, there should be only one or two segues performed, depending on what orientation you start in.
	



