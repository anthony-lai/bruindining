//
//  FoodCell.swift
//  BruinDining
//
//  Created by Anthony Lai on 1/15/17.
//  Copyright © 2017 Anthony Lai. All rights reserved.
//

import UIKit

class FoodCell: UITableViewCell {

    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var a: UIImageView!
    @IBOutlet weak var b: UIImageView!
    @IBOutlet weak var c: UIImageView!
    @IBOutlet weak var d: UIImageView!
    @IBOutlet weak var e: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
