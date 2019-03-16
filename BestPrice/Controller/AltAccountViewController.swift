//
//  AccountViewController.swift
//  BestPrice
//
//  Created by James Valles on 3/12/19.


import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class AltAccountViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var altnameText1: UILabel!
    @IBOutlet weak var altfbprofileimg: UIImageView!
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
  
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
        name.delegate = self
    
        if let providerData = Auth.auth().currentUser?.providerData {
            for userInfo in providerData {
                switch userInfo.providerID {
                case "facebook.com":
                    print("facebook")
           
                    
                    // fbprofileimg.layer.borderColor = [UIColor, blackColor].CGColor;
                    altfbprofileimg.layer.borderWidth = 3;
                    altfbprofileimg.layer.cornerRadius = altfbprofileimg.frame.size.width / 2 // To get Rounded Corner
                    
                    altfbprofileimg.clipsToBounds = true // To Trim Outer frame
                    
                    let borderColor = UIColor(red:255, green:255, blue:255, alpha:1.0)
                    altfbprofileimg.layer.borderColor = borderColor.cgColor
                    
                default:
                    email.text = userInfo.email
                    name.text = userInfo.displayName
                    altnameText1.text = userInfo.displayName
                  
                    
                    print("user is signed in with \(userInfo.providerID)")
                    
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    
        @IBAction func updateInfo(_ sender: Any) {
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
           changeRequest?.displayName = name.text!
            changeRequest?.commitChanges { (error) in
                
                if error == nil{
                    self.altnameText1.text = changeRequest?.displayName
                                
                } else{
                    
                }
                        }
                    }
                    
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
    
            // Hide the navigation bar on the this view controller
            self.navigationController?.setNavigationBarHidden(true, animated: animated)
            self.tabBarController?.tabBar.isHidden = false
        }

    
    @IBAction func altlogoutButton(_ sender: Any) {
        if let providerData = Auth.auth().currentUser?.providerData {
            for userInfo in providerData {
                switch userInfo.providerID {
                case "facebook.com":
                    
                    print("user is signed in with facebook")
                    FBSDKLoginManager().logOut()
                    let goHome = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as? UserViewController
                    self.addChild(goHome!)
                    goHome!.view.frame = self.view.frame
                    self.view.addSubview(goHome!.view)
                    goHome!.didMove(toParent: self)
                    
                default:
                    
                    let goHome = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as? UserViewController
                    self.addChild(goHome!)
                    goHome!.view.frame = self.view.frame
                    self.view.addSubview(goHome!.view)
                    goHome!.didMove(toParent: self)
                    
                    print("user is signed in with \(userInfo.providerID)")
                    let firebaseAuth = Auth.auth()
                    do {
                        try firebaseAuth.signOut()
                        print("User Logged Out")
                    } catch let signOutError as NSError {
                        print ("Error signing out: %@", signOutError)
                    }
                }
            }
        }
    }
    
    
}

