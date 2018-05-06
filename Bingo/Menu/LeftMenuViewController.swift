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
        menuImages = ["start_connection","start_connection_printer","print_sample","print_sample_simply_print"]
        menuTitles = ["start connection","start connection printer","print sample","print sample simply print"]
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
        cell.titleLabel.text = (menuTitles[indexPath.row] as! String)
        cell.titleLabel.numberOfLines = 0
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
        return 120
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
