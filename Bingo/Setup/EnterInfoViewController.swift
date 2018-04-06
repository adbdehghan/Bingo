//
//  EnterInfoViewController.swift
//  Bingo
//
//  Created by adb on 4/4/18.
//  Copyright © 2018 Teska. All rights reserved.
//

import UIKit

class EnterInfoViewController: UIViewController {

    @IBOutlet weak var phoneNumberTextField: TweeAttributedTextField!
    @IBOutlet weak var ActiveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ActiveButton.layer.cornerRadius = 4
        self.navigationItem.title = ""
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ActiveEvent(_ sender: Any) {
        performSegue(withIdentifier: "next", sender: self)
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
