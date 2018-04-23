//
//  AppDelegate.swift
//  Bingo
//
//  Created by adb on 3/10/18.
//  Copyright © 2018 Teska. All rights reserved.
//

import UIKit
import DualSlideMenu
import IQKeyboardManagerSwift
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?    
    var storyboard: UIStoryboard?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        IQKeyboardManager.sharedManager().enable = true
        window = UIWindow(frame: UIScreen.main.bounds)
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        UIView.appearance().semanticContentAttribute = .forceLeftToRight

        let leftView = storyboard?.instantiateViewController(withIdentifier: "LeftMenuController")
        let rightView = storyboard?.instantiateViewController(withIdentifier: "RightMenuController")
        let mainView = storyboard?.instantiateViewController(withIdentifier: "MainController")

        let controller = DualSlideMenuViewController(mainViewController: mainView!, leftMenuViewController: leftView!, rightMenuViewController: rightView!)
        controller.leftSideOffset = 275
        controller.rightSideOffset = 275
        window!.rootViewController = controller
        window!.makeKeyAndVisible()
        
        if #available(iOS 10.0, *) {
            UITabBar.appearance().unselectedItemTintColor = UIColor.white
        } else {
            if let items = UITabBar.appearance().items {
                let tabBarImages = getTabBarImages() // tabBarImages: [UIImage]
                for i in 0..<items.count {
                    let tabBarItem = items[i]
                    let tabBarImage = tabBarImages[i]
                    tabBarItem.image = tabBarImage.withRenderingMode(.alwaysOriginal)
                    tabBarItem.selectedImage = tabBarImage
                }
            }
        }
        UINavigationBar.appearance().tintColor = UIColor.white
        UITabBarItem.appearance()
            .setTitleTextAttributes(
                [NSAttributedStringKey.font: UIFont(name: "IRANSans-Medium", size: 11)!],
                for: .normal)
        
        UITabBarItem.appearance()
            .setTitleTextAttributes(
                [NSAttributedStringKey.font: UIFont(name: "IRANSans-Medium", size: 11)!],
                for: .selected)
        return true
    }
    
    func getTabBarImages() -> [UIImage]
    {
        return [UIImage(named:"kharid")!,UIImage(named:"sharje_mostaghim")!,UIImage(named:"pardakht_ghabz")!,UIImage(named:"balance")!]
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

