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
        menuImages = ["setting","gozareshat","darbare_ma","ertebat_ba_ma","rahnama"]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuTableViewCell
        cell.menuImage.image = UIImage(named:menuImages[indexPath.row] as! String)
        cell.menuButton.tag = indexPath.row
        cell.menuButton.tintColor = .lightGray
        cell.menuButton.addTarget(self, action:#selector(self.MenuTapped), for: .touchUpInside)
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    @objc func MenuTapped(sender:UIButton!)
    {
        let btnsendtag:UIButton = sender
        switch btnsendtag.tag {
        case 0:
            break
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
