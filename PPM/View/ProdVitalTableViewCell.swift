//
//  ProdVitalTableViewCell.swift
//  WP.m.1
//
//  Created by softevol on 9/19/18.
//  Copyright © 2018 softevol. All rights reserved.
//

import UIKit

class ProdVitalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var prodLbl: UILabel!
    @IBOutlet weak var resultLbl: UILabel!
    var text2 = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
