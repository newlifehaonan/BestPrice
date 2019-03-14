//
//  WebViewController.swift
//  BestPrice
//
//  Created by Harry Chen on 3/10/19.
//  Copyright © 2019 Harry Chen. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var shopWebView: UIWebView!
    var shopURL: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        guard let nonemptyURL = shopURL else {return}
        guard let thisURL = URL(string: nonemptyURL) else {return}
        let thisRequest = URLRequest(url: thisURL)
        shopWebView.loadRequest(thisRequest)
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
