//
//  BasketViewController.swift
//  Bingo
//
//  Created by adb on 3/17/18.
//  Copyright © 2018 Teska. All rights reserved.
//

import UIKit

class BasketViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var basketTableView: UITableView!
    @IBOutlet weak var basketSumLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomizeViews()
        let arr:[Double] = NSArray(array:BasketData.sharedInstance.items) as! [Double]
        let sum = arr.reduce(0, +)
        basketSumLabel.text?.append(" " + String(sum.withCommas()).replacedEnglishDigitsWithArabic)
    }

    func CustomizeViews()
    {
        basketTableView.layer.cornerRadius = 5
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return BasketData.sharedInstance.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BasketTableViewCell
        cell.priceLabel.text = String((BasketData.sharedInstance.items[indexPath.row] as! Double).withCommas().replacedEnglishDigitsWithArabic)
        cell.removeButton.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
        cell.removeButton.tag = indexPath.row;
        return cell
    }
    
    @objc func buttonClicked(sender:UIButton!) {
        let btnsendtag:UIButton = sender
        let tag = btnsendtag.tag
        BasketData.sharedInstance.items.removeObject(at: tag)
//        basketTableView.reloadData()
        let arr:[Double] = NSArray(array:BasketData.sharedInstance.items) as! [Double]
        let sum = arr.reduce(0, +)
        basketSumLabel.text = ""
        basketSumLabel.text?.append("مجموع " + String(sum.withCommas()).replacedEnglishDigitsWithArabic)
        basketTableView.beginUpdates()
        let indexPath = IndexPath(row: btnsendtag.tag, section: 0)
        basketTableView.deleteRows(at: [indexPath], with: .automatic)
        basketTableView.endUpdates()
    }
    
    @IBAction func CloseWindowEvent(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
