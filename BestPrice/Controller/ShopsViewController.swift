//
//  ShopsViewController.swift
//  BestPrice
//
//  Created by Harry Chen on 3/9/19.
//  Copyright © 2019 Harry Chen. All rights reserved.
//

import UIKit

class ShopsViewController: UIViewController {

    
    @IBOutlet weak var ShopCardCollections: UICollectionView!
    let cellScaling: CGFloat = 0.6
    var merchandize: Merchandize?
    override func viewDidLoad() {
        super.viewDidLoad()

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
            
            guard let numbOfImg = merchandize?.ImageURLs.count else { return cell}
            let ramdomizedIndex = Int.random(in: 0..<numbOfImg)
            guard let imgurl = merchandize?.ImageURLs[ramdomizedIndex] else { return cell}
            cell.downloadImg(url: imgurl)
            return cell
        }
        return cell
    }
    
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
