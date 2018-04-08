//
//  DirectChargeViewController.swift
//  Bingo
//
//  Created by aDb on 4/4/18.
//  Copyright © 2018 Teska. All rights reserved.
//

import UIKit
import EMAlertController
import TCPickerView

class DirectChargeViewController: UIViewController,BBDeviceControllerDelegate, BBDeviceOTAControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,TCPickerViewDelegate {

    @IBOutlet weak var phoneNumberTextField: TweeAttributedTextField!
    @IBOutlet weak var bluetoothButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var chargePriceTableView: UITableView!
    var waitForCartAlert:EMAlertController!
    var waitForAmountAlert:EMAlertController!
    var priceArray = ["۱۰.۰۰۰","۲۰.۰۰۰","۵۰.۰۰۰","۱۰۰.۰۰۰","۲۰۰.۰۰۰"]
    var priceArrayMap = ["10000","20000","50000","100000","200000"]
    var selectedPrice = ""
        let picker = TCPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chargePriceTableView.dataSource = self
        chargePriceTableView.delegate = self
        
        UICustomization()
    }
    
    
    func onBTReturnScanResults(_ devices: [Any]!) {
        BBDeviceController.shared().connectBT(devices[0] as! NSObject);
        BBDeviceController.shared().stopBTScan()
    }
    
    func onBTConnected(_ connectedDevice: NSObject!) {
        BBDeviceController.shared().getDeviceInfo();
        bluetoothButton.isSelected = true
        BleList.sharedInstance.isConnected = true
    }
    
    func onBTDisconnected() {
        bluetoothButton.isSelected = false
    }
    
    func onError(_ errorType: BBDeviceErrorType, errorMessage: String!) {
        
    }

    @IBAction func SendEvent(_ sender: Any) {
        
        if phoneNumberTextField.text?.count == 11 && !selectedPrice.isEmpty
        {
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
        else
        {
            waitForAmountAlert = EMAlertController(title: "🙄", message: "لطفا تمامی مقادیر را تکمیل کنید")
            waitForAmountAlert.iconImage = UIImage(named: "tick")
            let cancel = EMAlertAction(title: "لغو", style: .cancel){
                
            }
            cancel.titleFont = UIFont(name: "IRANSans-Bold", size: 14)
            cancel.titleColor =  UIColor.init(red: 186/255, green: 186/255, blue: 186/255, alpha: 1)
            waitForAmountAlert.addAction(action: cancel)
            
            present(waitForAmountAlert, animated: true, completion: nil)
        }
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
        
        inputData["amount"] = selectedPrice
        inputData["cashbackAmount1"] = selectedPrice
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
      
            inputData["amount"] = selectedPrice
            inputData["cashbackAmount1"] = selectedPrice
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChargeTableViewCell
        
        cell.priceButton.tag = indexPath.row
        cell.priceButton.setTitle(priceArray[indexPath.row], for: .normal)
        cell.priceButton.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
        
        cell.priceContainer.layer.cornerRadius = 3
        cell.priceContainer.layer.borderWidth = 1
        cell.priceContainer.layer.borderColor = UIColor.colorWithHexString(baseHexString: "b4c8d7", alpha: 1).cgColor
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    @objc func buttonClicked(sender:UIButton!)
    {
        let btn:UIButton = sender
        let btnTag = btn.tag
        selectedPrice = priceArrayMap[btnTag]
        
        ResetButtons()
        
        let cell = chargePriceTableView.cellForRow(at: IndexPath(row: btnTag, section: 0)) as! ChargeTableViewCell
        cell.priceButton.setTitleColor(UIColor.colorWithHexString(baseHexString: "536e79", alpha: 1), for: .normal)
        cell.priceContainer.layer.cornerRadius = 3
        cell.priceContainer.layer.borderWidth = 1
        cell.priceContainer.layer.borderColor = UIColor.colorWithHexString(baseHexString: "4cb6ac", alpha: 1).cgColor
        cell.priceContainer.backgroundColor = UIColor.colorWithHexString(baseHexString: "ddf0ee", alpha: 1)
    }
    
    func ResetButtons()
    {
        for i in 0..<5
        {
            let cell = chargePriceTableView.cellForRow(at: IndexPath(row: i, section: 0)) as! ChargeTableViewCell
            cell.priceButton.setTitleColor(UIColor.colorWithHexString(baseHexString: "8fa1aa", alpha: 1), for: .normal)
            cell.priceContainer.layer.cornerRadius = 3
            cell.priceContainer.layer.borderWidth = 1
            cell.priceContainer.layer.borderColor = UIColor.colorWithHexString(baseHexString: "a8bdc7", alpha: 1).cgColor
            cell.priceContainer.backgroundColor = .white
        }
    }
    
    func UICustomization()
    {
        sendButton.layer.cornerRadius = 3
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
    
    @IBAction func phonenumberTextChanged(_ textField: UITextField) {
        if textField.text?.count == 11 {
            UIView.animate(withDuration: 0.6, animations: {() -> Void in
                self.chargePriceTableView.alpha = 1
            })
        }
        else
        {
            ResetButtons()
            UIView.animate(withDuration: 0.6, animations: {() -> Void in
                self.chargePriceTableView.alpha = 0
                
            })
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= 11 // Bool
    }
    
    @IBAction func ShowBLEList(_ sender: Any) {
        
        BBDeviceController.shared().startBTScan(nil, scanTimeout: 200);
        
        picker.title = "دستگاه ها"
        
        let values = BleList.sharedInstance.devices.map { TCPickerView.Value(title: ($0 as! EAAccessory).serialNumber) }
        picker.values = values
        picker.delegate = self
        picker.selection = .single
        picker.mainColor = UIColor.colorWithHexString(baseHexString: "46BECD", alpha: 1)
        picker.completion = { (selectedIndexes) in
            for i in selectedIndexes {
                print(values[i].title)
            }
        }
        picker.show()
    }
    
    func pickerView(_ pickerView: TCPickerView, didSelectRowAtIndex index: Int) {
        
        BBDeviceController.shared().connectBT(BleList.sharedInstance.devices[index] as! NSObject);
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
