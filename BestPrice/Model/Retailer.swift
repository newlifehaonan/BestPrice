//
//  Retailer.swift
//  BestPrice
//
//  Created by Harry Chen on 3/9/19.
//  Copyright © 2019 Harry Chen. All rights reserved.
//

import Foundation
class Retailer: NSObject {
    var name: String = ""
    var URL: String = ""
    var price: Double = 0
    
    init(name: String, URL: String, price: Double) {
        self.name = name
        self.price = price
        self.URL = URL
    }
}
