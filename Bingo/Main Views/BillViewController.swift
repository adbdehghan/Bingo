//
//  BillViewController.swift
//  Bingo
//
//  Created by aDb on 4/4/18.
//  Copyright © 2018 Teska. All rights reserved.
//

import UIKit

class BillViewController: UIViewController {
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var barcodeButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UICustomization()
        
    }
    
    func UICustomization()
    {
        barcodeButton.layer.cornerRadius = 3
        sendButton.layer.cornerRadius = 3
        containerView.layer.cornerRadius = 3
        containerView.layer.shadowColor = UIColor.darkGray.cgColor
        containerView.layer.shadowOpacity = 0.4
        containerView.layer.shadowOffset = CGSize.init(width: 0, height: 1)
        containerView.layer.shadowRadius = 3
        
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
