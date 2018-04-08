//
//  BillViewController.swift
//  Bingo
//
//  Created by aDb on 4/4/18.
//  Copyright © 2018 Teska. All rights reserved.
//

import UIKit
import EMAlertController
import BarcodeScanner

class BillViewController: UIViewController,BBDeviceControllerDelegate, BBDeviceOTAControllerDelegate,BarcodeScannerCodeDelegate,BarcodeScannerDismissalDelegate,BarcodeScannerErrorDelegate {

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var barcodeButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bluetoothButton: UIButton!
    var waitForCartAlert:EMAlertController!
    var waitForAmountAlert:EMAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BBDeviceController.shared().isDebugLogEnabled = true;
        BBDeviceController.shared().delegate = self;
        BBDeviceController.shared().startBTScan(nil, scanTimeout: 200);
        
        UICustomization()
        
    }
    
    func onBTReturnScanResults(_ devices: [Any]!) {
        BBDeviceController.shared().connectBT(devices[0] as! NSObject);
        BBDeviceController.shared().stopBTScan()
    }
    
    func onBTConnected(_ connectedDevice: NSObject!) {
        BBDeviceController.shared().getDeviceInfo();
        bluetoothButton.isSelected = true
    }
    
    func onBTDisconnected() {
        bluetoothButton.isSelected = false
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
        
    }
    
    @IBAction func ShowBarcodeReader(_ sender: Any) {
        let viewController = BarcodeScannerController()
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self
        
        present(viewController, animated: true, completion: nil)
    }
    
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
//        controller.resetWithError(message: "Error message")
         controller.dismiss(animated: true, completion: nil)
    }
    
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
         controller.dismiss(animated: true, completion: nil)
    }
    
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        
    }
    
    func UICustomization()
    {
        barcodeButton.layer.cornerRadius = 3
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
