//
//  ViewController.swift
//  BestPrice
//
//  Created by Harry Chen on 3/8/19.
//  Copyright © 2019 Harry Chen. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {

    var userFavoriteItems = [Merchandize]()
    @IBOutlet weak var favoriteList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = true
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
