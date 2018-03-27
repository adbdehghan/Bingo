//
//  BuyViewController.swift
//  Bingo
//
//  Created by adb on 3/10/18.
//  Copyright © 2018 Teska. All rights reserved.
//

import UIKit

class BuyViewController: UIViewController,BBDeviceControllerDelegate, BBDeviceOTAControllerDelegate {

    @IBOutlet weak var functionView: UIView!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var basketCountLabel: UILabel!
    var userIsInTheMiddleOfTyping = false
    private var brain = CalculatorBrain()
    @IBOutlet weak var bluetoothButton: UIButton!
    @IBOutlet weak var basketSumLabel: UILabel!
    @IBOutlet weak var firstRowStack: UIStackView!
    @IBOutlet weak var secondRowStack: UIStackView!
    @IBOutlet weak var thirdRowStack: UIStackView!
    @IBOutlet weak var fifthRowStack: UIStackView!
    @IBOutlet weak var calculatorContainerView: UIView!
    @IBOutlet weak var deviceConnectivityStatusLabel: UILabel!
    
    var displayValue: Double {
        get {
            return currentPriceLabel.text!.ToEnLocal()
        }
        set {
            currentPriceLabel.text = String(newValue.withCommas()).replacedEnglishDigitsWithArabic
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        basketCountLabel.text = String(BasketData.sharedInstance.items.count).replacedEnglishDigitsWithArabic
        
        BBDeviceController.shared().isDebugLogEnabled = true;
        BBDeviceController.shared().delegate = self;
        BBDeviceController.shared().startBTScan(nil, scanTimeout: 200);
        CustomizeViews()
    }
    
    func onBTReturnScanResults(_ devices: [Any]!) {
        BBDeviceController.shared().connectBT(devices[0] as! NSObject);
        BBDeviceController.shared().stopBTScan()
    }
    
    func onBTConnected(_ connectedDevice: NSObject!) {
        BBDeviceController.shared().getDeviceInfo();
        bluetoothButton.isSelected = true
        deviceConnectivityStatusLabel.text = "دستگاه متصل است"
    }
    
    func onBTDisconnected() {
        bluetoothButton.isSelected = false
        deviceConnectivityStatusLabel.text = "دستگاه متصل نیست"
    }
    
    func onError(_ errorType: BBDeviceErrorType, errorMessage: String!) {
        
    }
    
    func CustomizeViews()
    {
        functionView.layer.cornerRadius = 3
        functionView.layer.shadowColor = UIColor.darkGray.cgColor
        functionView.layer.shadowOpacity = 0.4
        functionView.layer.shadowOffset = CGSize.init(width: 0, height: 1)
        functionView.layer.shadowRadius = 3
        
//        calculatorContainerView.layer.shadowColor = UIColor.darkGray.cgColor
//        calculatorContainerView.layer.shadowOpacity = 0.6
//        calculatorContainerView.layer.shadowOffset = CGSize.init(width: 0, height: 1)
//        calculatorContainerView.layer.shadowRadius = 3
        
        basketCountLabel.adjustsFontSizeToFitWidth = true
        currentPriceLabel.adjustsFontSizeToFitWidth = true
        basketSumLabel.adjustsFontSizeToFitWidth = true
        
        let stackArray:NSMutableArray = NSMutableArray()
        stackArray.addObjects(from: [firstRowStack,secondRowStack,thirdRowStack,fifthRowStack])
        
//        for stack in stackArray {
//            for item in (stack as! UIStackView).subviews
//            {
//                if item.subviews.first is UIButton
//                {
//                    let button = item.subviews.first as! UIButton
//                    button.layer.cornerRadius = button.frame.width/2
//                }
//            }
//        }
        
    }

    @IBAction func DecimalEvent(_ sender: Any) {
        if !userIsInTheMiddleOfTyping {
            currentPriceLabel.text! = "۰."
            userIsInTheMiddleOfTyping = true
        } else if !currentPriceLabel.text!.contains(".") {
            currentPriceLabel.text! += "."
        }
    }
    
    @IBAction func OperationEvent(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            // set the left side of the equation (what will be added/multiplied)
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            // MVC does not allow calculations here, so just send over the symbol with the operand which will handle it
            brain.performOperation(mathematicalSymbol)
        }
        
        if let result = brain.result  {
            displayValue = result
        }
    }
    
    @IBAction func backSpaceEvent(_ sender: Any) {
        if !(currentPriceLabel.text?.isEmpty)!
        {
            currentPriceLabel.text?.removeLast()
            if !(currentPriceLabel.text?.isEmpty)!
            {
                currentPriceLabel!.text = String(currentPriceLabel.text!.ToEnLocal().withCommas()).replacedEnglishDigitsWithArabic
            }
            else
            {
                currentPriceLabel!.text = "۰"
            }
        }
    }
    
    @IBAction func DigitEvent(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = currentPriceLabel.text!
            let sumStrings = textCurrentlyInDisplay + digit
            currentPriceLabel!.text =  String(sumStrings.ToEnLocal().withCommas()).replacedEnglishDigitsWithArabic
        } else {
            currentPriceLabel!.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    @IBAction func clearCalcEvent(_ sender: Any) {
        currentPriceLabel.text?.removeAll()
        currentPriceLabel.text = "۰"
        userIsInTheMiddleOfTyping = false
        brain.reset()
    }
    
    @IBAction func addToListEvent(_ sender: Any) {
        if displayValue != 0 {
            BasketData.sharedInstance.items.add(displayValue)
            let arr:[Double] = NSArray(array:BasketData.sharedInstance.items) as! [Double]
            let sum = arr.reduce(0, +)
            basketSumLabel.text = String(sum.withCommas()).replacedEnglishDigitsWithArabic
            basketCountLabel.text = String(BasketData.sharedInstance.items.count).replacedEnglishDigitsWithArabic
        }
    }
    
    @IBAction func ShowBasketEvent(_ sender: Any) {
        
    }
    
    @IBAction func ShowBLEList(_ sender: Any) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

public extension String {
    public var replacedEnglishDigitsWithArabic: String {
        var str = self
        let map = ["0": "٠",
                   "1": "١",
                   "2": "۲",
                   "3": "۳",
                   "4": "۴",
                   "5": "۵",
                   "6": "۶",
                   "7": "۷",
                   "8": "۸",
                   "9": "۹"]
        map.forEach { str = str.replacingOccurrences(of: $0, with: $1) }
        return str
    }
    
    func ToEnLocal() -> Double {
        let Formatter: NumberFormatter = NumberFormatter()
        Formatter.numberStyle = .decimal
        Formatter.roundingMode = .down
        Formatter.maximumFractionDigits = 100
        Formatter.locale = NSLocale(localeIdentifier: "EN") as Locale?
        return Formatter.number(from: self.replacingOccurrences(of: ",", with: ""))!.doubleValue
    }
}
extension Double {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.roundingMode = .down
        numberFormatter.maximumFractionDigits = 100
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}
