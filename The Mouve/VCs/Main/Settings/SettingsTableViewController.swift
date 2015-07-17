//
//  SettingsTableViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 4/28/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import Parse

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var followersNotifySwitch: UISwitch!
    @IBOutlet weak var inviteNotifySwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()

        followersNotifySwitch.tintColor = UIColor.lightSeaFoamGreen()
        followersNotifySwitch.onTintColor = UIColor.lightSeaFoamGreen()
        followersNotifySwitch.thumbTintColor = UIColor.seaFoamGreen()
        
        inviteNotifySwitch.tintColor = UIColor.lightSeaFoamGreen()
        inviteNotifySwitch.onTintColor = UIColor.lightSeaFoamGreen()
        inviteNotifySwitch.thumbTintColor = UIColor.seaFoamGreen()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                println("Radius")
            default: ()
            }
        case 1:
            switch indexPath.row {
            case 0:
                println("New followers")
            case 1:
                println("New invites")
            default: ()
            }
        case 2:
            switch indexPath.row {
            case 0:
                println("Facebook")
            case 1:
                println("Twitter")
            default: ()
            }
        case 3:
            switch indexPath.row {
            case 0:
                println("Contact us")
            case 1:
                println("Privacy Policy")
            case 2:
                println("Terms of use")
            default: ()
            }
        case 4:
            PFUser.logOut()
            appDel.checkLogin()
        default: ()
        }
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
