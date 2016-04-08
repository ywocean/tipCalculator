//
//  ViewController.swift
//  tip
//
//  Created by Yang Wang on 4/6/16.
//  Copyright © 2016 Jessie W. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: variables
    
    @IBOutlet weak var billAmountTextField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var splitByTextField: UITextField!
    @IBOutlet weak var splitAmountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tipLabel.text = "$0.00"
        totalAmountLabel.text = "$0.00"
        billAmountTextField.text = "$"
        splitByTextField.text = "1"
        splitAmountLabel.text = "$0.00"
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: actions
    
    @IBAction func onBillAmountEditingDidBegin(sender: AnyObject) {
        if let billAmountValueString = billAmountTextField.text {
            if billAmountValueString == "$" {
                billAmountTextField.text = "";
            }
        }
        
        let endPosition = billAmountTextField.endOfDocument
        billAmountTextField.selectedTextRange = billAmountTextField.textRangeFromPosition(endPosition, toPosition: endPosition)
    }
    
    @IBAction func onBillAmountEditingChange(sender: AnyObject) {
        calculateValues()
    }
    
    @IBAction func onSplitByEditingChange(sender: AnyObject) {
        calculateValues()
    }
    
    // MARK: util functions
    
    func calculateValues() {
        if let billAmountValueString = billAmountTextField.text {
            if let billAmount = Double(billAmountValueString){
                let tipAmount = billAmount * 0.2
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