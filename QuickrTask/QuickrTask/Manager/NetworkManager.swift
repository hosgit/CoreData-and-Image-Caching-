//
//  NetworkManager.swift
//  QuickrTask
//
//  Created by Hos on 25/01/18.
//  Copyright © 2018 HoshiyarSinghQuikrTask. All rights reserved.
//

import Foundation
final public class NetworkManger
{
    static func getRestaurantsNearMe(lat latitude:Double, long longitude:Double,completion: @escaping (Result<[[String: AnyObject]]>) -> Void)
    {
        let urlString = LocalURL.getRestaurantUrlFrom(lat: latitude, long: longitude)
        let url:URL = URL(string:urlString)!
        var request = URLRequest(url: url)
        request.setValue(NetworkConstants.headerAcceptTypeJSON, forHTTPHeaderField: NetworkConstants.headerAcceptKey)
        request.setValue(NetworkConstants.headerUserValue, forHTTPHeaderField: NetworkConstants.headerUserKey)
        request.httpMethod = NetworkConstants.httpGet
        
        _ = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {  return completion(.Error(error!.localizedDescription))  }
            guard let unwrappedData = data else {return completion(.Error(error?.localizedDescription ?? "Now Restaurants to show")) }
            do {
                guard let result = try JSONSerialization.jsonObject(with: unwrappedData, options: .allowFragments) as? Dictionary<String,AnyObject>
                    else{return completion(.Error(error?.localizedDescription ?? "Now Restaurants to show")) }
                if let restaurantList = result[NetworkConstants.responseRestaurantKey] as? Array<Dictionary<String,AnyObject>>
                {
                   // print(restaurantList.count)
                    DispatchQueue.main.async {
                        
                        completion(.Success(restaurantList))
                    }
                }
                
            } catch let error {
                completion(.Error(error.localizedDescription))
            }
            }.resume()
    }
}

enum Result<T> {
    case Success(T)
    case Error(String)
}
