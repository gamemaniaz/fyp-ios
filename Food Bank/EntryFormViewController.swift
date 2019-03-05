//
//  EntryFormViewController.swift
//  Food Bank
//
//  Created by Louis Lim Ying Wei on 17/3/18.
//  Copyright © 2018 Louis Lim Ying Wei. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import M13Checkbox
import PopupDialog
import Toaster

class EntryFormViewController: UIViewController, UITextFieldDelegate {
    
    // Flags
    var othersFieldPresent = false
    var checkBoxesInit = false
    
    // Constraints
    var categoryTopConstraint: NSLayoutConstraint!
    
    // Activity Indicator
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // UI View
    @IBOutlet weak var fullFormView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // UI Labels
    @IBOutlet weak var donorLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var classificationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var measurementLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var nonHalalLabel: UILabel!
    @IBOutlet weak var halalLabel: UILabel!
    
    // UI Dropdown Buttons
    @IBOutlet weak var donorDropdownButton: DropdownButton!
    @IBOutlet weak var categoryDropdownButton: DropdownButton!
    @IBOutlet weak var classificationDropdownButton: DropdownButton!
    @IBOutlet weak var descriptionDropdownButton: DropdownButton!
    @IBOutlet weak var unitDropdownButton: DropdownButton!
    @IBOutlet weak var measurementDropdownButton: DropdownButton!
    
    // UI Submit Button
    @IBOutlet weak var submitButton: UIButton!
    
    //UI Text Fields
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var newDonorTextField: UITextField!
    var activeTextField: UITextField!
    
    // UI Checkboxes
    @IBOutlet weak var nonHalalCheckbox: M13Checkbox!
    @IBOutlet weak var halalCheckbox: M13Checkbox!
    
    // Data Lists
    var donorsList: [String] = []
    var categoryList: [String] = []
    var classificationList: [String] = []
    var descriptionList: [String] = []
    var unitMap = [
        "g": "g (gram)",
        "kg": "kg (kilogram)",
        "ml": "ml (millilitre)",
        "l": "l (litre)"
    ]
    var unitList: [String] = [
        "",
        "g (gram)",
        "kg (kilogram)",
        "ml (millilitre)",
        "l (litre)"
    ]
    var measurementMap = [
        "50": "50 (1 - 99)",
        "150": "150 (100 - 199)",
        "250": "250 (200 - 299)",
        "350": "350 (300 - 399)",
        "450": "450 (400 - 499)",
        "550": "550 (500 - 599)",
        "650": "650 (600 - 699)",
        "750": "750 (700 - 799)",
        "850": "850 (800 - 899)",
        "950": "950 (900 - 999)",
        "1.5": "1.5 (1.00 - 1.99)",
        "2.5": "2.5 (2.00 - 2.99)",
        "3.5": "3.5 (3.00 - 3.99)",
        "4.5": "4.5 (4.00 - 4.99)",
        "5.5": "5.5 (5.00 - 5.99)",
        "6.5": "6.5 (6.00 - 6.99)",
        "7.5": "7.5 (7.00 - 7.99)",
        "8.5": "8.5 (8.00 - 8.99)",
        "9.5": "9.5 (9.00 - 9.99)",
        "10.5": "10.5 (10.00 - 10.99)",
        "11.5": "11.5 (11.00 - 11.99)",
        "12.5": "12.5 (12.00 - 12.99)",
        "13.5": "13.5 (13.00 - 13.99)",
        "14.5": "14.5 (14.00 - 14.99)",
        "15.5": "15.5 (15.00 - 15.99)",
        "16.5": "16.5 (16.00 - 16.99)",
        "17.5": "17.5 (17.00 - 17.99)",
        "18.5": "18.5 (18.00 - 18.99)",
        "19.5": "19.5 (19.00 - 19.99)"
    ]
    var measurementList: [String] = []
    var measurementListA = [
        "",
        "50 (1 - 99)",
        "150 (100 - 199)",
        "250 (200 - 299)",
        "350 (300 - 399)",
        "450 (400 - 499)",
        "550 (500 - 599)",
        "650 (600 - 699)",
        "750 (700 - 799)",
        "850 (800 - 899)",
        "950 (900 - 999)",
    ]
    var measurementListB = [
        "",
        "1.5 (1.00 - 1.99)",
        "2.5 (2.00 - 2.99)",
        "3.5 (3.00 - 3.99)",
        "4.5 (4.00 - 4.99)",
        "5.5 (5.00 - 5.99)",
        "6.5 (6.00 - 6.99)",
        "7.5 (7.00 - 7.99)",
        "8.5 (8.00 - 8.99)",
        "9.5 (9.00 - 9.99)",
        "10.5 (10.00 - 10.99)",
        "11.5 (11.00 - 11.99)",
        "12.5 (12.00 - 12.99)",
        "13.5 (13.00 - 13.99)",
        "14.5 (14.00 - 14.99)",
        "15.5 (15.00 - 15.99)",
        "16.5 (16.00 - 16.99)",
        "17.5 (17.00 - 17.99)",
        "18.5 (18.00 - 18.99)",
        "19.5 (19.00 - 19.99)"
    ]
    var inventoryList: [[String: AnyObject]] = [[:]]
    var inventoryMap: [String:[String:[String]]] = [:]
    var barcodeResponse: [String: String] = [:]
    
    // Dropdown Objects
    let donorDropdown = DropDown()
    let categoryDropdown = DropDown()
    let classificationDropdown = DropDown()
    let descriptionDropdown = DropDown()
    let unitDropdown = DropDown()
    let measurementDropdown = DropDown()
    
    // Selected Inputs
    var selectedDonor = ""
    var selectedCategory = ""
    var selectedClassification = ""
    var selectedDescription = ""
    var selectedUnit = ""
    var selectedMeasurement = ""
    var selectedQuantity = 0
    var selectedHalal = false
    
    /* INITIALIZATION */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTopConstraint = categoryLabel.topAnchor.constraint(equalTo: donorDropdownButton.bottomAnchor, constant: 20)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryDropdownButton.setTitleColor(UIColor(red:0.45, green:0.45, blue:0.45, alpha:1.0), for: .disabled)
        classificationDropdownButton.setTitleColor(UIColor(red:0.45, green:0.45, blue:0.45, alpha:1.0), for: .disabled)
        descriptionDropdownButton.setTitleColor(UIColor(red:0.45, green:0.45, blue:0.45, alpha:1.0), for: .disabled)
        unitDropdownButton.setTitleColor(UIColor(red:0.45, green:0.45, blue:0.45, alpha:1.0), for: .disabled)
        measurementDropdownButton.setTitleColor(UIColor(red:0.45, green:0.45, blue:0.45, alpha:1.0), for: .disabled)
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
    
    override func viewDidAppear(_ animated: Bool) {
        initViewElements()
        resetFields()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        categoryTopConstraint.constant = 20
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }

    /* USER ACTION FUNCTIONS */
    
    @IBAction func selectDonor(_ sender: Any) {
        donorDropdown.show()
    }
    
    @IBAction func enterDonor(_ sender: Any) {
        validateForm()
    }
    
    @IBAction func selectCategory(_ sender: Any) {
        categoryDropdown.show()
    }
    
    @IBAction func selectClassification(_ sender: Any) {
        classificationDropdown.show()
    }
    
    @IBAction func selectDescription(_ sender: Any) {
        descriptionDropdown.show()
    }
    
    @IBAction func selectUnit(_ sender: Any) {
        unitDropdown.show()
    }
    
    @IBAction func selectMeasurement(_ sender: Any) {
        measurementDropdown.show()
    }
    
    @IBAction func enterQuantity(_ sender: Any) {
        if quantityTextField.text == "" {
            selectedQuantity = 0
        } else {
            selectedQuantity = Int(quantityTextField.text!)!
        }
        print("qty entered", quantityTextField.text!)
        validateForm()
    }
    
    @IBAction func selectNonHalal(_ sender: Any) {
        if checkBoxesInit {
            if selectedHalal {
                selectedHalal = false
            } else {
                selectedHalal = true
            }
            halalCheckbox.toggleCheckState()
        } else {
            selectedHalal = false
            checkBoxesInit = true
        }
        validateForm()
    }
    
    @IBAction func selectHalal(_ sender: Any) {
        if checkBoxesInit {
            if selectedHalal {
                selectedHalal = false
            } else {
                selectedHalal = true
            }
            nonHalalCheckbox.toggleCheckState()
        } else {
            selectedHalal = true
            checkBoxesInit = true
        }
        validateForm()
    }
    
    @IBAction func onSubmit(_ sender: UIButton) {
        sender.pulsate()
        var desc = selectedDescription + "-" +
            selectedMeasurement.components(separatedBy: " ")[0] +
            selectedUnit.components(separatedBy: " ")[0]
        desc += selectedHalal ? "-Halal" : ""
        let donor = selectedDonor == "Others" ? newDonorTextField?.text : selectedDonor
        let url = URL(string: "http://54.169.53.162:8080/rest/inventory/update-item-quantity")!
        let headers: HTTPHeaders = ["Authorization": UserDefaults.standard.value(forKey: "token") as! String]
        let parameters: Parameters = [
            "donorName": donor!,
            "category": selectedCategory,
            "classification": selectedClassification,
            "description": desc,
            "quantity": selectedQuantity,
            "barcode": UserDefaults.standard.value(forKey: "barcode") as! String
        ]
        let message = """
            Donor: \(donor!)
            Category: \(selectedCategory)
            Classification: \(selectedClassification)
            Description: \(selectedDescription)
            Halal : \(selectedHalal ? "Yes" : "No")
            Quantity: \(selectedQuantity)
        """
        let popup = PopupDialog(title: "Please confirm the following details:", message: message, image: nil)
        // Create buttons
        let cancelButton = CancelButton(title: "CANCEL") {
            print("CANCEL SUBMISSION")
        }
        let confirmButton = DefaultButton(title: "CONFIRM", height: 60) {
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                if let json = response.result.value {
                    let res = json as! NSDictionary
                    if res["status"] as! String == "FAIL" {
                        print (res["message"]!)
                        Toast(text: "Something went wrong. Try again!", duration: Delay.short).show()
                    } else {
                        self.resetFields()
                        UserDefaults.standard.set("", forKey: "barcode")
//                        self.tabBarController?.selectedIndex = 1
                        self.enableFields()
                        Toast(text: "Successfully submitted!", duration: Delay.short).show()
                    }
                    self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                }
            }
        }
        popup.addButtons([cancelButton, confirmButton])
        self.present(popup, animated: true, completion: nil)
    }
    
    /* PROCESSING FUNCTIONS */
    
    func getItem() {
        let barcode = UserDefaults.standard.value(forKey: "barcode")!
        if let code = barcode as? String {
            if code != "" {
                let url = "http://54.169.53.162:8080/rest/inventory/scanner?barcode=" + code
                let headers: HTTPHeaders = ["Authorization": UserDefaults.standard.value(forKey: "token") as! String]
                Alamofire.request(url, method: .get, headers: headers).responseJSON { response in
                    if let json = response.result.value {
                        let res = json as! NSDictionary
                        if res["status"] as! String == "FAIL" {
                            print (res["message"]!)
                            self.activityIndicatorView.stopAnimating()
                            self.activityIndicatorView.isHidden = true
                        } else {
                            self.barcodeResponse = res["result"] as! [String: String]
                            self.selectedCategory = self.barcodeResponse["category"]!
                            self.categoryDropdownButton.setTitle(self.selectedCategory, for: .normal)
                            self.selectedClassification = self.barcodeResponse["classification"]!
                            self.classificationDropdownButton.setTitle(self.selectedClassification, for: .normal)
                            self.classificationList = [""] + Array(self.inventoryMap[self.selectedCategory]!.keys)
                            self.classificationDropdown.dataSource = self.classificationList
                            let desc = self.barcodeResponse["description"]!
                            self.selectedDescription = desc.components(separatedBy: "-")[0]
                            self.descriptionDropdownButton.setTitle(self.selectedDescription, for: .normal)
                            self.descriptionList = [""] + self.inventoryMap[self.selectedCategory]![self.selectedClassification]!
                            self.descriptionDropdown.dataSource = self.descriptionList
                            let value = desc.components(separatedBy: "-")[1]
                            if value.range(of: "ml") != nil {
                                let range = value.range(of: "ml")
                                let num = value.prefix(upTo: (range?.lowerBound)!)
                                self.selectedUnit = self.unitMap["ml"]!
                                self.unitDropdownButton.setTitle(self.selectedUnit, for: .normal)
                                self.selectedMeasurement = self.measurementMap[String(num)]!
                                self.measurementDropdownButton.setTitle(self.selectedMeasurement, for: .normal)
                                self.measurementList = self.measurementListA
                                self.measurementDropdown.dataSource = self.measurementList
                            } else if value.range(of: "kg") != nil {
                                let range = value.range(of: "kg")
                                let num = value.prefix(upTo: (range?.lowerBound)!)
                                self.selectedUnit = self.unitMap["kg"]!
                                self.unitDropdownButton.setTitle(self.selectedUnit, for: .normal)
                                self.selectedMeasurement = self.measurementMap[String(num)]!
                                self.measurementDropdownButton.setTitle(self.selectedMeasurement, for: .normal)
                                self.measurementList = self.measurementListB
                                self.measurementDropdown.dataSource = self.measurementList
                            } else if value.range(of: "l") != nil {
                                let range = value.range(of: "l")
                                let num = value.prefix(upTo: (range?.lowerBound)!)
                                self.selectedUnit = self.unitMap["l"]!
                                self.unitDropdownButton.setTitle(self.selectedUnit, for: .normal)
                                self.selectedMeasurement = self.measurementMap[String(num)]!
                                self.measurementDropdownButton.setTitle(self.selectedMeasurement, for: .normal)
                                self.measurementList = self.measurementListB
                                self.measurementDropdown.dataSource = self.measurementList
                            } else if value.range(of: "g") != nil {
                                let range = value.range(of: "g")
                                let num = value.prefix(upTo: (range?.lowerBound)!)
                                self.selectedUnit = self.unitMap["g"]!
                                self.unitDropdownButton.setTitle(self.selectedUnit, for: .normal)
                                self.selectedMeasurement = self.measurementMap[String(num)]!
                                self.measurementDropdownButton.setTitle(self.selectedMeasurement, for: .normal)
                                self.measurementList = self.measurementListA
                                self.measurementDropdown.dataSource = self.measurementList
                            } else {
                                print ("INVALID DESCRIPTION VALUE")
                            }
                            self.checkBoxesInit = true
                            if desc.components(separatedBy: "-").count > 2 {
                                self.selectedHalal = true
                                self.nonHalalCheckbox.setCheckState(M13Checkbox.CheckState.unchecked, animated: false)
                                self.halalCheckbox.setCheckState(M13Checkbox.CheckState.checked, animated: false)
                            } else {
                                self.selectedHalal = false
                                self.nonHalalCheckbox.setCheckState(M13Checkbox.CheckState.checked, animated: false)
                                self.halalCheckbox.setCheckState(M13Checkbox.CheckState.unchecked, animated: false)
                            }
                            self.disableFields()
                        }
                        self.activityIndicatorView.stopAnimating()
                        self.activityIndicatorView.isHidden = true
                    }
                }
            } else {
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.isHidden = true
            }
        }
    }
    
    func initDonorDropdown() {
        let url = URL(string: "http://54.169.53.162:8080/rest/donor/display-donors")!
        let headers: HTTPHeaders = ["Authorization": UserDefaults.standard.value(forKey: "token") as! String]
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if let json = response.result.value {
                let res = json as! NSDictionary
                if res["status"] as! String == "FAIL" {
                    print (res["message"]!)
                } else {
                    self.donorsList = res["result"] as! [String]
                    self.donorsList.append("Others")
                    self.donorsList.sort()
                    self.donorDropdown.dataSource = [""] + self.donorsList
                }
            }
        }
        donorDropdown.selectionAction = {(index, item) in
            self.donorDropdownButton.setTitle(item, for: .normal)
            self.selectedDonor = item
            if item == "Others" {
                if self.othersFieldPresent == false {
                    
                    // Reveal "others" text field
                    self.newDonorTextField?.isHidden = false
                    
                    // Update Category Label Constraint
                    self.categoryTopConstraint.constant = 70
                    
                    // Set "others" text field to present
                    self.othersFieldPresent = true
                    
                }
            } else {
                if self.othersFieldPresent == true {
                    
                    // Hide "others" text field
                    self.newDonorTextField?.isHidden = true
                    
                    // Clear "others" text field
                    self.newDonorTextField.text = ""
                    
                    // Update Category Label Constraint
                    self.categoryTopConstraint.constant = 20
                    
                    // Set "others" text field to NOT present
                    self.othersFieldPresent = false
                    
                }
            }
            self.validateForm()
        }
    }
    
    func initInventoryDropdowns() {
        let url = URL(string: "http://54.169.53.162:8080/rest/inventory/display-all")!
        let headers: HTTPHeaders = ["Authorization": UserDefaults.standard.value(forKey: "token") as! String]
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if let json = response.result.value {
                let res = json as! NSDictionary
                if res["status"] as! String == "FAIL" {
                    print (res["message"]!)
                } else {
                    self.inventoryList = res["result"]! as! [[AnyHashable : Any]] as! [[String : AnyObject]]
                    self.generateHierarchy()
                    self.categoryList = [""] + Array(self.inventoryMap.keys)
                    self.categoryList.sort()
                    self.categoryDropdown.dataSource = self.categoryList
                    self.getItem()
                }
            }
        }
        unitDropdown.dataSource = unitList
        categoryDropdown.selectionAction = { [weak self] (index, item) in
            self?.categoryDropdownButton.setTitle(item, for: .normal)
            if item == "" {
                self?.classificationList = []
                self?.descriptionList = []
                self?.selectedClassification = ""
                self?.selectedDescription = ""
                
                self?.descriptionDropdownButton.setTitle("", for: .normal)
                self?.classificationDropdownButton.setTitle("", for: .normal)
                self?.classificationDropdown.dataSource = self!.classificationList
                self?.descriptionDropdown.dataSource = self!.descriptionList
            } else {
                if self?.selectedCategory != item {
                    self?.selectedCategory = item
                    self?.classificationList = [""] + Array(self!.inventoryMap[item]!.keys)
                    self?.descriptionList = []
                    self?.selectedClassification = ""
                    self?.selectedDescription = ""
                    
                    self?.descriptionDropdownButton.setTitle("", for: .normal)
                    self?.classificationDropdownButton.setTitle("", for: .normal)
                    self?.classificationList.sort()
                    self?.classificationDropdown.dataSource = self!.classificationList
                    self?.descriptionDropdown.dataSource = self!.descriptionList
                }
            }
            self?.validateForm()
        }
        classificationDropdown.selectionAction = { [weak self] (index, item) in
            self?.classificationDropdownButton.setTitle(item, for: .normal)
            if item == "" {
                self?.descriptionList = []
                self?.selectedDescription = ""
                
                self?.descriptionDropdownButton.setTitle("", for: .normal)
                self?.descriptionDropdown.dataSource = self!.descriptionList
            } else {
                if self?.selectedClassification != item {
                    self?.selectedClassification = item
                    self?.descriptionList = [""] + self!.inventoryMap[self!.selectedCategory]![item]!
                    self?.selectedDescription = ""
                    
                    self?.descriptionDropdownButton.setTitle("", for: .normal)
                    self?.descriptionList.sort()
                    self?.descriptionDropdown.dataSource = self!.descriptionList
                }
            }
            self?.validateForm()
        }
        descriptionDropdown.selectionAction = { [weak self] (index, item) in
            self?.descriptionDropdownButton.setTitle(item, for: .normal)
            self?.selectedDescription = item
            self?.validateForm()
        }
        unitDropdown.selectionAction = { [weak self] (index, item) in
            self?.unitDropdownButton.setTitle(item, for: .normal)
            self?.selectedUnit = item
            if item != "" {
                let _unit = item.components(separatedBy: " ")[0]
                if _unit == "g" || _unit == "ml" {
                    self?.measurementList = (self?.measurementListA)!
                } else {
                    self?.measurementList = (self?.measurementListB)!
                }
            } else {
                self?.measurementList = []
            }
            self?.measurementDropdown.dataSource = (self?.measurementList)!
            self?.validateForm()
        }
        measurementDropdown.selectionAction = { [weak self] (index, item) in
            self?.measurementDropdownButton.setTitle(item, for: .normal)
            self?.selectedMeasurement = item
            self?.validateForm()
        }
    }
    
    func validateForm() {
        print("donor", selectedDonor != "")
        print("cat", selectedCategory != "")
        print("cls", selectedClassification != "")
        print("desc", selectedDescription != "")
        print("unit", selectedUnit != "")
        print("msr", selectedMeasurement != "")
        print("qty", selectedQuantity > 0)
        print("box", checkBoxesInit)
        let validForm = (
            (
                (selectedDonor != "Others" && selectedDonor != "") ||
                (selectedDonor == "Others" && newDonorTextField.text != "")
            ) &&
            selectedCategory != "" &&
            selectedClassification != "" &&
            selectedDescription != "" &&
            selectedUnit != "" &&
            selectedMeasurement != "" &&
            selectedQuantity > 0 &&
            checkBoxesInit
        )
        if validForm {
            submitButton.isEnabled = true
            submitButton.alpha = 1
        } else {
            submitButton.isEnabled = false
            submitButton.alpha = 0.5
        }
    }
    
    func generateHierarchy() {
        var treeMap: [String:[String:Set<String>]] = [:]
        for e in inventoryList {
            let cat = e["category"] as! String
            let cls = e["classification"] as! String
            let desc = (e["description"] as! String).components(separatedBy: "-")[0]
            if treeMap[cat] != nil {
                if treeMap[cat]?[cls] != nil {
                    treeMap[cat]?[cls]?.insert(desc)
                } else {
                    treeMap[cat]?[cls] = Set([desc])
                }
            } else {
                treeMap[cat] = [:]
                treeMap[cat]?[cls] = Set([desc])
            }
        }
        for (cat, _) in treeMap {
            inventoryMap[cat] = [:]
            for (cls, desc_set) in treeMap[cat]! {
                inventoryMap[cat]?[cls] = Array(desc_set)
            }
        }
    }
    
    func initViewElements() {
        
        activityIndicatorView.isHidden = true
        newDonorTextField?.isHidden = true
        newDonorTextField?.translatesAutoresizingMaskIntoConstraints = false
        categoryTopConstraint.isActive = true
        
        nonHalalCheckbox.boxType = .square
        halalCheckbox.boxType = .square
        
        submitButton.isEnabled = false
        submitButton.alpha = 0.5
        
        nonHalalCheckbox.animationDuration = 0.1
        halalCheckbox.animationDuration = 0.1
        
        donorDropdown.width = UIScreen.main.bounds.width - 80
        categoryDropdown.width = UIScreen.main.bounds.width - 80
        classificationDropdown.width = UIScreen.main.bounds.width - 80
        descriptionDropdown.width = UIScreen.main.bounds.width - 80
        descriptionDropdown.cellHeight = 25
        descriptionDropdown.textFont = UIFont.systemFont(ofSize: 12)
        unitDropdown.width = UIScreen.main.bounds.width - 80
        measurementDropdown.width = UIScreen.main.bounds.width - 80
        measurementDropdown.cellHeight = 30
        measurementDropdown.textFont = UIFont.systemFont(ofSize: 12)
        
    }
    
    func resetFields() {
        
        if othersFieldPresent == true {
            
            // Hide "others" text field
            newDonorTextField?.isHidden = true
            
            // Clear "others" text field
            newDonorTextField.text = ""
            
            // Update Category Label Constraint
            categoryTopConstraint.constant = 20
            
            // Set "others" text field to NOT present
            othersFieldPresent = false
            
        }
        
        othersFieldPresent = false
        checkBoxesInit = false
        
        quantityTextField.text = ""
        
        nonHalalCheckbox.setCheckState(M13Checkbox.CheckState.unchecked, animated: false)
        halalCheckbox.setCheckState(M13Checkbox.CheckState.unchecked, animated: false)
        
        selectedDonor = ""
        selectedCategory = ""
        selectedClassification = ""
        selectedDescription = ""
        selectedUnit = ""
        selectedMeasurement = ""
        selectedQuantity = 0
        selectedHalal = false
        
        donorDropdownButton.setTitle("", for: .normal)
        categoryDropdownButton.setTitle("", for: .normal)
        classificationDropdownButton.setTitle("", for: .normal)
        descriptionDropdownButton.setTitle("", for: .normal)
        unitDropdownButton.setTitle("", for: .normal)
        measurementDropdownButton.setTitle("", for: .normal)
        
        enableFields()
        
        initDonorDropdown()
        initInventoryDropdowns()
        
    }
    
    func disableFields () {
        categoryDropdownButton.isEnabled = false
        classificationDropdownButton.isEnabled = false
        descriptionDropdownButton.isEnabled = false
        unitDropdownButton.isEnabled = false
        measurementDropdownButton.isEnabled = false
        nonHalalCheckbox.isEnabled = false
        halalCheckbox.isEnabled = false
        
        nonHalalCheckbox.tintColor = UIColor(red:0.45, green:0.45, blue:0.45, alpha:1.0)
        halalCheckbox.tintColor = UIColor(red:0.45, green:0.45, blue:0.45, alpha:1.0)
    }
    
    func enableFields () {
        categoryDropdownButton.isEnabled = true
        classificationDropdownButton.isEnabled = true
        descriptionDropdownButton.isEnabled = true
        unitDropdownButton.isEnabled = true
        measurementDropdownButton.isEnabled = true
        nonHalalCheckbox.isEnabled = true
        halalCheckbox.isEnabled = true
        
        nonHalalCheckbox.tintColor = UIColor(red:0.29, green:0.70, blue:0.40, alpha:1.0)
        halalCheckbox.tintColor = UIColor(red:0.29, green:0.70, blue:0.40, alpha:1.0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

