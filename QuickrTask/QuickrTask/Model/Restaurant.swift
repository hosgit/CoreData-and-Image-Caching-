//
//  Restaurant.swift
//  QuickrTask
//
//  Created by Hos on 25/01/18.
//  Copyright © 2018 HoshiyarSinghQuikrTask. All rights reserved.
//

import UIKit
import  CoreData
class Restaurant: NSManagedObject
{
    static func createPhotoEntityFrom(context:NSManagedObjectContext,dictionary: [String: AnyObject]) -> NSManagedObject? {
        
        guard  let restauranttDict = dictionary["restaurant"] else {
            return nil
        }
        
        if let restEntity = NSEntityDescription.insertNewObject(forEntityName: "Restaurant", into: context) as? Restaurant {
            restEntity.name = restauranttDict["name"] as? String
            restEntity.costForTwo = restauranttDict["average_cost_for_two"] as? Int32 ?? 0
            restEntity.cuisines = restauranttDict["cuisines"] as? String
            restEntity.id = restauranttDict["id"] as? String
            restEntity.priceRannge = restauranttDict["price_range"] as? Int32 ?? 0
            restEntity.thumURL = restauranttDict["thumb"] as? String
            if let ratingDict = restauranttDict["user_rating"] as? Dictionary<String,String>
            {
                restEntity.rating =  ratingDict["aggregate_rating"] ?? "No ratings"

            }
           print("\(restEntity.name),\(restEntity.rating)")
           return restEntity
        }
        return nil
    }
    
    static  func saveImagePermanantlyOnCoreData(image:UIImage,url:String)
    {
        print( url)
        let fetchRequest:NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        fetchRequest.predicate = NSPredicate(format:"thumURL == %@" , url)
        fetchRequest.sortDescriptors =  [NSSortDescriptor(key: "rating", ascending: false)]
       // CoreDataManager.sharedManager.persistentContainer.performBackgroundTask { (backContext) in
            do
            {
                let restaurant = try CoreDataManager.sharedManger.managedObjectContext.fetch(fetchRequest).first
                guard  restaurant?.image == nil else {
                    return
                }
                restaurant?.image = UIImageJPEGRepresentation(image, 1)
                CoreDataManager.sharedManger.saveContext()
               // print(restaurant?.thumURL)
            }

            catch let error
            {
                print(error.localizedDescription)
            }
       // }
    }
    
    
    static  func checkData()
    {
        print( "checking data")
        let fetchRequest:NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        fetchRequest.sortDescriptors =  [NSSortDescriptor(key: "rating", ascending: false)]
        // CoreDataManager.sharedManager.persistentContainer.performBackgroundTask { (backContext) in
        do
        {
            let restaurants = try CoreDataManager.sharedManger.managedObjectContext.fetch(fetchRequest)
            print(restaurants.count)
        }
            
        catch let error
        {
            print(error.localizedDescription)
        }
        // }
    }
}


