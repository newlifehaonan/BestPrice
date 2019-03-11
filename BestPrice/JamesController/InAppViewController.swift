//
//  InAppViewController.swift
//  BestPrice
//
//  Created by James Valles on 3/9/19.
//  Copyright © 2019 Harry Chen. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class InAppViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var facebookButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        facebookButton.delegate = self
        facebookButton.readPermissions = ["email"]
        self.navigationController?.isNavigationBarHidden = true

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func logOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            guard (navigationController?.popToRootViewController(animated: true)) != nil
                else{
                    print("No View Controllers to pop off")
                    return
            }
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error == nil{
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            Auth.auth().signInAndRetrieveData(with: credential, completion: {(authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                self.performSegue(withIdentifier: "loggedIn", sender: self)
                
            })
        }
        
    }
    @IBAction func logoutwithfacebook(_ sender: Any) {
        loginButtonDidLogOut(facebookButton)
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
       // self.performSegue(withIdentifier: "backHome", sender: self)
        
        guard (navigationController?.popToRootViewController(animated: true)) != nil
            else{
                print("No View Controllers to pop off")
                return
        }
    }

}
