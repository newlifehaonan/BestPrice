//
//  RegisterViewController.swift
//  BestPrice
//
//  Created by James Valles on 3/9/19.
//  Copyright © 2019 Harry Chen. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase


class RegisterViewController: UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var passwordTextField: UIStackView!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextEntry: UITextField!
    
    @IBOutlet weak var facebookButton: FBSDKLoginButton!
    
 
    
    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
     passwordTextEntry.delegate = self
      usernameTextField.delegate = self
        
     //   usernameTextField.setLeftImage(imageName: "email50")
    //    passwordTextEntry.setLeftImage(imageName: "password50")
        facebookButton.delegate = self
       facebookButton.readPermissions = ["email"]
       
      
    
 self.navigationController?.isNavigationBarHidden = false
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"storebg")!)
        
        facebookButton.layer.borderColor = UIColor.white.cgColor
        registerButton.layer.borderColor = UIColor.white.cgColor
        // Do any additional setup after loading the view.
    }
    
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error == nil{
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            Auth.auth().signInAndRetrieveData(with: credential, completion: {(authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                self.performSegue(withIdentifier: "goIn", sender: self)
                
            })
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    

   
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func registerUsingEmail(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: usernameTextField.text!, password: passwordTextEntry.text!) { authResult, error in
            
            if (error != nil){
                print(error!)
                self.alertpopup((error?.localizedDescription)!)
            } else{
                print("Account created sucessfully.")
                self.performSegue(withIdentifier: "goIn", sender: self)
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
    
    @IBAction func registerUsingFacebook(_ sender: Any) {
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

extension UITextField{
    
    func setLeftImage(imageName:String) {
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = UIImage(named: imageName)
        self.leftView = imageView;
        self.leftViewMode = .always
    }
}
