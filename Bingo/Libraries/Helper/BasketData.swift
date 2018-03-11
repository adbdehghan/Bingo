//
//  GlobalData.swift
//  Distract Free
//
//  Created by adb on 2/19/18.
//  Copyright © 2018 Arena. All rights reserved.
//

import UIKit

class BasketData: NSObject {
    static let sharedInstance = BasketData()
    var items:NSMutableArray = NSMutableArray()    
}
