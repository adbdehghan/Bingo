//
//  BleList.swift
//  Bingo
//
//  Created by adb on 4/9/18.
//  Copyright © 2018 Teska. All rights reserved.
//

import UIKit

class BleList: NSObject {
    static let sharedInstance = BleList()
    var devices:NSMutableArray = NSMutableArray()
    var isConnected:Bool = false
    var batteryPercentage:Double = 0
}
