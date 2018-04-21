//
//  HoldingViewController.swift
//  Bingo
//
//  Created by aDb on 4/4/18.
//  Copyright © 2018 Teska. All rights reserved.
//

import UIKit
import EMAlertController
import TCPickerView
import JHSpinner

class HoldingViewController: UIViewController,BBDeviceControllerDelegate, BBDeviceOTAControllerDelegate,TCPickerViewDelegate{
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bluetoothButton: UIButton!
    @IBOutlet weak var batterIndicator: BatteryIndicator!
    var waitForCartAlert:EMAlertController!
    var waitForAmountAlert:EMAlertController!
    let picker = TCPickerView()
    var spinner:JHSpinnerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        UICustomization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        BBDeviceController.shared().isDebugLogEnabled = true;
        BBDeviceController.shared().delegate = self;
        GetBatteryPercentage()
        StartBatteryCheck()
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
        
        inputData["cashbackAmount1"] = "1206"
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
            
            inputData["amount"] = "1206"
            inputData["cashbackAmount1"] = "1206"
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
        batterIndicator.precentCharged = BleList.sharedInstance.batteryPercentage
        batterIndicator.animatedReveal = true
    }
    
    @IBAction func RightMenuButtonEvent(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: ["side":"right"])
    }
    
    @IBAction func LeftMenuButtonEvent(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: ["side":"left"])
    }
    
    func UICustomization()
    {
        batterIndicator.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        sendButton.layer.cornerRadius = 3
        sendButton.layer.shadowColor = UIColor.darkGray.cgColor
        sendButton.layer.shadowOpacity = 0.3
        sendButton.layer.shadowOffset = CGSize.init(width: 0, height: 1)
        sendButton.layer.shadowRadius = 1
        containerView.layer.cornerRadius = 3
        containerView.layer.shadowColor = UIColor.darkGray.cgColor
        containerView.layer.shadowOpacity = 0.4
        containerView.layer.shadowOffset = CGSize.init(width: 0, height: 1)
        containerView.layer.shadowRadius = 3
        if BleList.sharedInstance.isConnected
        {
            bluetoothButton.isSelected = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
