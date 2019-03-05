//
//  BeneficiaryPackViewController.swift
//  Food Bank
//
//  Created by Malcolm Ng Shirong on 27/3/18.
//  Copyright © 2018 Louis Lim Ying Wei. All rights reserved.
//

import UIKit
import StompClientLib
import DropDown
import Alamofire
import M13Checkbox
import PopupDialog

class BeneficiaryPackViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, StompClientLibDelegate {
    
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var threeButton: RoundButton!
    
    var result : Result?
    var beneToLoad : String?
    var packList : [PackedItem]?
    var packingListID : Int?
    
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
    
    @IBAction func pageThreePressed(_ sender: Any) {
        socketClient.disconnect()
        let confirmView =  storyboard?.instantiateViewController(withIdentifier: "confirmView") as! BeneficiaryComfirmationViewController
        confirmView.result = self.result
        confirmView.packingList = self.packList
        confirmView.navigationItem.hidesBackButton = true
        navigationController?.pushViewController(confirmView, animated: true)
    }
    
    @IBAction func previousPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func pageOnePressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        socketClient.disconnect()
        let confirmView =  storyboard?.instantiateViewController(withIdentifier: "confirmView") as! BeneficiaryComfirmationViewController
        confirmView.result = self.result
        confirmView.packingList = self.packList
        confirmView.navigationItem.hidesBackButton = true
        navigationController?.pushViewController(confirmView, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        
        nextButton.isEnabled = false
        nextButton.alpha = 0.5
        
        threeButton.isEnabled = false
        threeButton.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        
        let url = NSURL(string: "ws://54.169.53.162:8080/websocket-connection/websocket")!
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url as URL), delegate: self)
        
        checkBasketComplete()
        initIntroductionLabel()
    }
    
    func initIntroductionLabel(){
        var beneName : String = (self.result?.beneficiary.name)!
        introLabel.text = "You are now packing for \(beneName)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (packList?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Preparing data to send to cells
        var packItem = packList![indexPath.row]
        var desc = packItem.description
        var allocatedQty = String(packItem.allocatedQuantity)
        var description = desc?.replacingOccurrences(of: "-", with: " ")
        var packQtyList : [String] = []
        for num in 0...packItem.allocatedQuantity!{
            packQtyList.append(String(num))
        }
        var packedQty : String = String(packItem.packedQuantity)
        var checkBoxBool : Bool = packItem.itemPackingStatus
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodItemCell") as! PackingListCellPageTwo
        cell.packedCheckboxButton.tag = indexPath.row
        //Calling method when button is pressed

        cell.packedQtyDropdownButton.addTarget(self, action: #selector(self.dropDownBtnAction(_:)), for: .editingChanged)
        cell.packedCheckboxButton.addTarget(self, action: #selector(self.checkBoxBtnAction(_:)), for: .allEvents)
        
//        cell.initCell(desc: description!, allocatedQty: allocatedQty, packedQuantityList: packQtyList)
        cell.itemDescLabel.text = description
        cell.allocatedQtyLabel.text = allocatedQty
        cell.packedQuantityList = packQtyList
        cell.selectedPackedQuantity = packedQty
        cell.selectedCompleteItem = checkBoxBool
        cell.packedQtyDropdownButton.setTitle(packedQty, for: .normal)
        
        cell.packedQtyDropdown.dataSource = packQtyList
        cell.packedQtyDropdown.selectionAction = { [weak self] (index, item) in
            cell.packedQtyDropdownButton.setTitle(item, for: .normal)
            cell.selectedPackedQuantity = item
            cell.packedQtyDropdownButton.sendActions(for: .editingChanged)
        }
        
        if checkBoxBool {
            cell.packedCheckboxButton.setCheckState(M13Checkbox.CheckState.checked, animated: false)
        } else {
            cell.packedCheckboxButton.setCheckState(M13Checkbox.CheckState.unchecked, animated: false)
        }
        
        var number = cell.selectedPackedQuantity
        checkBasketComplete()
        return cell
    }
    
    @objc func dropDownBtnAction(_ sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: tableView as UIView)
        let indexPath: IndexPath! = tableView.indexPathForRow(at: point)
        let cell = tableView.cellForRow(at: indexPath) as! PackingListCellPageTwo
        print("index path: " + String(indexPath.row) + " | " + cell.selectedPackedQuantity)
        self.packList![indexPath.row].packedQuantity = Int(cell.selectedPackedQuantity)
        sendToListener(itemIndex: indexPath.row, packedQuantity: Int(cell.selectedPackedQuantity)!, itemPackingStatus: cell.selectedCompleteItem)
        
        print("Dropdown pressed")
    }
    
    @objc func checkBoxBtnAction(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView as UIView)
        let indexPath: IndexPath! = tableView.indexPathForRow(at: point)
        let cell = tableView.cellForRow(at: indexPath) as! PackingListCellPageTwo
        
//        cell.changeCheckboxStatus()
        cell.selectedCompleteItem = !cell.selectedCompleteItem
        
        if cell.selectedCompleteItem {
            cell.packedCheckboxButton.setCheckState(M13Checkbox.CheckState.checked, animated: false)
        } else {
            cell.packedCheckboxButton.setCheckState(M13Checkbox.CheckState.unchecked, animated: false)
        }
        
        self.packList![indexPath.row].itemPackingStatus = cell.selectedCompleteItem
        
        if(!cell.selectedCompleteItem){
            //this is when the user unchecks the box
            packList![indexPath.row].itemPackingStatus = false
        } else {
            //this is when the user checks the box
            packList![indexPath.row].packedQuantity = Int(cell.selectedPackedQuantity)     //this is the pack item which we need to change it's packed quantity
            packList![indexPath.row].itemPackingStatus = true
        }
        sendToListener(itemIndex: indexPath.row, packedQuantity: Int(cell.selectedPackedQuantity)!, itemPackingStatus: cell.selectedCompleteItem)
        checkBasketComplete()
        
        print("index path: " + String(indexPath.row) + " | " + String(cell.selectedCompleteItem))
        print("Checkbox Pressed")
        
    }
    
    func checkBasketComplete(){
        var basketComplete = true
        
        for packItem in packList!{
            if packItem.itemPackingStatus == false{
                basketComplete = false
                break
            }
        }
        if basketComplete{
            //reveal submit button
            nextButton.isEnabled = true
            nextButton.alpha = 1
            
            threeButton.isEnabled = true
            threeButton.backgroundColor = UIColor(red: 47/255, green: 51/255, blue: 61/255, alpha: 0.7)
            
        } else{
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
            
            threeButton.isEnabled = false
            threeButton.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        }
    }

    //Below here is for the Websocket
    
    var socketClient = StompClientLib()
    var topic = ""
    var listener = ""
    
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, withHeader header: [String : String]?, withDestination destination: String) {
//        print("received stompClient")
    }
    
    func stompClientJSONBody(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        print("received stompClientJSONBODY")
//        print("JSON Body : \(String(describing: jsonBody))")
//        var webSocketResult : Result? = nil
        do{
            var webSocketResult = try JSONDecoder().decode(Result.self, from: (jsonBody?.data(using: .utf8))!)
//            print(webSocketResult?.packedItems[0].itemPackingStatus!)
            packList?.removeAll()
            for packItem in webSocketResult.packedItems {
                packList?.append(packItem)
            }
            tableView.reloadData()
        } catch {
            print("Error from reading web socket json")
        }
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("disconnected")
    }
    
    func sendToListener(itemIndex : Int, packedQuantity : Int, itemPackingStatus: Bool){
        //when checkbox is clicked or dropdown is clicked, this method is called to send to listener
        socketClient.sendJSONForDict(dict: [
            "id": packingListID!,
            "itemIndex" : itemIndex,
            "packedQuantity" : packedQuantity,
            "itemPackingStatus" : itemPackingStatus
            ] as AnyObject, toDestination: self.listener)
        
    }
    
    func stompClientDidConnect(client: StompClientLib!) {
        print("connected to id")
        let id : Int = packingListID!
        print(id)
        topic = "/client/packing/\(id)"
        listener = "/app/server/packing/\(id)"
        socketClient.subscribe(destination: topic)
        //To get initial packinglist
        socketClient.sendJSONForDict(dict: [
            "id": id,
            "itemIndex" : -1,
            "packedQuantity" : 0,
            "itemPackingStatus" : false
            ] as AnyObject, toDestination: listener)
    }
    
    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        print("sentReceipt")
    }
    
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print("error")
    }
    
    func serverDidSendPing() {
        print("pingpong")
    }
    
}
