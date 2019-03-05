//
//  PackingListViewController.swift
//  Food Bank
//
//  Created by Louis Lim Ying Wei on 17/3/18.
//  Edited by Ng Shirong
//  Copyright © 2018 Louis Lim Ying Wei. All rights reserved.
//

import UIKit
import Alamofire
import PopupDialog


class PackingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
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
    
    //Data lists
    var beneficiaryNameList =  [String]()
    var packingList = [String: [PackedItem]]()
    var packingListIDs = [Int]()
    var resultList = [Result]()
    
    override func viewDidAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
        initBeneficiaryList();
        self.beneficiaryNameList =  [String]()
        packingList = [String: [PackedItem]]()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    func initIntroLabel(){
        if beneficiaryNameList.isEmpty {
            introLabel.text = "There are currently no packing tasks"
        } else {
            introLabel.text = "Select a beneficiary packing list to continue. The number of items in the list is as indicated in the green labels"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beneficiaryNameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "packingListCellPageOne") as! PackingListCellPageOne
        var beneficiaryName : String = beneficiaryNameList[indexPath.row]
        var beneficiaryPackingListCount : Int = (packingList[beneficiaryName]?.count)!
        
        cell.cellPageOneDesc.text = beneficiaryName
        cell.cellPageOneCount.text = String(beneficiaryPackingListCount)
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initBeneficiaryList(){
        //activity indicator
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        // let url = URL(string: "http://54.255.192.219:8080/rest/packing/display/in-window")!
        let url = URL(string: "http://54.169.53.162:8080/rest/packing/display/in-window")!
        // let url = URL(string: "https://api.myjson.com/bins/1cy56n")!
        let headers: HTTPHeaders = ["Authorization": UserDefaults.standard.value(forKey: "token") as! String]
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if let json = response.result.value {
                let res = json as! NSDictionary
                if res["status"] as! String == "FAIL" {
                    print (res["message"]!)
                } else {
                    print(response.result)
                    var packingListResponse : PackingListResponse? = nil
                    do {
                        print("Packing list API message: ")
                        packingListResponse = try JSONDecoder().decode(PackingListResponse.self, from: response.data!)
                        
                        self.generatePackingList(packingListResponse : packingListResponse!)
                        
                    } catch {
                        print("Error from decoding packing list results")
                        print("Error info: \(error)")
                    }
                }
                self.initIntroLabel()
                //activity indicator
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func generatePackingList(packingListResponse : PackingListResponse){
        self.resultList.removeAll()
        beneficiaryNameList.removeAll()
        packingList.removeAll()
        packingListIDs.removeAll()
        self.resultList = packingListResponse.result
        for result in resultList{
            if !result.packingStatus {
                //we are only considering stuff which is not packed
                
                //need to pass this to the next controller
                let idOfPackingList = result.id
                let packingStatusOfPackingList = result.packingStatus
                
                packingListIDs.append(idOfPackingList!)
                self.resultList.append(result)
                beneficiaryNameList.append(result.beneficiary.name)
                //            print(result.beneficiary.name)
                packingList[result.beneficiary.name] = result.packedItems
            }
            
        }
        print("Page 1 - Print list of packing IDs")
        for i in packingListIDs{
            print(i)
        }
        print("End of packing IDs")
        self.tableView.reloadData()
        initIntroLabel()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let packView = storyboard?.instantiateViewController(withIdentifier: "packView") as! BeneficiaryPackViewController
        initBeneficiaryList()
        packView.packingListID = packingListIDs[indexPath.row]
//        packView.packingListID = resultList[indexPath.row].id
        packView.packList = packingList[beneficiaryNameList[indexPath.row]]
        var resultToPass : Result?
        
        for result in resultList {
            if result.id == packingListIDs[indexPath.row] {
                resultToPass = result
            }
        }
        packView.result = resultToPass
        
        //debugging statements
        print("Page 1: ")
        print(packingListIDs[indexPath.row])
        print(beneficiaryNameList[indexPath.row])
        print("Result list bene passed")
        print(resultList[indexPath.row].beneficiary.name)
        
        packView.navigationItem.hidesBackButton = true
        navigationController?.pushViewController(packView, animated: true)
    }
    
}


