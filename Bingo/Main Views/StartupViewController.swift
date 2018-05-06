//
//  StartupViewController.swift
//  Bingo
//
//  Created by adb on 4/30/18.
//  Copyright © 2018 Teska. All rights reserved.
//

import UIKit
import Firebase
import DualSlideMenu

class StartupViewController: UIViewController {
    @IBOutlet weak var versionLabel: UILabel!
    var remoteConfig: RemoteConfig!
    let versionConfigKey = "minimum_force_update_version"
    var remoteVersion = ""
    var currentVersion = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // [START get_remote_config_instance]
        remoteConfig = RemoteConfig.remoteConfig()
        // [END get_remote_config_instance]
        
        // Create a Remote Config Setting to enable developer mode, which you can use to increase
        // the number of fetches available per hour during development. See Best Practices in the
        // README for more information.
        // [START enable_dev_mode]
        let remoteConfigSettings = RemoteConfigSettings(developerModeEnabled: true)
        remoteConfig.configSettings = remoteConfigSettings!
        // [END enable_dev_mode]
        
        // Set default Remote Config parameter values. An app uses the in-app default values, and
        // when you need to adjust those defaults, you set an updated value for only the values you
        // want to change in the Firebase console. See Best Practices in the README for more
        // information.
        // [START set_default_values]
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        fetchConfig()
        
    }
    
    func fetchConfig() {
        remoteVersion = remoteConfig[versionConfigKey].stringValue!
        
        var expirationDuration = 3600
        // If your app is using developer mode, expirationDuration is set to 0, so each fetch will
        // retrieve values from the service.
        if remoteConfig.configSettings.isDeveloperModeEnabled {
            expirationDuration = 0
        }
        
        // [START fetch_config_with_callback]
        // TimeInterval is set to expirationDuration here, indicating the next fetch request will use
        // data fetched from the Remote Config service, rather than cached parameter values, if cached
        // parameter values are more than expirationDuration seconds old. See Best Practices in the
        // README for more information.
        
        remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self.remoteConfig.activateFetched()
//                var welcomeMessage = self.remoteConfig[self.versionConfigKey].stringValue
                self.versionLabel.text = self.remoteVersion
                
                if  self.remoteVersion != self.currentVersion
                {
                    
                    self.GotoMain()
                    
                }
                else {
                    self.GotoMain()
                }
                
                
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
                
                self.GotoMain()
            }
            
        }
        // [END fetch_config_with_callback]
        
 
    }
    
    func GotoMain()
    {
        let leftView = storyboard?.instantiateViewController(withIdentifier: "LeftMenuController")
        let rightView = storyboard?.instantiateViewController(withIdentifier: "RightMenuController")
        let mainView = storyboard?.instantiateViewController(withIdentifier: "MainController")
        
        let controller = DualSlideMenuViewController(mainViewController: mainView!, leftMenuViewController: leftView!, rightMenuViewController: rightView!)
        controller.leftSideOffset = 275
        controller.rightSideOffset = 275
        
        UIView.transition(with: self.view!, duration: 0.7, options: .transitionCrossDissolve, animations: {
            self.view.window?.rootViewController = controller
            self.view.window?.makeKeyAndVisible()
        }, completion: { completed in
            // maybe do something here
        })
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
