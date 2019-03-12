//
//  ShopCardCollectionViewCell.swift
//  BestPrice
//
//  Created by Harry Chen on 3/9/19.
//  Copyright © 2019 Harry Chen. All rights reserved.
//

import UIKit
import SwiftyJSON

class ShopCardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImg: UIImageView!
    
    @IBOutlet weak var ShopName: UILabel!
    
    @IBOutlet weak var itemPrice: UILabel!
    
    @IBOutlet weak var viewDetail: UIButton!
    
    @IBOutlet weak var AddToFavorite: UIButton!
    
    var popup: ItemDetailViewController?
    var controller :ShopsViewController?
    
    @IBAction func viewDetai(_ sender: UIButton) {
        popup?.shopName.text = ShopName.text
        popup?.itemPrice.text = itemPrice.text
        popup?.itemDescription.text = controller?.merchandize?.detail
        popup?.itemName.text = controller?.merchandize?.name
        
        let caller = controller!
        caller.addChild(popup!)
        popup!.view.frame = caller.view.frame
        caller.view.addSubview(popup!.view)
        popup!.didMove(toParent: caller)
    }
     
    func getData(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImg(url: String) {
        print("Download Started")
        // show indicator
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        self.productImg.addSubview(indicator)
        indicator.color = UIColor.orange
        indicator.frame = self.productImg.frame
        indicator.center = self.productImg.center
        indicator.sizeToFit()
        indicator.startAnimating()
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            guard let Url = URL(string: url) else {return}
            self.getData(url: Url) { (data, response, error) in
                if let data = data, error == nil {
                    print(response?.suggestedFilename ?? Url.lastPathComponent)
                    print("Download Finished")
                    DispatchQueue.main.async() {
                        self.productImg.image = UIImage(data: data)
                        indicator.stopAnimating()
                    }
                }
                else {
                    DispatchQueue.main.async() {
                        print("Download Failed")
                        indicator.stopAnimating()
                    }
                }
            }
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 3.0
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 5, height: 10)
        
        self.clipsToBounds = false
    }
}