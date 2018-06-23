//
//  DateHelper.swift
//  Bingo
//
//  Created by adb on 5/14/18.
//  Copyright © 2018 Teska. All rights reserved.
//

import UIKit

class DateHelper: NSObject {
    
    static public func GetLocalTime() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter.string(from:Date())
    }
    static public func GetLocalDate() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
       return dateFormatter.string(from: Date())
    }
    
   static public func GenerateRandomDigits(_ digitNumber: Int) -> String {
        var number = ""
        for i in 0..<digitNumber {
            var randomNumber = arc4random_uniform(10)
            while randomNumber == 0 && i == 0 {
                randomNumber = arc4random_uniform(10)
            }
            number += "\(randomNumber)"
        }
        return number
    }
}
