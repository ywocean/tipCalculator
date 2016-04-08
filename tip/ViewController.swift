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
        tipControl.selectedSegmentIndex = 1
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
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
    
    @IBAction func onChange(sender: AnyObject) {
        calculateValues()
    }
    
    // MARK: util functions
    
    func calculateValues() {
        let tipPercentages = [0.18, 0.2, 0.25]
        
        validateBillAmountValueString()
        
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
                if lastChar == "." {
                    let dotOccurrence = billAmountValueString.componentsSeparatedByString(".")
                    if dotOccurrence.count > 2 {
                        print("already has a dot")
                        billAmountValueString = billAmountValueString.substringToIndex(billAmountValueString.endIndex.predecessor())
                    }
                }
            }
            
            billAmountTextField.text = billAmountValueString
        }
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