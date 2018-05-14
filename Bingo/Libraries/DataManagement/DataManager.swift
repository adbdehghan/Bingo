//
//  DataManager.swift
//  Radio Event
//
//  Created by adb on 1/1/18.
//  Copyright © 2018 Arena. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


protocol DataManagerDelegate :class {
    func didFinishTask(Data: [APIResponse])
}
class DataManager: NSObject {

    var baseURL = "https://sayan.shaparak.ir/mpos/rest/api/v0/"
    var delegate:DataManagerDelegate?    
    var terminalId = "70439955";
    var merchantId = "000000666351453";
    
    func RegisterNumber(phonenumber:String,completion: @escaping (APIResponse) -> Void) {
        
        let params: [String: Any] = ["phone":phonenumber]
        let response = APIResponse()
        
        Alamofire.request(baseURL+"login", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                
                print(responseData)
                //to get status code
                if let status = responseData.response?.statusCode {
                    switch(status){
                    case 200:
                        if let resData = JSON(responseData.result.value!).dictionaryObject {
                            if resData.count > 0 {
                                response.message = resData["message"] as? String
                                response.result = resData["result"] as? Bool
                            }
                        }
                    default:
                        print("error with response status: \(status)")
                    }
                }
                
                
            }
            completion(response)
        }
    }
    
    
    func ChangeKey(Code:String,phonenumber:String,completion: @escaping (APIResponse) -> Void) {
        
        let params: [String: Any] = ["phone":phonenumber,"password":Code]
        let response = APIResponse()
        
        Alamofire.request(baseURL+"gettoken", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                
                print(responseData)
                //to get status code
                if let status = responseData.response?.statusCode {
                    switch(status){
                    case 200:
                        if let resData = JSON(responseData.result.value!).dictionaryObject {
                            if resData.count > 0 {
                                response.message = resData["message"] as? String
                                response.result = true
                                response.token = resData["token"] as? String
                            }
                        }
                    default:
                        if let resData = JSON(responseData.result.value!).dictionaryObject {
                            if resData.count > 0 {
                                response.message = resData["message"] as? String
                                response.result = false
                            }
                        }
                        print("error with response status: \(status)")
                    }
                }
                
                
            }
            completion(response)
        }
    }
    
    func CheckCode(Code:String,phonenumber:String,completion: @escaping (APIResponse) -> Void) {
        
        let params: [String: Any] = ["phone":phonenumber,"password":Code]
        let response = APIResponse()
        
        Alamofire.request(baseURL+"gettoken", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                
                print(responseData)
                //to get status code
                if let status = responseData.response?.statusCode {
                    switch(status){
                    case 200:
                        if let resData = JSON(responseData.result.value!).dictionaryObject {
                            if resData.count > 0 {
                                response.message = resData["message"] as? String
                                response.result = true
                                response.token = resData["token"] as? String   
                            }
                        }
                    default:
                        if let resData = JSON(responseData.result.value!).dictionaryObject {
                            if resData.count > 0 {
                                response.message = resData["message"] as? String
                                response.result = false                                
                            }
                        }
                        print("error with response status: \(status)")
                    }
                }
                
                
            }
            completion(response)
        }
    }
    
    func PostRecords(dateTime:String,speed:Double,latitude:Double,longitude:Double,phoneBattery:Int,userState:String,blutoothState:Bool,gpsState:Bool,beacons:[String],distances:[String],completion: @escaping (APIResponse) -> Void) {
        
        let params: [String: Any] = ["datetime":dateTime,"speed":speed,"latitude":latitude,"longitude":longitude,"phone_battery":phoneBattery,"user_state":userState,"blutooth_state":blutoothState,"gps_state":gpsState,"beacons":beacons,"distances":distances]
        let response = APIResponse()
        
        let headers = [
            "Authorization": "Bearer " + TokenManager().Token,
            "Accept":"application/json"
            ]

        Alamofire.request(baseURL+"newrecord", method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                
                print(responseData)
                //to get status code
                if let status = responseData.response?.statusCode {
                    switch(status){
                    case 200:
                        if let resData = JSON(responseData.result.value!).dictionaryObject {
                            if resData.count > 0 {
                                response.message = resData["message"] as? String
                                response.result = resData["result"] as? Bool
                            }
                        }
                    default:
                        if let resData = JSON(responseData.result.value!).dictionaryObject {
                            if resData.count > 0 {
                                response.message = resData["message"] as? String
                                response.result = false
                            }
                        }
                        print("error with response status: \(status)")
                    }
                }
                
                
            }
            completion(response)
        }
    }
    
}
