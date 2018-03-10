//
//  BuyViewController.swift
//  Bingo
//
//  Created by adb on 3/10/18.
//  Copyright © 2018 Teska. All rights reserved.
//

import UIKit

class BuyViewController: UIViewController {

    @IBOutlet weak var functionView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CustomizeViews()
    
    }
    
    func CustomizeViews()
    {
        functionView.layer.cornerRadius = 3
        functionView.layer.shadowColor = UIColor.darkGray.cgColor
        functionView.layer.shadowOpacity = 0.4
        functionView.layer.shadowOffset = CGSize.init(width: 0, height: 1)
        functionView.layer.shadowRadius = 3
        
        
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
