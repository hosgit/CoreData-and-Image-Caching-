//
//  RestuarantCell.swift
//  QuickrTask
//
//  Created by Hos on 25/01/18.
//  Copyright © 2018 HoshiyarSinghQuikrTask. All rights reserved.
//

import Foundation
import Foundation
import UIKit


class RestuarantCell: UITableViewCell {
    
    let photoImageview: MyCacheableImageView = {
        let iv = MyCacheableImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16 , weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let cousineLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dividerLineView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isUserInteractionEnabled = true
        
        addSubview(photoImageview)
        addSubview(nameLabel)
        addSubview(cousineLabel)
        addSubview(dividerLineView)
        
        photoImageview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        photoImageview.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        photoImageview.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        photoImageview.heightAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -14).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 14).isActive = true
        nameLabel.topAnchor.constraint(equalTo: photoImageview.bottomAnchor).isActive = true
        
        dividerLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        dividerLineView.leftAnchor.constraint(equalTo: leftAnchor, constant: 14).isActive = true
        dividerLineView.rightAnchor.constraint(equalTo: rightAnchor, constant: -14).isActive = true
        dividerLineView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        
        cousineLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cousineLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -14).isActive = true
        cousineLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 14).isActive = true
        cousineLabel.topAnchor.constraint(equalTo: dividerLineView.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setCellWith(restaurant: Restaurant) {
        DispatchQueue.main.async {
            self.nameLabel.text = "\(restaurant.name ?? "No Name")" + "  ID:\(restaurant.id ?? "No ID")"
            self.cousineLabel.text = restaurant.cuisines
            
            if let imageData = restaurant.image
            {
                 let image = UIImage(data: imageData)
                 self.photoImageview.image = image
            //    print("from image Data")
                return
            }
            if let url = restaurant.thumURL {
                self.photoImageview.downloadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"))
             //   print("from image cache")

            }
        }
    }
}
