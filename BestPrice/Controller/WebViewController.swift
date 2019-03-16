//
//  WebViewController.swift
//  BestPrice
//


import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var shopWebView: UIWebView!
    var shopURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        guard let nonemptyURL = shopURL else {
            return
        }
        guard let thisURL = URL(string: nonemptyURL) else {
            return
        }
        let thisRequest = URLRequest(url: thisURL)
        shopWebView.loadRequest(thisRequest)
    }
}

