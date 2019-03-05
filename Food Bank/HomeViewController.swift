//
//  HomeViewController.swift
//  Food Bank
//
//  Created by Louis Lim Ying Wei on 17/3/18.
//  Copyright © 2018 Louis Lim Ying Wei. All rights reserved.
//

import UIKit
import PopupDialog

class HomeViewController: UIViewController {
    
    let phoneNumber = "+6568315395"

    @IBOutlet weak var tutorialButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var greetingsView: UIView!
    @IBOutlet weak var announcementView: UIView!
    @IBOutlet weak var contactsView: UIView!
    @IBOutlet weak var tutorialView: UIView!
    
    @IBOutlet weak var greetings: UITextView!
    @IBOutlet weak var announcements: UITextView!
    @IBOutlet weak var contacts: UITextView!
    
    @IBAction func makePhoneCall(_ sender: Any) {
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
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
    
    @IBAction func loadTutorial(_ sender: Any) {
        tutorial()
    }
    
    func tutorial () {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let swipingController = SwipingController(collectionViewLayout: layout)
        self.present(swipingController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tutorial()
        
        let cards = [greetingsView, announcementView, contactsView]
        let texts = [greetings, announcements, contacts]
        for card in cards {
            styleCards(card: card!)
        }
        for text in texts {
            setDynamicTextViewHeights(text: text!)
        }
        setContent()
        
        tutorialButton.layer.cornerRadius = 3.0
        tutorialButton.layer.masksToBounds = false
        tutorialButton.layer.shadowColor = UIColor.black.cgColor
        tutorialButton.layer.shadowOpacity = 0.3
        tutorialButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        tutorialButton.layer.shadowRadius = 0.7
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func styleCards (card: UIView) {
        card.layer.cornerRadius = 3.0
        card.layer.masksToBounds = false
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.3
        card.layer.shadowOffset = CGSize(width: 0, height: 0)
        card.layer.shadowRadius = 0.7
    }
    
    func setDynamicTextViewHeights (text: UITextView) {
        text.heightAnchor.constraint(greaterThanOrEqualToConstant: 10)
        text.isScrollEnabled = false
    }
    
    func setContent () {
        greetings.text = "Hi there! We appreciate your precious time out to help out with us at Food Bank Singapore! If you have any enquires, do feel free to approach any of our staff and we will gladly answer them for you."
        announcements.text = "If you have spoken to our friendly staff at the counter, and are sure of what the job scope is (Stock Take / Packing), do proceed on with the task which you can access on the navigation tabs below.\n\nIf you have yet to receive instructions, kindly do seek help with the staff at the counter.\n\nThank you."
        contacts.text = "Email: enquiries@foodbank.sg\nTel: +65 6831 5395"
    }

    

}

