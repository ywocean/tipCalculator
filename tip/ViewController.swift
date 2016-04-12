//
//  ViewController.swift
//  tip
//
//  Created by Yang Wang on 4/6/16.
//  Copyright © 2016 Jessie W. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billAmountTextField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var splitByTextField: UITextField!
    @IBOutlet weak var splitAmountLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tipLabel.text = "$0.00"
        totalAmountLabel.text = "$0.00"
        billAmountTextField.text = "$"
        splitByTextField.text = "1"
        splitAmountLabel.text = "$0.00"
        
        setDefaultTip()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultTip()
        calculateValues()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBillAmountEditingDidBegin(sender: AnyObject) {
        if let billAmountValueString = billAmountTextField.text {
            if billAmountValueString == "$" {
                billAmountTextField.text = "";
            }
        }
        
        let endPosition = billAmountTextField.endOfDocument
        billAmountTextField.selectedTextRange = billAmountTextField.textRangeFromPosition(endPosition, toPosition: endPosition)
    }
    
    @IBAction func onSplitByEditingDidBegin(sender: AnyObject) {
        let endPosition = splitByTextField.endOfDocument
        splitByTextField.selectedTextRange = splitByTextField.textRangeFromPosition(endPosition, toPosition: endPosition)

    }
    
    @IBAction func onChange(sender: AnyObject) {
        calculateValues()
    }
    
    // MARK: util functions
    
    func setDefaultTip() {
        print("asdsadadass")
        let defaults = NSUserDefaults.standardUserDefaults()
        let defaultTipPercentage = defaults.doubleForKey(Constants.defaultTipPercentageKey)
        tipControl.selectedSegmentIndex = Constants.tipPercentages.indexOf(defaultTipPercentage) ?? 1
    }
    
    func calculateValues() {
        let tipPercentages = Constants.tipPercentages
        
        validateBillAmountValueString()
        validateSplitByValueString()
        
        if let billAmountValueString = billAmountTextField.text {
            if let billAmount = Double(billAmountValueString){
                let tipAmount = billAmount * tipPercentages[tipControl.selectedSegmentIndex]
                let totalAmount = tipAmount + billAmount;
                tipLabel.text = String(format: "$%.2f", tipAmount)
                totalAmountLabel.text = String(format: "$%.2f", totalAmount)
                
                if let splitByValueString = splitByTextField.text {
                    if let splitBy = Double(splitByValueString) {
                        let splitAmount = totalAmount / splitBy
                        splitAmountLabel.text = String(format: "$%.2f", splitAmount)
                        return
                    }
                }
                
                splitAmountLabel.text = "$-.--"
                return
            }
        }
        
        tipLabel.text = "$0.00"
        totalAmountLabel.text = "$0.00"
        splitAmountLabel.text = "$0.00"
    }
    
    func validateBillAmountValueString() {
        if var billAmountValueString = billAmountTextField.text {
            if billAmountValueString.characters.count > 1 {
            
                let lastChar = billAmountValueString.substringFromIndex(billAmountValueString.endIndex.predecessor())
                let firstChar = billAmountValueString.substringToIndex(billAmountValueString.startIndex.successor())
                let dotOccurrence = billAmountValueString.componentsSeparatedByString(".")
                if lastChar == "." {
                    if dotOccurrence.count > 2 {
                        billAmountValueString = removeLastCharacter(billAmountValueString)
                    }
                }
                else if billAmountValueString.characters.count == 2 && firstChar == "0" {
                    billAmountValueString = removeLastCharacter(billAmountValueString)
                }
                else if dotOccurrence.count == 2 {
                    let dotRange = billAmountValueString.rangeOfString(".")
                    let decimalValueString = billAmountValueString.substringFromIndex(dotRange!.endIndex)
                    if decimalValueString.characters.count > 2 {
                        billAmountValueString = removeLastCharacter(billAmountValueString)
                    }
                }
            }
            
            billAmountTextField.text = billAmountValueString
        }
    }
    
    func validateSplitByValueString () {
        if var splitByValueString = splitByTextField.text {
            if splitByValueString.characters.count > 0 {
                let firstChar = splitByValueString.substringToIndex(splitByValueString.startIndex.successor())
                if firstChar == "0" {
                    splitByValueString = removeLastCharacter(splitByValueString)
                }
            }
            
            splitByTextField.text = splitByValueString
        }
    }
    
    func removeLastCharacter(str: String) -> String{
        return str.substringToIndex(str.endIndex.predecessor())
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
        
        if let billAmountValueString = billAmountTextField.text {
            if billAmountValueString == "" {
                billAmountTextField.text = "$";
            }
        }
        
        if let splitByValueString = splitByTextField.text {
            if splitByValueString == "" {
                splitByTextField.text = "1";
            }
        }
        
        calculateValues()
    }

}