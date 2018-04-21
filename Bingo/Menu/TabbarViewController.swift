//
//  TabbarViewController.swift
//  Bingo
//
//  Created by adb on 4/21/18.
//  Copyright © 2018 Teska. All rights reserved.
//

import UIKit
import TIHexColor

class TabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = self.tabBar.items {
            let tabBarImages = getTabBarImages()
            for i in 0..<items.count {
                let tabBarItem = items[i]
                let tabBarImage = tabBarImages[i]
                tabBarItem.image = tabBarImage.withRenderingMode(.alwaysOriginal)
                tabBarItem.selectedImage = tabBarImage
                let attributes = [NSAttributedStringKey.font:UIFont(name: "IRANSans-Medium", size: 11)!,NSAttributedStringKey.foregroundColor:UIColor.white]
                tabBarItem.setTitleTextAttributes(attributes, for: .normal)
                
                let attributesActive = [NSAttributedStringKey.font:UIFont(name: "IRANSans-Medium", size: 11)!,NSAttributedStringKey.foregroundColor:UIColor.colorWithHexString(baseHexString: "46BECD", alpha: 1)]
                tabBarItem.setTitleTextAttributes(attributesActive, for: .selected)
            }
        }
    }
    
    func getTabBarImages() -> [UIImage]
    {
        return [UIImage(named:"kharid")!,UIImage(named:"sharje_mostaghim")!,UIImage(named:"pardakht_ghabz")!,UIImage(named:"balance")!]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
