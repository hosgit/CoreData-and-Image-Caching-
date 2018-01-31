//
//  Constants.swift
//  QuickrTask
//
//  Created by Hos on 25/01/18.
//  Copyright © 2018 HoshiyarSinghQuikrTask. All rights reserved.
//

import Foundation
struct StoryBoardID
{
    static let detailController = "RestaurantDetailViewController"
}

struct LocalURL
{
   public static func  getRestaurantUrlFrom(lat:Double,long:Double) -> String
   {
     let homeURL = "https://developers.zomato.com/api/v2.1/search?entity_type=subzone&start=0&count=50&lat=\(lat)&lon=\(long)&radius=10000&sort=rating&order=desc"
      return homeURL
   }
}

struct NetworkConstants
{
    static let httpGet = "GET"
    static let headerAcceptKey = "Accept"
    static let headerUserKey = "user-key"
    static let headerAcceptTypeJSON = "application/json"
    static let headerUserValue = "141fd96cb14d6cb1ef428e50b5aed26a"
    static let responseRestaurantKey = "restaurants"
}

struct  cellIds
{
    static let restaurantCellId = "cellID"
}



