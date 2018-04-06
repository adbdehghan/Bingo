//
//  CheckPersonalInfoViewController.swift
//  Bingo
//
//  Created by adb on 4/5/18.
//  Copyright © 2018 Teska. All rights reserved.
//

import UIKit

class CheckPersonalInfoViewController: UIViewController {
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var fullnameContainerView: UIView!
    @IBOutlet weak var nationalIDContainerView: UIView!
    @IBOutlet weak var phonenumberContainerView: UIView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var nationalIDLabel: UILabel!
    @IBOutlet weak var phonenumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.layer.cornerRadius = 4
        self.navigationItem.title = ""
        fullnameContainerView.layer.cornerRadius = 3
        nationalIDContainerView.layer.cornerRadius = 3
        phonenumberContainerView.layer.cornerRadius = 3
        
        fullnameContainerView.layer.borderWidth = 1
        nationalIDContainerView.layer.borderWidth = 1
        phonenumberContainerView.layer.borderWidth = 1
        
        fullnameContainerView.layer.borderColor = UIColor.colorWithHexString(baseHexString: "b4c8d7", alpha: 1).cgColor
        nationalIDContainerView.layer.borderColor = UIColor.colorWithHexString(baseHexString: "b4c8d7", alpha: 1).cgColor
        phonenumberContainerView.layer.borderColor = UIColor.colorWithHexString(baseHexString: "b4c8d7", alpha: 1).cgColor
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
