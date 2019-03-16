//
//  LoginViewController.swift
//  BestPrice
//


import UIKit
import Firebase
import FBSDKLoginKit

//This class is for the Login scene

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var facebookButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        //facebook  button setup
        facebookButton.delegate = self
        facebookButton.readPermissions = ["email"]
        
        //hide navigation controller
        self.navigationController?.isNavigationBarHidden = false
        
        //changebackground color
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "checkout1")!)
        
        //change button border colors to white
        facebookButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.borderColor = UIColor.white.cgColor
        
    }
    
    //Login to Facebook auth,  if logged into facebook perform segue
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error == nil {
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            Auth.auth().signInAndRetrieveData(with: credential, completion: { (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                self.performSegue(withIdentifier: "loggedIn", sender: self)
                
            })
        } else {
            return
        }
        
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    print("logged out of facebook")
    }
    
    //resign keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //hide navigation bar
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //login with email/password. If successful perform segue
    @IBAction func loginWithEmail(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] user, error in
            guard self != nil else {
                return
            }
            
            if (error != nil) {
                print(error!)
                self!.alertpopup((error?.localizedDescription)!)
            } else {
                print("Account loggedin sucessfully.")
                self?.performSegue(withIdentifier: "loggedIn", sender: self)
            }
        }
        
        
    }
    
    //if unsucessful show popup
    func alertpopup(_ error: String) {
        
        let alert = UIAlertController(title: "Invalid Entry!", message: error, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "DISMISS", style: UIAlertAction.Style.default) {
            (UIAlertAction) -> Void in
        }
        alert.addAction(alertAction)
        present(alert, animated: true) {
            () -> Void in
        }
    }
    
    
    @IBAction func loginWithFacebook(_ sender: Any) {
    }
    
    
}

