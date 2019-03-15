//
//  Merchandize.swift
//  BestPrice
//
//  Created by Harry Chen on 3/9/19.
//  Copyright © 2019 Harry Chen. All rights reserved.
//

import Foundation
import SwiftyJSON

class Merchandize: NSObject {
    var name: String = ""
    var detail: String = ""
    var ImageURLs = [String]()
    var shops = [Retailer]()
  

    init(name: String, detail: String, images: [String], shops: [Retailer] ){
    self.name = name
    self.detail = detail
    self.ImageURLs = images
    self.shops = shops
    }
    override init(){
    
    }
    
    func convertJSON(jsonarray: [JSON]) -> [String]{
        for i in jsonarray {
            ImageURLs.append(i.stringValue)
        }
        return ImageURLs
    }
    
    func addShop(shop: Retailer) {
        shops.append(shop)
    }
}
