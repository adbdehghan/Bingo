//
//  CheckBusinessInfoViewController.swift
//  Bingo
//
//  Created by adb on 4/5/18.
//  Copyright © 2018 Teska. All rights reserved.
//

import UIKit

class CheckBusinessInfoViewController: UIViewController {
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var shopNameContainerView: UIView!
    @IBOutlet weak var shopAddressContainerView: UIView!
    @IBOutlet weak var shopPhonenumberContainerView: UIView!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var shopAddressLabel: UILabel!
    @IBOutlet weak var shopPhonenumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.layer.cornerRadius = 4
        self.navigationItem.title = ""
        
        shopNameContainerView.layer.cornerRadius = 3
        shopAddressContainerView.layer.cornerRadius = 3
        shopPhonenumberContainerView.layer.cornerRadius = 3
        
        shopNameContainerView.layer.borderWidth = 1
        shopAddressContainerView.layer.borderWidth = 1
        shopPhonenumberContainerView.layer.borderWidth = 1
        
        shopNameContainerView.layer.borderColor = UIColor.colorWithHexString(baseHexString: "b4c8d7", alpha: 1).cgColor
        shopAddressContainerView.layer.borderColor = UIColor.colorWithHexString(baseHexString: "b4c8d7", alpha: 1).cgColor
        shopPhonenumberContainerView.layer.borderColor = UIColor.colorWithHexString(baseHexString: "b4c8d7", alpha: 1).cgColor
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
