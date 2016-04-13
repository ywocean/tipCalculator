//
//  LocaleTableViewController.swift
//  tip
//
//  Created by Yang Wang on 4/12/16.
//  Copyright © 2016 Jessie W. All rights reserved.
//

import UIKit

class LocaleTableViewController: UITableViewController {
    
    struct Locale {
        let countryCode: String
        let countryName: String
    }
    
    private var countries = [Locale]()
    private var selectedCountrycode = NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as! String
    
    private func locales() -> [Locale] {
        
        var locales = [Locale]()
        for localeCode in NSLocale.ISOCountryCodes() {
            let countryName = NSLocale.systemLocale().displayNameForKey(NSLocaleCountryCode, value: localeCode)!
            let countryCode = localeCode as String
            let locale = Locale(countryCode: countryCode, countryName: countryName)
            locales.append(locale)
        }
        
        return locales
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let countriesTemp = locales()
        countries = countriesTemp.sort({$0.countryName < $1.countryName})
        
        let defaults = NSUserDefaults.standardUserDefaults()
        selectedCountrycode = defaults.stringForKey(Constants.countryCodeKey) ?? NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as! String
        
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "localeCell")
        self.tableView.dataSource = self
        
        self.navigationItem.title = "Countries"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return countries.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("localeCell", forIndexPath: indexPath)
        
        let country = countries[indexPath.row]
        cell.textLabel!.text = country.countryName
        if selectedCountrycode == country.countryCode {
            cell.accessoryType = .Checkmark
        }
        else {
            cell.accessoryType = .None
        }


        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let country = countries[indexPath.row]
        selectedCountrycode = country.countryCode
        defaults.setValue(selectedCountrycode, forKey: Constants.countryCodeKey)
        defaults.synchronize()
        navigationController?.popViewControllerAnimated(true)
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
