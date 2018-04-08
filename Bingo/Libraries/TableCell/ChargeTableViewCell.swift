//
//  ChargeTableViewCell.swift
//  Bingo
//
//  Created by adb on 4/8/18.
//  Copyright © 2018 Teska. All rights reserved.
//

import UIKit

class ChargeTableViewCell: UITableViewCell {
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var priceContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
