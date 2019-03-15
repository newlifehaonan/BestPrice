import UIKit
import Firebase
import WBLoadingIndicatorView

class FavoriteViewController: UIViewController {
    
    var items = [Merchandize]()
    var retailers = [Retailer]()
    
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
    
//    var userFavoriteItems = [Merchandize]()
    
    @IBOutlet weak var favoriteList: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        items = [Merchandize]()
        retailers = [Retailer]()
        getFavorite()
        favoriteList.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.tabBarController?.tabBar.isHidden = false
    
        // Do any additional setup after loading the view.
        favoriteList.dataSource = self
        favoriteList.delegate = self
    }
    
    //MARK: this function handle the http call
    func getData(completion: @escaping (Bool?, NSEnumerator?) -> ()) {
        // MARK: Using WBLoadingView
        let indicator = WBLoadingIndicatorView(view: self.view)!
        indicator.type = WBLoadingAnimationType.animationBallSurround
        indicator.indicatorSize = CGSize(width: 50, height: 50)
        indicator.backgroundView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        indicator.bezelView.style = WBLoadingIndicatorBackgroundStyle.blurStyle
        indicator.bezelView.backgroundColor = UIColor.gray
        indicator.indicatorColor = UIColor.white
        indicator.label.text = "Loading..."
        indicator.contentColor = UIColor.white
        indicator.square = true
        self.view.addSubview(indicator)
        indicator.removeFromSuperViewOnHide = true
        indicator.wb_showLoadingView(true)
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            let userID = Auth.auth().currentUser?.uid
            self.ref.child("users").child(userID!).child("favorites").observeSingleEvent(of: .value, with: { (snapshot) in
                DispatchQueue.main.async {
                    print("get the data, start store them in local")
                    let favoriteSnapShots = snapshot.children
                    completion(true, favoriteSnapShots)
                    indicator.wb_hideLoadingView(true)
                }
            }) { (error) in
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                    completion(false, nil)
                    indicator.wb_hideLoadingView(true)
                }
            }
        }
        
    }
    
    //MARK: load local variable
    func loadFavorite(favariteSnapShots: NSEnumerator) {
        for favorite in favariteSnapShots {
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
                    
                    self.retailers.append(check)
                } else {
                    
                }
                
                for value in self.faveImages.allValues {
                    if let newImgVal = value as? String {
                        self.imageArray.append(newImgVal)
                    }
                }
            }
        }
        self.items.append(Merchandize(name: self.faveName, detail: self.faveDetail, images: self.imageArray, shops: self.retailers)
        )
    }
    
    //MARK: final function of get favorite data from firebase
    func getFavorite() {
        getData { (isSuccess, favoriteSnaps) in
            if isSuccess == true {
                guard let data = favoriteSnaps else {return}
                self.loadFavorite(favariteSnapShots: data)
                self.favoriteList.reloadData()
                print("now my data is in my local variable")
            }
            else {
                print("data is failed to return")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let destinationVC = segue.destination as? ShopsViewController {
            if let cell = sender as? FavoriteTableViewCell {
                if let indexpath = self.favoriteList.indexPath(for: cell) {
                    destinationVC.merchandize = items[indexpath.row]
                }
            }
            
        }
    }
}

extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteItem", for: indexPath) as! FavoriteTableViewCell
        
        cell.itemName.text = items[indexPath.row].name
        let orderedShops = items[indexPath.row].shops.sorted { (this:Retailer, that:Retailer) -> Bool in
            this.price < that.price
        }
        cell.BestPrice.text = "Best Price: $\(orderedShops[0].price)"
        cell.downloadImg(url: items[indexPath.row].ImageURLs[0])
        return cell
    }
}
