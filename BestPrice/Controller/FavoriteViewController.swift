import UIKit
import Firebase

class FavoriteViewController: UIViewController {
    
    var items = [Merchandize]()
    var retailer = [Retailer]()
    var faveName: String = ""
    var faveDetail: String = ""
    var faveImages: NSDictionary = [:]
    var shopName: String = ""
    var price: String = ""
    var url: String = ""
    var retailerObj: Retailer?
    var imageArray = [String]()    
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
            for favorite in favorites.children {
                let snap = favorite as! DataSnapshot
                let dict = snap.value as! [String: Any]
                
                self.faveName = dict["name"] as! String
                self.faveDetail = dict["detail"] as! String
                self.faveImages = dict["images"] as! NSDictionary
                
                let shops = dict["shops"] as! NSDictionary
                for shop in shops {
                    let dict = shop.value as! [String: Any]
                    self.shopName = dict["name"] as! String
                    self.price = dict["price"] as! String
                    self.url = dict["url"] as! String
                    
                    
                    self.retailerObj = Retailer(name: self.shopName, URL: self.url, price: Double(self.price)!)
                    
                    if let check = self.retailerObj {
                        
                        self.retailer.append(check)
                    } else {
                        
                    }
                    
                    
                    for value in self.faveImages.allValues {
                        
                        if let newImgVal = value as? String {
                            self.imageArray.append(newImgVal)
                            
                            
                        }
                        self.items.append(Merchandize(name: self.faveName, detail: self.faveDetail, images: self.imageArray, shops: self.retailer)
                        )
                        
                        
                    }
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

