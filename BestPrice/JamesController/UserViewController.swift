//
//  UserViewController.swift
//  BestPrice
//
//  Created by James Valles on 3/9/19.
//  Copyright © 2019 Harry Chen. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import AVKit
import FBSDKCoreKit
import FBSDKLoginKit

class UserViewController: UIViewController {
        var player: AVPlayer?
   
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
     
        self.navigationController?.isNavigationBarHidden = true
        loginButton.layer.borderColor = UIColor.white.cgColor
        registerButton.layer.borderColor = UIColor.white.cgColor

           print("printing")
        guard let facebookToken = FBSDKAccessToken.current() else{
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: facebookToken.tokenString)
        
        Auth.auth().signInAndRetrieveData(with: credential, completion: {(authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self.performSegue(withIdentifier: "bypassLogin", sender: self)
            
        })
      
        
        
}
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
          tabBarController?.tabBar.isHidden = true
        
        loadVideo()
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }


    private func loadVideo() {
        
        //this line is important to prevent background music stop
 
        let path = Bundle.main.path(forResource: "shop1029", ofType:"mov")
        
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
