//
//  BeneficiaryComfirmationViewController.swift
//  Food Bank
//
//  Created by Malcolm Ng Shirong on 30/3/18.
//  Copyright © 2018 Louis Lim Ying Wei. All rights reserved.
//

import UIKit
import Alamofire
import CodableFirebase
import PopupDialog

class BeneficiaryComfirmationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBAction func threeToOne(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func twoPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func previousPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logout(_ sender: Any) {
        let popup = PopupDialog(title: "Logout Confirmation", message: "Are you sure you want to logout?", image: nil)
        let cancelButton = CancelButton(title: "CANCEL") {
            print("CANCEL SUBMISSION")
        }
        let confirmButton = DefaultButton(title: "CONFIRM", height: 60) {
            UserDefaults.standard.set("", forKey: "token")
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(loginVC!, animated: true, completion: nil)
        }
        popup.addButtons([cancelButton, confirmButton])
        self.present(popup, animated: true, completion: nil)
    }
    
    @IBOutlet weak var introLabel: UILabel!
    //Data to catch from page 2
    var result : Result?
    var packingList : [PackedItem]?
    
    @IBOutlet weak var comfirmationTableView: UITableView!
    
    @IBAction func comfirmPressed(_ sender: Any) {
        //Code here for submiting of packing to API
        
        //Prepare data to be sent to URL
        self.result?.packingStatus = true
        self.result?.packedItems = packingList
        
        let url = URL(string: "http://54.169.53.162:8080/rest/packing/update-list")!
        let headers: HTTPHeaders = ["Authorization": UserDefaults.standard.value(forKey: "token") as! String]
        
        let parameters : Parameters = try! FirestoreEncoder().encode(result)
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if let json = response.result.value {
                let res = json as! NSDictionary
                if res["status"] as! String == "FAIL" {
                    print("THIS PACKING LIST HAS BEEN PACKED")
                    print (res["message"]!)
                } else {
                    print("Successfully Updated Packing")
                    
                }
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
        initIntroductionLabel()
        comfirmationTableView.delegate = self
        comfirmationTableView.dataSource = self
        comfirmationTableView.tableFooterView = UIView()
        comfirmationTableView.allowsSelection = false
        comfirmationTableView.showsVerticalScrollIndicator = true
    }
    
    func initIntroductionLabel(){
        var beneName : String = (self.result?.beneficiary.name)!
        introLabel.text = "Please check that all items for \(beneName) has been packed before comfirming"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = comfirmationTableView.dequeueReusableCell(withIdentifier: "headerCellComfirmation")
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (packingList?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = comfirmationTableView.dequeueReusableCell(withIdentifier: "comfirmationFoodItemCell") as! BeneficiaryComfirmationCell
        
        var packItem = packingList![indexPath.row]
        var foodItemDesc = packItem.description.replacingOccurrences(of: "-", with: " ")
        var packedQty = String(packItem.packedQuantity)
        
        cell.descLabel.text = foodItemDesc
        cell.packedQtyLabel.text = packedQty
        
        return cell
    }
    
}
