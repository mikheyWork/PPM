//
//  ManufacturersTVCell.swift
//  WP.m.1
//
//  Created by softevol on 9/12/18.
//  Copyright © 2018 softevol. All rights reserved.
//

import UIKit

class ManufacturersTVCell: UITableViewCell {
    
    
    @IBOutlet weak var createrLabel: UILabel!
    @IBOutlet weak var resaultLabel: UILabel!
    
    @IBAction func starBut(_ sender: Any) {
        print("Work flow aaa")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
