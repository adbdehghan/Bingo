//
//  DoneViewController.swift
//  Bingo
//
//  Created by adb on 4/5/18.
//  Copyright © 2018 Teska. All rights reserved.
//

import UIKit
import DualSlideMenu

class DoneViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    var window: UIWindow?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        startButton.layer.cornerRadius = 4
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ActiveEvent(_ sender: Any) {
        var storyboard: UIStoryboard?
        window = UIWindow(frame: UIScreen.main.bounds)
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let leftView = storyboard?.instantiateViewController(withIdentifier: "LeftMenuController")
        let rightView = storyboard?.instantiateViewController(withIdentifier: "RightMenuController")
        let mainView = storyboard?.instantiateViewController(withIdentifier: "MainController")
        
        let controller = DualSlideMenuViewController(mainViewController: mainView!, leftMenuViewController: leftView!, rightMenuViewController: rightView!)
        controller.leftSideOffset = 275
        controller.rightSideOffset = 275
        
        

        UIView.transition(with: window!, duration: 0.7, options: .transitionCrossDissolve, animations: {
            self.window!.rootViewController = controller
            self.window!.makeKeyAndVisible()
        }, completion: { completed in
            // maybe do something here
        })
        
//        UIView.transition(from: self.view, to: controller.view, duration: 0.4, options: [.transitionFlipFromBottom], completion: {
//            _ in
//            self.window!.rootViewController = controller
//        })
        

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
