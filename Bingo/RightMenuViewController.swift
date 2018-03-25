//
//  RightMenuViewController.swift
//  Bingo
//
//  Created by adb on 3/25/18.
//  Copyright © 2018 Teska. All rights reserved.
//

import UIKit

class RightMenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var menuTitles:NSArray = NSArray()
    var menuImages:NSArray = NSArray()
    @IBOutlet weak var menuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTitles = ["","","","",""]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
