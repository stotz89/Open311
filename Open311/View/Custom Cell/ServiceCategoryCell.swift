//
//  ServiceCategoryCell.swift
//  Hello World
//
//  Created by Philipp Stotz on 26.01.18.
//  Copyright © 2018 Philipp Stotz. All rights reserved.
//

import UIKit

class ServiceCategoryCell: UITableViewCell {

    @IBOutlet weak var categoryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
