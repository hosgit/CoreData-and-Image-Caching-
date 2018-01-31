//
//  LocationManager.swift
//  QuickrTask
//
//  Created by Hos on 25/01/18.
//  Copyright © 2018 HoshiyarSinghQuikrTask. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationMangerDelegate
{
    func didUpdateLatestLocation()
}

final public class LocationManager:NSObject,CLLocationManagerDelegate
{
    private let locationManager = CLLocationManager()
    private var authorizationCopletion: ((Bool)->())?
    static let shared = LocationManager()
    private(set) var myCurrentLocation:CLLocation?
    var delegate:LocationMangerDelegate?
    
    private override init()
    {
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = 100
    }
    
    func requestForAccess(completion:@escaping (Bool)->())
    {
        authorizationCopletion = completion
        locationManager.requestWhenInUseAuthorization()
    }
    
    func  startLocationUpdate()
    {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        {
            locationManager.startUpdatingLocation()
        }
    }
    
    //Delegate CLlocaiton manager
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        authorizationCopletion?(status == .authorizedWhenInUse)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        print("updating location")
        myCurrentLocation = locations.first
        delegate?.didUpdateLatestLocation()
    }
    
}
