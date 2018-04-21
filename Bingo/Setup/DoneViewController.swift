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
}
