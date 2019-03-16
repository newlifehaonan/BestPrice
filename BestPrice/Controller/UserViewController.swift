//
//  UserViewController.swift
//  BestPrice
//


import UIKit
import Firebase
import AVFoundation
import AVKit
import FBSDKCoreKit
import FBSDKLoginKit

//this is the apps home screen, is in charge of playing homepage welcome video and greeting users

class UserViewController: UIViewController {
    var player: AVPlayer?
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide navigation bar
        self.navigationController?.isNavigationBarHidden = true
        
        //settup login and resiger button border colors
        loginButton.layer.borderColor = UIColor.white.cgColor
        registerButton.layer.borderColor = UIColor.white.cgColor
        
        print("In view did load.")
        
        //retrieve facebook token, if already logged into facebook, no need to login , by pass login, automatically perform segue
        guard let facebookToken = FBSDKAccessToken.current() else {
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: facebookToken.tokenString)
        
        Auth.auth().signInAndRetrieveData(with: credential, completion: { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.performSegue(withIdentifier: "bypassLogin", sender: self)   
        })
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //hid tab bar
        tabBarController?.tabBar.isHidden = true
        
        //load splash page video
        loadVideo()
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    //load video using AV Foundation 
    private func loadVideo() {
        
        //this line is important to prevent background music stop
        let path = Bundle.main.path(forResource: "shop1029", ofType: "mov")
        
        let filePathURL = NSURL.fileURL(withPath: path!)
        let player = AVPlayer(url: filePathURL)
        let playerLayer = AVPlayerLayer(player: player)
        
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.zPosition = -1
        
        self.view.layer.addSublayer(playerLayer)
        
        player.seek(to: CMTime.zero)
        player.play()
        
    }
}

