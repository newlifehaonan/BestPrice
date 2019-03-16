//
//  FavoriteTableViewCell.swift
//  BestPrice
//


import UIKit

//using objects created  from favorite view controller to populate table view cells 
class FavoriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var BestPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func getData(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImg(url: String) {
        print("Download Started")
        // show indicator
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        self.itemImage.addSubview(indicator)
        indicator.color = UIColor.orange
        indicator.frame = self.itemImage.frame
        indicator.center = self.itemImage.center
        indicator.sizeToFit()
        indicator.startAnimating()
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.0) {
            guard let Url = URL(string: url) else {
                return
            }
            self.getData(url: Url) { (data, response, error) in
                if let data = data, error == nil {
                    print(response?.suggestedFilename ?? Url.lastPathComponent)
                    print("Download Finished")
                    DispatchQueue.main.async() {
                        self.itemImage.image = UIImage(data: data)
                        indicator.stopAnimating()
                    }
                } else {
                    DispatchQueue.main.async() {
                        print("Download Failed")
                        indicator.stopAnimating()
                    }
                }
            }
        }
    }
    
}

