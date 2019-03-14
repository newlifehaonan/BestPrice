//
//  ShopsViewController.swift
//  BestPrice
//
//  Created by Harry Chen on 3/9/19.
//  Copyright © 2019 Harry Chen. All rights reserved.
//

import UIKit
import Firebase

class ShopsViewController: UIViewController {
    @IBOutlet weak var ShopCardCollections: UICollectionView!
    var effect: UIVisualEffect!
    let cellScaling: CGFloat = 0.6
    var merchandize: Merchandize?
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle?
      
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        ref = Database.database().reference()
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScaling)
        let cellHeight = floor(screenSize.height * cellScaling)
        
        let insetX = (view.bounds.width - cellWidth) / 2.0
        let insetY = (view.bounds.height - cellHeight) / 2.0
        
        
        let layout = ShopCardCollections!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        ShopCardCollections?.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        
        ShopCardCollections?.dataSource = self
        ShopCardCollections?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        merchandize = nil
    }
}


extension ShopsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let shops = merchandize?.shops {
            return shops.count
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Merchant", for: indexPath) as! ShopCardCollectionViewCell
        if let shops = merchandize?.shops {
            let shop = shops[indexPath.row]
            cell.ShopName.text = shop.name
            cell.itemPrice.text = "$\(shop.price)"
            
            cell.controller = self
            cell.popup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShopDetailPopUp") as? ItemDetailViewController
            
//            cell.viewDetail.addTarget(self, action: #selector(self.triggleDetailPopUp), for: .touchUpInside)
//            cell.AddToFavorite.addTarget(self, action: #selector(self.addWishlist), for: .touchUpInside)
            
            guard let numbOfImg = merchandize?.ImageURLs.count else { return cell}
            let ramdomizedIndex = Int.random(in: 0..<numbOfImg)
            guard let imgurl = merchandize?.ImageURLs[ramdomizedIndex] else { return cell}
            cell.downloadImg(url: imgurl)
            return cell
        }
        return cell
    }
    
// I don't really need those, but might be useful in the future.
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.currentcellIndex = indexPath
//    }
    
//    @objc func triggleDetailPopUp(sender: UIButton) {
//        let popup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShopDetailPopUp") as! ItemDetailViewController
//
//        popup.detail = merchandize
//        let shopname = merchandize!.shops[currentcellIndex!.row].name
//        let itemprice = merchandize!.shops[currentcellIndex!.row].price
//        popup.shopName.text = shopname
//        popup.itemPrice.text = "$\(itemprice)"
//
//
//        self.addChild(popup)
//        popup.view.frame = self.view.frame
//        self.view.addSubview(popup.view)
//        popup.didMove(toParent: self)
//    }
//    @objc func addWishlist() {
//        print("item added")
//    }
}

extension ShopsViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.ShopCardCollections?.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}
