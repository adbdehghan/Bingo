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
}
