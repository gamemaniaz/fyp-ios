//
//  PackingListCellPageTwo.swift
//  Food Bank
//
//  Created by Malcolm Ng Shirong on 28/3/18.
//  Copyright © 2018 Louis Lim Ying Wei. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import M13Checkbox

class PackingListCellPageTwo: UITableViewCell {
    
    //UI Cell Elements
    @IBOutlet weak var allocatedQtyLabel: UILabel!
    @IBOutlet weak var itemDescLabel: UILabel!
    @IBOutlet weak var packedQtyDropdownButton: PackingListDropdownButton!
    @IBOutlet weak var packedCheckboxButton: M13Checkbox!
    
    //Dropdown Object
    let packedQtyDropdown = DropDown()
    
    
    //Data list for dropdown
    var packedQuantityList : [String] = []
    
    //Selected Inputs
    var selectedPackedQuantity = "0"
    var selectedCompleteItem = false
    
    @IBAction func selectPackedQty(_ sender: Any) {
        packedQtyDropdown.show()
    }
    
    override func awakeFromNib() {
        packedQtyDropdown.width = frame.width - 100
        packedCheckboxButton.boxType = .square
    }
    
    func changeCheckboxStatus(){
        selectedCompleteItem = !selectedCompleteItem
    }
    
    func initPackCheckbox(){
        packedCheckboxButton.boxType = .square
        packedCheckboxButton.tintColor = UIColor(red:0.29, green:0.70, blue:0.40, alpha:1.0)
        packedCheckboxButton.animationDuration = 0.1
    }

}
