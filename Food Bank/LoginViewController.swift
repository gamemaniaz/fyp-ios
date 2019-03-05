//
//  LoginViewController.swift
//  Food Bank
//
//  Created by Louis Lim Ying Wei on 17/3/18.
//  Copyright © 2018 Louis Lim Ying Wei. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var originalBorderColor: CGColor!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginPassword: UITextField!
    
    let production = true

    @IBAction func onLogin(_ sender: Any) {
        login()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginPassword.layer.borderColor = UIColor(red:1.00, green:0.00, blue:0.00, alpha:1.0).cgColor
        UserDefaults.standard.set("", forKey: "barcode")
        UserDefaults.standard.set("", forKey: "token")
        loginButton.layer.shadowColor = UIColor.black.cgColor
        loginButton.layer.shadowOffset = CGSize(width: 0.0, height: 1.1)
        loginButton.layer.shadowRadius = 0.4
        loginButton.layer.shadowOpacity = 0.4
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func onEntry(_ sender: Any) {
        self.loginPassword.placeholder = "Password"
        self.loginPassword.layer.borderWidth = 0.0
    }
    
    
    func login() {
        if production {
            let password = loginPassword.text!
            if password != "" {
                let url = URL(string: "http://54.169.53.162:8080/authenticate")!
                let parameters: Parameters = [
                    "username": "volunteer",
                    "password": password
                ]
                Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                    if let json = response.result.value {
                        let res = json as! NSDictionary
                        if res["status"] as! String == "FAIL" {
                            print (res["message"]!)
                            self.loginPassword.text = ""
                            self.loginPassword.layer.borderWidth = 1.0
                            self.loginPassword.placeholder = "Invalid password. Please try again!"
                        } else {
                            UserDefaults.standard.set(res["result"] as! String, forKey: "token")
                            self.performSegue(withIdentifier: "MainEntry", sender: self)
                        }
                    }
                }
            }
        } else {
            performSegue(withIdentifier: "MainEntry", sender: self)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        login()
        return true
    }

}
