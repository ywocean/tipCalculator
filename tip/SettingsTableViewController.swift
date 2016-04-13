//
//  SettingsTableViewController.swift
//  tip
//
//  Created by Yang Wang on 4/11/16.
//  Copyright © 2016 Jessie W. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var selectedTipIndex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Settings"
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let defaultTipPercentage = defaults.doubleForKey(Constants.defaultTipPercentageKey)
        selectedTipIndex = Constants.tipPercentages.indexOf(defaultTipPercentage) ?? 1
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        
        self.tableView.dataSource = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return Constants.tipPercentages.count
        case 1:
            return 1 // selected locale
        default:
            return 0
        }
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.textLabel!.text = "18%"
            case 1:
                cell.textLabel!.text = "20%"
            case 2:
                cell.textLabel!.text = "22%"
            default:
                cell.textLabel!.text = ""
            }
            
            if indexPath.row == selectedTipIndex {
                cell.accessoryType = .Checkmark
            }
            else {
                cell.accessoryType = .None
            }
        case 1:
            let defaults = NSUserDefaults.standardUserDefaults()
            let currentCountryCode = defaults.stringForKey(Constants.countryCodeKey) ?? NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as! String
            cell.textLabel!.text = NSLocale.systemLocale().displayNameForKey(NSLocaleCountryCode, value: currentCountryCode)!
            cell.accessoryType = .DisclosureIndicator
        default:
            print("\(indexPath.section) is invalid")
        }
        
        return cell
    }
    
    func newLabelWithTitle(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.backgroundColor = UIColor.clearColor()
        label.sizeToFit()
        return label
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return newLabelWithTitle("Please choose your default tip percentage")
        case 1:
            return newLabelWithTitle("Please select your default country")
        default:
            return newLabelWithTitle("")
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            let defaults = NSUserDefaults.standardUserDefaults()
            selectedTipIndex = indexPath.row
            defaults.setDouble(Constants.tipPercentages[selectedTipIndex], forKey: Constants.defaultTipPercentageKey)
            defaults.synchronize()
            self.tableView.reloadData()
        case 1:
            performSegueWithIdentifier("locale", sender: nil)
        default:
            print("\(indexPath.section) is invalid")
        }
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
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
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
