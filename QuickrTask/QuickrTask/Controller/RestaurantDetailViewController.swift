//
//  RestaurantDetailViewController.swift
//  QuickrTask
//
//  Created by Hos on 25/01/18.
//  Copyright © 2018 HoshiyarSinghQuikrTask. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController
{
    @IBOutlet weak var causins: UILabel!
    @IBOutlet weak var priceRange: UILabel!
    @IBOutlet weak var costForTwo: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var restaurantImage: MyCacheableImageView!
    var selectedResturant:Restaurant?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        updateUI()
        self.edgesForExtendedLayout = []
    }
    private func updateUI()
    {
        if let imageData = selectedResturant?.image
        {
            restaurantImage.image = UIImage(data: imageData)
            print("from image Data")
        }
        else
        {
            restaurantImage.downloadImageUsingCacheWithURLString(selectedResturant?.thumURL ?? " ", placeHolder: UIImage(named:"placeholder"))
        }
        name.text = selectedResturant?.name ?? "No Name **"
        causins.text = selectedResturant?.cuisines ?? "There is no cuisines detail"
        priceRange.text =  "\(selectedResturant?.priceRannge ?? 1)  / 5   "
        costForTwo.text = "\( selectedResturant?.costForTwo ?? 500)   "
        rating.text =  "\(String(describing: selectedResturant?.rating ?? "0")) / 5   "
    }
}
