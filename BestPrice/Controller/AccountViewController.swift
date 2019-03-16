//
//  AccountViewController.swift
//  BestPrice

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

//This is the account view controller used for User Profile (if signed in with Facebook)

class AccountViewController: UIViewController {
    
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var fbprofileimg: UIImageView!
    @IBOutlet weak var aboutusText: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Show hide navigation and tab bar controllers
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
        
        //if user logged in using email perform segue to User Profile version
        if let providerData = Auth.auth().currentUser?.providerData {
            for userInfo in providerData {
                switch userInfo.providerID {
                case "facebook.com":
                    print("User is signed in with \(userInfo.providerID)")
                    
                default:
                    
                    performSegue(withIdentifier: "goUser", sender: self)
                }
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
        
        if let providerData = Auth.auth().currentUser?.providerData {
            for userInfo in providerData {
                switch userInfo.providerID {
                case "facebook.com":
                    print("facebook")
                    nameText.text = userInfo.displayName
                    downloadImage(url: (userInfo.photoURL?.absoluteString)!)
                    fbprofileimg.layer.borderWidth = 3;
                    fbprofileimg.layer.cornerRadius = fbprofileimg.frame.size.width / 2 // To get Rounded Corner
                    fbprofileimg.clipsToBounds = true // To Trim Outer frame
                    let borderColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1.0)
                    fbprofileimg.layer.borderColor = borderColor.cgColor
                    
                default:
                    print("user is signed in with \(userInfo.providerID)")
                    
                }
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        aboutusText.setContentOffset(.zero, animated: false)
    }
    
    
    func getData(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(url: String) {
        print("Image download starting.")
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            guard let Url = URL(string: url) else {
                return
            }
            self.getData(url: Url) { (data, response, error) in
                if let data = data, error == nil {
                    print(response?.suggestedFilename ?? Url.lastPathComponent)
                    print("Download Finished")
                    DispatchQueue.main.async() {
                        self.fbprofileimg.image = UIImage(data: data)
                        
                    }
                } else {
                    DispatchQueue.main.async() {
                        print("Download Failed")
                        
                    }
                }
            }
        }
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
                        print("Error signing out: %@", signOutError)
                    }
                }
            }
        }
    }
    
    
}

