//
//  BuyViewController.swift
//  Bingo
//
//  Created by adb on 3/10/18.
//  Copyright © 2018 Teska. All rights reserved.
//

import UIKit
import EMAlertController
import TCPickerView
import JHSpinner

class BuyViewController: UIViewController,BBDeviceControllerDelegate, BBDeviceOTAControllerDelegate,TCPickerViewDelegate {


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
    @IBOutlet weak var batterIndicator: BatteryIndicator!
    var waitForCartAlert:EMAlertController!
    var waitForAmountAlert:EMAlertController!
    let picker = TCPickerView()
    var spinner:JHSpinnerView!
    
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
        batterIndicator.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        BBDeviceController.shared().isDebugLogEnabled = true;
        BBDeviceController.shared().delegate = self;
        BBDeviceController.shared().startBTScan(nil, scanTimeout: 200);
        
        CustomizeViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        BBDeviceController.shared().isDebugLogEnabled = true;
        BBDeviceController.shared().delegate = self;
        
        let arr:[Double] = NSArray(array:BasketData.sharedInstance.items) as! [Double]
        let sum = arr.reduce(0, +)
        basketSumLabel.text = String(sum.withCommas()).replacedEnglishDigitsWithArabic
        basketCountLabel.text = String(BasketData.sharedInstance.items.count).replacedEnglishDigitsWithArabic
        
        batterIndicator.precentCharged = BleList.sharedInstance.batteryPercentage
        batterIndicator.animatedReveal = true
    }
    
    func onBTReturnScanResults(_ devices: [Any]!) {
        BleList.sharedInstance.devices.removeAllObjects()
        BleList.sharedInstance.devices.addObjects(from: devices)
        if spinner != nil
        {
            spinner.dismiss()
        }
        picker.title = "دستگاه ها"
        
        let values = BleList.sharedInstance.devices.map { TCPickerView.Value(title: ($0 as! EAAccessory).serialNumber) }
        picker.values = values
        picker.delegate = self
        picker.selection = .single
        picker.mainColor = UIColor.colorWithHexString(baseHexString: "46BECD", alpha: 1)
        picker.completion = { (selectedIndexes) in
            for i in selectedIndexes {
                BBDeviceController.shared().connectBT(BleList.sharedInstance.devices[i] as! NSObject);
            }
        }
        
        picker.show()

    }
    
    func onBTScanTimeout() {
        if spinner != nil
        {
            spinner.dismiss()
        }
    }
    
    func onBTConnected(_ connectedDevice: NSObject!) {
        BBDeviceController.shared().getDeviceInfo();
        BleList.sharedInstance.isConnected = true
        bluetoothButton.isSelected = true
        StartBatteryCheck()
        var imageCommand:String = BBDeviceController.shared().getImageCommand(UIImage(named: "aghlam"))
        
        var inputData = Dictionary<AnyHashable, Any>()
        inputData["currencyCode"] = "364"
//        BBDeviceController.shared().sendPrint(<#Data!#>)
    }
    
    func onReturnDeviceInfo(_ deviceInfo: [AnyHashable : Any]!) {
        let battery = deviceInfo["batteryPercentage"] as! String
        batterIndicator.precentCharged = Double.init(battery)!
        batterIndicator.animatedReveal = true
        BleList.sharedInstance.batteryPercentage = Double.init(battery)!
    }
    
    func onBTDisconnected() {
        bluetoothButton.isSelected = false
        batterIndicator.precentCharged = 0
        batterIndicator.animatedReveal = true
        BBDeviceController.shared().startBTScan(nil, scanTimeout: 200);
    }
    
    func onError(_ errorType: BBDeviceErrorType, errorMessage: String!) {
        
    }
    
    @IBAction func SendEvent(_ sender: Any) {
        let alert = EMAlertController(title: "ارسال به کارتخوان؟", message: "در صورت تایید درخواست شما به دستگاه خودپرداز ارسال می‌شود.")
        alert.iconImage = UIImage(named: "pos")
        let cancel = EMAlertAction(title: "لغو", style: .cancel)
        cancel.titleFont = UIFont(name: "IRANSans-Bold", size: 14)
        cancel.titleColor =  UIColor.init(red: 186/255, green: 186/255, blue: 186/255, alpha: 1)
        let confirm = EMAlertAction(title: "تایید", style: .normal) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.ConfirmSend()
            }
            
        }
        confirm.titleFont = UIFont(name: "IRANSans-Bold", size: 14)
        confirm.titleColor = UIColor.init(red: 76/255, green: 182/255, blue: 172/255, alpha: 1)
        alert.addAction(action: cancel)
        alert.addAction(action: confirm)
        present(alert, animated: true, completion: nil)
    }
    
    func ConfirmSend()
    {
        waitForAmountAlert = EMAlertController(title: "", message: "منتظر تایید مبلغ")
        waitForAmountAlert.iconImage = UIImage(named: "tick")
        let cancel = EMAlertAction(title: "لغو", style: .cancel){
            BBDeviceController.shared().cancelSetAmount()
        }
        cancel.titleFont = UIFont(name: "IRANSans-Bold", size: 14)
        cancel.titleColor =  UIColor.init(red: 186/255, green: 186/255, blue: 186/255, alpha: 1)
        waitForAmountAlert.addAction(action: cancel)
        
        present(waitForAmountAlert, animated: true, completion: nil)
        
        var inputData = Dictionary<AnyHashable, Any>()
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = "YYMMddHHmmss"
        formatter.timeZone = NSTimeZone.local
        let currentTime = formatter.string(from: Date())
        inputData["terminalTime"] = currentTime
        
        let currencyCharacter = NSArray(objects: NSNumber(value: (BBDeviceCurrencyCharacter.U.hashValue)),NSNumber(value: BBDeviceCurrencyCharacter.S.hashValue),NSNumber(value: BBDeviceCurrencyCharacter.D.hashValue))
        
        inputData["currencyCharacters"] = currencyCharacter
        inputData["currencyCode"] = "364"
        inputData["transactionType"] = NSNumber(value: BBDeviceTransactionType.payment.hashValue)
        
        let arr:[Double] = NSArray(array:BasketData.sharedInstance.items) as! [Double]
        let sum = arr.reduce(0, +)
        inputData["amount"] = String(sum)
        inputData["cashbackAmount1"] = String(sum)
        BBDeviceController.shared().setAmount(NSDictionary.init(dictionary: inputData) as! [AnyHashable : Any])
        

    }
    
    func onReturnAmountConfirmResult(_ isConfirmed: Bool) {
        if isConfirmed {
            waitForAmountAlert.dismiss(animated: true, completion: nil)
            var inputData = Dictionary<AnyHashable, Any>()
            let formatter:DateFormatter = DateFormatter()
            formatter.dateFormat = "YYMMddHHmmss"
            formatter.timeZone = NSTimeZone.local
            let currentTime = formatter.string(from: Date())
            inputData["terminalTime"] = currentTime
            
            let currencyCharacter = NSArray(objects: NSNumber(value: (BBDeviceCurrencyCharacter.U.hashValue)),NSNumber(value: BBDeviceCurrencyCharacter.S.hashValue),NSNumber(value: BBDeviceCurrencyCharacter.D.hashValue))
            
            inputData["currencyCharacters"] = currencyCharacter
            inputData["currencyCode"] = "364"
            inputData["transactionType"] = NSNumber(value: BBDeviceTransactionType.payment.hashValue)
            
            let arr:[Double] = NSArray(array:BasketData.sharedInstance.items) as! [Double]
            let sum = arr.reduce(0, +)
            inputData["amount"] = String(sum)
            inputData["cashbackAmount1"] = String(sum)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                BBDeviceController.shared().startEmv(withData: NSDictionary.init(dictionary: inputData) as! [AnyHashable : Any])

            }

        }
        else
        {
            waitForAmountAlert.dismiss(animated: true, completion: nil)
        }
    }
    
    func onWaiting(forCard checkCardMode: BBDeviceCheckCardMode) {
        
        
        if waitForCartAlert != nil {
            self.waitForCartAlert.dismiss(animated: true, completion: nil)
        }
        
        waitForCartAlert = EMAlertController(title: "", message: "منتظر کشیدن کارت")
        
        waitForCartAlert.iconImage = UIImage(named: "pos")
        let cancel = EMAlertAction(title: "لغو", style: .cancel){
            BBDeviceController.shared().cancelCheckCard()
        }
        cancel.titleFont = UIFont(name: "IRANSans-Bold", size: 14)
        cancel.titleColor =  UIColor.init(red: 186/255, green: 186/255, blue: 186/255, alpha: 1)
        waitForCartAlert.addAction(action: cancel)
        
        present(waitForCartAlert, animated: true, completion: nil)
    }
    
    func onReturn(_ result: BBDeviceCheckCardResult, cardData: [AnyHashable : Any]!) {
        
        waitForCartAlert.dismiss(animated: true, completion: nil)
        
            var inputData = Dictionary<AnyHashable, Any>()
            
            inputData["pinEntryTimeout"] = "15"
//            inputData["orderID"] = "364"
            
            BBDeviceController.shared().startPinEntry(NSDictionary.init(dictionary: inputData) as! [AnyHashable : Any])

    }
    
    
    
    func onRequestPinEntry(_ pinEntrySource: BBDevicePinEntrySource) {
        
        waitForCartAlert = EMAlertController(title: "", message: "منتظر دریافت رمز عبور")
        waitForCartAlert.iconImage = UIImage(named: "pos")
        let cancel = EMAlertAction(title: "لغو", style: .cancel){
            BBDeviceController.shared().cancelCheckCard()
        }
        cancel.titleFont = UIFont(name: "IRANSans-Bold", size: 14)
        cancel.titleColor =  UIColor.init(red: 186/255, green: 186/255, blue: 186/255, alpha: 1)
        waitForCartAlert.addAction(action: cancel)
        
        present(waitForCartAlert, animated: true, completion: nil)
    }
    
    func onReturn(_ result: BBDevicePinEntryResult, data: [AnyHashable : Any]!) {
        waitForCartAlert.dismiss(animated: true, completion: nil)
        
        ///TODO
        
        
        
        currentPriceLabel.text?.removeAll()
        currentPriceLabel.text = "۰"
        userIsInTheMiddleOfTyping = false
        brain.reset()
        BasketData.sharedInstance.items.removeAllObjects()
        basketSumLabel.text = "۰"
        basketCountLabel.text = "۰"
        
        ShowRecipe()

    }
    
    func ShowRecipe()
    {
        let headerView:ShadowView = (Bundle.main.loadNibNamed("TransactionResultView", owner:
            self, options: nil)?.first as? ShadowView)!
        self.view.addSubview(headerView)
        headerView.backgroundColor = UIColor.white
        headerView.shadowRadius = 10.0
        headerView.frame = CGRect(x: view.frame.size.width/2 - 150, y: view.frame.size.height, width: 300, height: 470)
        headerView.isHidden = true
        headerView.animShow()
    }
    
    func CustomizeViews()
    {
        functionView.layer.cornerRadius = 3
        functionView.layer.shadowColor = UIColor.darkGray.cgColor
        functionView.layer.shadowOpacity = 0.4
        functionView.layer.shadowOffset = CGSize.init(width: 0, height: 1)
        functionView.layer.shadowRadius = 3
        
        basketCountLabel.adjustsFontSizeToFitWidth = true
        currentPriceLabel.adjustsFontSizeToFitWidth = true
        basketSumLabel.adjustsFontSizeToFitWidth = true
        
        let stackArray:NSMutableArray = NSMutableArray()
        stackArray.addObjects(from: [firstRowStack,secondRowStack,thirdRowStack,fifthRowStack])
        
        if BleList.sharedInstance.isConnected
        {
            bluetoothButton.isSelected = true
        }
        
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
        
        BBDeviceController.shared().disconnectBT()
        
        spinner = JHSpinnerView.showOnView(view, spinnerColor:UIColor.colorWithHexString(baseHexString: "46BECD", alpha: 1), overlay:.circular, overlayColor:UIColor.init(white: 0.6, alpha: 1), attributedText: NSAttributedString(string: ""))
        spinner.progress = 0.0
        view.addSubview(spinner)
    }
    
    func pickerView(_ pickerView: TCPickerView, didSelectRowAtIndex index: Int) {
        
        
    }
        
    func StartBatteryCheck()
    {
        Timer.scheduledTimer(timeInterval: 360, target: self, selector: #selector(self.GetBatteryPercentage), userInfo: nil, repeats: true)
    }
    
    @objc func GetBatteryPercentage()
    {
        BBDeviceController.shared().getDeviceInfo();
    }
    
    @IBAction func RightMenuButtonEvent(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: ["side":"right"])
    }
    
    @IBAction func LeftMenuButtonEvent(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: ["side":"left"])
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
