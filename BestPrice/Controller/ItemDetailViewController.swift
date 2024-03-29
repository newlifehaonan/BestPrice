//
//  ItemDetailViewController.swift
//  BestPrice
//


import UIKit

class ItemDetailViewController: UIViewController {
    @IBOutlet weak var cancle: UIButton!
    @IBOutlet var itemdetail: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var itemDescription: UITextView!
    @IBOutlet weak var itemName: UITextView!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shippingPrice: UILabel!
    @IBOutlet weak var itemCondition: UILabel!
    var shopURL: String?
    var effect: UIVisualEffect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        effect = blurView.effect
        blurView.effect = nil
        itemdetail.layer.cornerRadius = 5
        animatedIn()
    }
    
    func animatedIn() {
        self.view.addSubview(itemdetail)
        itemdetail.center = self.view.center
        
        itemdetail.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        itemdetail.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.blurView.effect = self.effect
            self.itemdetail.alpha = 1
            self.itemdetail.transform = CGAffineTransform.identity
        }
        
    }
    
    func animatedOut() {
        UIView.animate(withDuration: 0.4, animations: {
            self.itemdetail.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.itemdetail.alpha = 0
            self.blurView.effect = nil
        }) {
            (success: Bool) in
            self.view.removeFromSuperview()
        }
    }
    
    @IBAction func detailDispear(_ sender: Any) {
        animatedOut()
    }
    
    
    @IBAction func toShopWebView(_ sender: UIButton) {
        performSegue(withIdentifier: "showWebView", sender: sender)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWebView" {
            let destinationVC = segue.destination as! WebViewController
            //            destinationVC.delegate = self
            destinationVC.shopURL = self.shopURL
        }
    }
}

