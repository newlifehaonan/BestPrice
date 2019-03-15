//
//  LoginViewController.swift
//  BestPrice
//
//  Created by James Valles on 3/9/19.
//  Copyright © 2019 Harry Chen. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit


class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
   
    

    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var facebookButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        facebookButton.delegate = self
        facebookButton.readPermissions = ["email"]
         self.navigationController?.isNavigationBarHidden = false
        
        self.navigationController?.isNavigationBarHidden = false
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"checkout1")!)
      
        facebookButton.layer.borderColor = UIColor.white.cgColor
       loginButton.layer.borderColor = UIColor.white.cgColor
       
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
        }else {
            
        }
        
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
  

    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    @IBAction func loginWithEmail(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] user, error in
            guard self != nil else { return }
            
            if (error != nil){
                print(error!)
                self!.alertpopup((error?.localizedDescription)!)
            } else{
                print("Account loggedin sucessfully.")
                self?.performSegue(withIdentifier: "loggedIn", sender: self)
            }
        }
        
        
    }
    
    
    func alertpopup(_ error : String){
        
        let alert = UIAlertController(title: "Invalid Entry!", message: error, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "DISMISS", style: UIAlertAction.Style.default)
        {
            (UIAlertAction) -> Void in
        }
        alert.addAction(alertAction)
        present(alert, animated: true)
        {
            () -> Void in
        }
    }
    
    
    
    @IBAction func loginWithFacebook(_ sender: Any) {
    }
   

}
