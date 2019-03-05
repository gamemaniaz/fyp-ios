//
//  BeneficiaryComfirmationCell.swift
//  Food Bank
//
//  Created by Malcolm Ng Shirong on 30/3/18.
//  Copyright © 2018 Louis Lim Ying Wei. All rights reserved.
//

import UIKit

class BeneficiaryComfirmationCell: UITableViewCell {

    @IBOutlet weak var packedQtyLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //BeneficiaryComfirmationViewController to call this method and pass in parameters to display packedQtyLabel and descLabel
    func initCell(){
        
    }

}
