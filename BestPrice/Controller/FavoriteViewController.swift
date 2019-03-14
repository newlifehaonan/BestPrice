//
//  ViewController.swift
//  BestPrice
//
//  Created by Harry Chen on 3/8/19.
//  Copyright © 2019 Harry Chen. All rights reserved.
//

import UIKit
import Firebase

class FavoriteViewController: UIViewController {
    var downloadedDetail : String!
    var downloadedImages : Array <String>!
    var downloadedName : Array<String>!
    var downloadedShops : Array <Retailer>!
    

    var downloadedIngredients : [Dictionary <String, String>]!

    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle?

    var userFavoriteItems = [Merchandize]()
    @IBOutlet weak var favoriteList: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        ref = Database.database().reference()
        getFavorite()
             self.tabBarController?.tabBar.isHidden = false

        // Do any additional setup after loading the view.
        favoriteList.dataSource = self
        favoriteList.delegate = self
    }
    
    //MARK: this function is a closure contain RESTFUL CALL
    func getData(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    //MARK: this function contains logic to handle the HTTP return
    func getFavorite() {
       
       
            let userID = Auth.auth().currentUser?.uid
        
                print("UserID", userID!)
        
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let favorites = snapshot.childSnapshot(forPath: "favorites")
            for favorite in favorites.children{
                let snap =  favorite as! DataSnapshot
                let dict = snap.value as! [String: Any]
                let  name = dict["name"] as! String
                let  detail = dict["detail"] as! String
                let  images = dict["images"] as! NSDictionary
                let shops = dict["shops"] as! NSDictionary
                for shop in shops {
                    let dict = shop.value as! [String: Any]
                     let  name = dict["name"] as! String
                    let  price = dict["price"] as! String
                    let  url = dict["url"] as! String
                   
                }
            
            }
             }) { (error) in
            print(error.localizedDescription)
        }
    
       
        
        // assign userFavoriteItems array
        DispatchQueue.global().async {
            
        
        }
    }
}

extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userFavoriteItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! UITableViewCell
        return cell
    }
    
    
}
