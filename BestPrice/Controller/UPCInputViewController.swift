//
//  UPCInputViewController.swift
//  BestPrice
//
//  Created by Harry Chen on 3/9/19.
//  Copyright © 2019 Harry Chen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import WBLoadingIndicatorView

class UPCInputViewController: UIViewController {

    @IBOutlet weak var UPCInputField: UITextField!
    
    @IBOutlet weak var searchByType: UIButton!
    
    let UPC_URL = "https://api.upcitemdb.com/prod/v1/lookup"
    let APP_ID = "cf77f17969f5fe8f87c7904c6c87460d"
    let KEY_TYPE = "3scale"
    let headers: HTTPHeaders = [
        "user_key": "cf77f17969f5fe8f87c7904c6c87460d",
        "key_type": "3scale"
    ]
    var good = Merchandize()
    
    override func viewWillAppear(_ animated: Bool) {
         self.tabBarController?.tabBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        good = Merchandize()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Getmerchandizelist" {
            let destinationVC = segue.destination as! ShopsViewController
            //            destinationVC.delegate = self
            destinationVC.merchandize = good
        }
    }
    
    // MARK: RESTFUL Call
    @IBAction func FetchingData(_ sender: Any) {
        if let code = UPCInputField.text {
            sendUPCode(upc: code)
        }
        else {
            print("Error invalid input)")
        }
    }
    
    //MARK: - NetWorking
    func getItem(url: String, params:[String: String], completion: @escaping (Bool, JSON?, Error?) -> Void){
        print("now getting data from server!")
        
        //MARK: Using WBLoadingView
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
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            Alamofire.request(url, method: .get, parameters: params, headers: self.headers).responseJSON {
                response in
                switch response.result {
                case .success:
                    print("Success! Got the item data")
                    let ItemJSON: JSON  = JSON(response.result.value!)
                    print(ItemJSON)
                    DispatchQueue.main.async() {
                        print("start parsing data from JSON to my local variable")
                        if ItemJSON["code"] == "INVALID_UPC" {
                            indicator.wb_hideLoadingView(true)
                            let alert = UIAlertController(title: "Sorry", message: "Invalid UPC Code", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
                            self.present(alert, animated: true, completion: nil)
                            indicator.wb_hideLoadingView(true)
                        }
                        else {
                            if ItemJSON["items"].count == 0 {
                                let alert = UIAlertController(title: "Sorry", message: "No Item Available", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
                                self.present(alert, animated: true, completion: nil)
                                indicator.wb_hideLoadingView(true)
                            }
                            else {
                                completion(true, ItemJSON, nil)
                                indicator.wb_hideLoadingView(true)
                                self.performSegue(withIdentifier: "Getmerchandizelist", sender:self.searchByType)
                            }
                        }
                    }
                case .failure:
                    print("failure! return data failed")
                    DispatchQueue.main.async() {
                        completion(false, nil, response.result.error)
                        //MARK: stop the animation here.
                        indicator.wb_hideLoadingView(true)
                        self.performSegue(withIdentifier: "Getmerchandizelist", sender:self.searchByType)
                    }
                }
            }
        }
    }
    
    //MARK: updateMerchandize data
    func updateMerchandizedata(json: JSON){
        if let returnvalue = json["items"].array {
            let result = returnvalue[0].dictionary!
            good.name = result["title"]!.stringValue
            good.detail = result["description"]!.stringValue
            good.ImageURLs = good.convertJSON(jsonarray: result["images"]!.arrayValue)
            
            if let shopsDetail = result["offers"]?.array{
                for shop in shopsDetail {
                    let shopdetail = shop.dictionary!
                    good.addShop(shop: Retailer(
                        name: shopdetail["merchant"]!.stringValue,
                        URL: shopdetail["link"]!.stringValue,
                        price: shopdetail["price"]!.doubleValue))
                }
            }
            
        }
    }
    
    func sendUPCode(upc: String) {
        let params = ["upc": upc]
        getItem(url: UPC_URL, params: params) { (response, data, error) in
            if response {
                guard let merchandizeData = data else {return}
                self.updateMerchandizedata(json: merchandizeData)
                print("now my data is in the local variable!")
            }
            else if let error = error {
                print("Error \(error)")
            }
        }
    }

}
