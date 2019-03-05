//
//  PackingListCellPageOne.swift
//  Food Bank
//
//  Created by Malcolm Ng Shirong on 31/3/18.
//  Copyright © 2018 Louis Lim Ying Wei. All rights reserved.
//

import UIKit

class PackingListCellPageOne: UITableViewCell {

    
    @IBOutlet weak var cellPageOneDesc: UILabel!
    
    @IBOutlet weak var cellPageOneCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
