//
//  RegisterViewController.swift
//  BestPrice
//


import UIKit
import FBSDKLoginKit
import Firebase

//This class is for the Register scene
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
        
        //setup facebook buttons
        facebookButton.delegate = self
        facebookButton.readPermissions = ["email"]
        
        //hide navigation controller
        self.navigationController?.isNavigationBarHidden = false
        
        //setup background image
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "storebg")!)
        
        //change button border color
        facebookButton.layer.borderColor = UIColor.white.cgColor
        registerButton.layer.borderColor = UIColor.white.cgColor
    }
    
    //register button for Facebook, if registering with Facebook, register, and login perform segue
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error == nil {
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            Auth.auth().signInAndRetrieveData(with: credential, completion: { (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                self.performSegue(withIdentifier: "goIn", sender: self)
                
            })
        }
        
    }
    
    //logged out of facebook, update button
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    //resign firstresponder
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //hide navigation controller
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //register using email and segue, if error show pop up alert
    @IBAction func registerUsingEmail(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: usernameTextField.text!, password: passwordTextEntry.text!) { authResult, error in
            
            if (error != nil) {
                print(error!)
                self.alertpopup((error?.localizedDescription)!)
            } else {
                print("Account created sucessfully.")
                self.performSegue(withIdentifier: "goIn", sender: self)
            }
            
        }
    }
    
    //popup alert should there be errors signing up
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
    
    @IBAction func registerUsingFacebook(_ sender: Any) {
    }
    
    
}

extension UITextField {
    
    func setLeftImage(imageName: String) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = UIImage(named: imageName)
        self.leftView = imageView;
        self.leftViewMode = .always
    }
}

