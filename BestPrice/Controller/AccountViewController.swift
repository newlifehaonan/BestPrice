//
//  AccountViewController.swift
//  BestPrice
//
//  Created by James Valles on 3/12/19.
//  Copyright © 2019 Harry Chen. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class AccountViewController: UITableViewController {

    @IBOutlet weak var nameText: UILabel!
    
    @IBOutlet weak var about: UITableViewCell!
    
    @IBOutlet weak var privacy: UITableViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.navigationController?.isNavigationBarHidden = true
       
        if let providerData = Auth.auth().currentUser?.providerData {
            for userInfo in providerData {
                switch userInfo.providerID {
                case "facebook.com":
            print("facebook")
//                    for stack in stackviews{
//                        stack.isHidden = true
//                    }
                
                default:
                    print("user is signed in with \(userInfo.providerID)")
                 
                }
            }
        }
    }
    
    @IBAction func updateInfo(_ sender: Any) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func logoutButton(_ sender: Any) {
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
