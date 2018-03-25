//
//  LeftMenuViewController.swift
//  Bingo
//
//  Created by adb on 3/25/18.
//  Copyright © 2018 Teska. All rights reserved.
//

import UIKit

class LeftMenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var menuTitles:NSArray = NSArray()
    var menuImages:NSArray = NSArray()
    @IBOutlet weak var menuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        menuTitles = ["","","","",""]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
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
