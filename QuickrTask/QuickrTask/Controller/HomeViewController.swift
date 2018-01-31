//
//  HomeViewController.swift
//  QuickrTask
//
//  Created by Hos on 25/01/18.
//  Copyright © 2018 HoshiyarSinghQuikrTask. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

final  class HomeViewController: UIViewController
{

    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Restaurant.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "rating", ascending: false)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedManger.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    @IBOutlet weak var restaurantListTableView: UITableView!
        {
        didSet
        {
            restaurantListTableView.delegate = self
            restaurantListTableView.dataSource = self
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        Restaurant.checkData()
        setUpUI()
        performLocalDataFetch()
        startLocationUpdate()
    }
    
    private func performLocalDataFetch()
    {
        do {
            try self.fetchedhResultController.performFetch()
        } catch let error  {
            print("ERROR: \(error)")
        }
    }
    
    private func setUpUI()
    {
        self.title = "Near By Restaurants"
        view.backgroundColor = .white
        restaurantListTableView.register(RestuarantCell.self, forCellReuseIdentifier: cellIds.restaurantCellId)
    }
    
    
    private func startLocationUpdate()
    {
        LocationManager.shared.delegate = self
        if  CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        {
            LocationManager.shared.startLocationUpdate()
        }
        else
        {
            LocationManager.shared.requestForAccess(completion: { (status) in
                if status
                {
                    LocationManager.shared.startLocationUpdate()
                    self.restaurantListTableView.isHidden = false
                }
                else
                {
                    self.restaurantListTableView.isHidden = true
                }
            })
        }
    }
    
    private func myCurrentLocation() -> CLLocation?
    {
        guard let location =  LocationManager.shared.myCurrentLocation  else {
            return nil
        }
        return location
    }
    
    private func updateResturantListContent()
    {
        let location = myCurrentLocation()
                do {
                    try self.fetchedhResultController.performFetch()
                } catch let error  {
                    print("ERROR: \(error)")
                }
        
        NetworkManger.getRestaurantsNearMe(lat:(location?.coordinate.latitude)!,long:(location?.coordinate.longitude)!) { (result) in
            switch result {
            case .Success(let data):
                self.clearData()
                self.saveInCoreDataWith(array: data)
                Restaurant.checkData()
            case .Error(let message):
                DispatchQueue.main.async {
                    Utility.showAlertWith(title: "Error", message: message,controller:self)
                }
            }
        }
    }
    
    private func saveInCoreDataWith(array: [[String: AnyObject]]) {
        _ = array.map{Restaurant.createPhotoEntityFrom(context:CoreDataManager.sharedManger.managedObjectContext,dictionary: $0)}
             CoreDataManager.sharedManger.saveContext()
    }
    
    private func clearData() {
        do {
            
            let context = CoreDataManager.sharedManger.managedObjectContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Restaurant.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataManager.sharedManger.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    
    private func navigateToDetailViewController(restaurant selectedRestaurant:Restaurant)
    {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: StoryBoardID.detailController) as! RestaurantDetailViewController
        detailVC.selectedResturant = selectedRestaurant
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    func configureCell(_ cell: RestuarantCell, at indexPath: IndexPath) {
        if let restaurant = fetchedhResultController.object(at: indexPath) as? Restaurant {
            cell.setCellWith(restaurant: restaurant)
            // Configure Cell
        }
    }
}

// table view delegate and datea sources

extension HomeViewController:UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let restaurant = fetchedhResultController.object(at: indexPath) as? Restaurant
        if let selectedRestaurant = restaurant
        {
            navigateToDetailViewController(restaurant: selectedRestaurant)
        }
    }
}

extension HomeViewController:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let count = fetchedhResultController.sections?.first?.numberOfObjects {
            return count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIds.restaurantCellId, for: indexPath) as! RestuarantCell
        
//        if let restaurant = fetchedhResultController.object(at: indexPath) as? Restaurant {
//            cell.setCellWith(restaurant: restaurant)
//        }
        configureCell(cell, at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.width + 100 //100 = sum of labels height + height of divider line
    }
}



//Fetch contoller delegates
extension HomeViewController:NSFetchedResultsControllerDelegate
{
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                restaurantListTableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                restaurantListTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath, let cell = restaurantListTableView.cellForRow(at: indexPath) as? RestuarantCell {
                configureCell(cell, at: indexPath)
            }
            break;
        case .move:
            if let indexPath = indexPath {
                restaurantListTableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                restaurantListTableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break;
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // UIView.animate(withDuration: 1.0) {
            self.restaurantListTableView.endUpdates()
       //   }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
              //  UIView.animate(withDuration: 1.0) {
                    self.restaurantListTableView.beginUpdates()
        
        //  }
        
    }
}

//Location update
extension HomeViewController:LocationMangerDelegate
{
    func didUpdateLatestLocation()
    {
        self.updateResturantListContent()
    }
}
