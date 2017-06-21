//
//  LocationService.swift
//  Wynfood
//
//  Created by craftman on 4/26/17.
//  Copyright © 2017 craftman. All rights reserved.
//

import Foundation
import MapKit

let MILE = 0.000621371

@objc protocol LocationServiceDelegate: class {
    
    @objc optional func didUpdateCurrentLocation()
    @objc optional func locationServiceDidFailed(error: String)
    @objc optional func locationServiceRestricted(message: String)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    // MARK: - Properties
    private let locationManager = CLLocationManager()
    var restaurantService: RestaurantService! = nil
    var currentLocation: CLLocation?
    weak var locationDelegate: LocationServiceDelegate?
    
    
    // MARK: - Initialization
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = 500;
        
    }
    
    // MARK: - Methods
    func createSourceAndDestinationItems(destination: CLLocation) -> (source: MKMapItem, destination: MKMapItem) {
        
        let sourceLocationCoordinates = createCoordinatesFromLocation(location: currentLocation!)
        let destinationLocationCoordinates = createCoordinatesFromLocation(location: destination)
        
        let destinationLocationPlacemark = createPlacemMarkFromCoordinate(coordinate: destinationLocationCoordinates)
        let sourceLocationPlacemark = createPlacemMarkFromCoordinate(coordinate: sourceLocationCoordinates)
        
        let destinationLocation = MKMapItem(placemark: destinationLocationPlacemark)
        let sourceLocation = MKMapItem(placemark: sourceLocationPlacemark)
        
        return (sourceLocation, destinationLocation)
    }

    
    func distanceInMilesToDestination(destination: CLLocation, name: String, completion: @escaping (String) -> Void) {
        
        let mkMapItemSourceAndDestination = createSourceAndDestinationItems(destination: destination)
        
        let drivingRequest = createDrivingRequest(source: mkMapItemSourceAndDestination.source, destination: mkMapItemSourceAndDestination.destination, name: name)
        
        let mkDirections = MKDirections(request: drivingRequest)
        mkDirections.calculateETA(completionHandler: { (response, error) in
        
            if (error != nil) {
        
                print(error!)
                return
            }
        
            let distanceInMiles = self.covertMetersToMiles(distanceInMeters: (response?.distance)!)
        
            completion(distanceInMiles)
        })
    }
    
    
    func createCoordinatesFromLocation(location: CLLocation) -> CLLocationCoordinate2D  {
        
       return CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
    }
    
    
    func createPlacemMarkFromCoordinate(coordinate: CLLocationCoordinate2D) -> MKPlacemark {
        
        return MKPlacemark(coordinate: coordinate)
    }
    
    
    func covertMetersToMiles(distanceInMeters: CLLocationDistance) -> String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1
        
        let distanceInMiles = distanceInMeters * MILE
        
        return numberFormatter.string(from: distanceInMiles as NSNumber)!
    }
    
    
    func createDrivingRequest(source: MKMapItem , destination: MKMapItem, name: String) -> MKDirectionsRequest {
        
        let drivingRequest = MKDirectionsRequest()
        drivingRequest.transportType = .automobile
        drivingRequest.destination = destination
        drivingRequest.destination?.name = name
        drivingRequest.source = source
        
        return drivingRequest
    }

    
    func lauchMapDirections(destination: CLLocation, name: String) {
        
        let mkMapItemSourceAndDestination = createSourceAndDestinationItems(destination: destination)
        
        let directionsRequest = createDrivingRequest(source: mkMapItemSourceAndDestination.source, destination: mkMapItemSourceAndDestination.destination, name: name)

        MKMapItem.openMaps(with: [directionsRequest.destination!], launchOptions: ["MKLauchOptionsDirectionsModeKey": MKLaunchOptionsDirectionsModeDriving])
    }
    
    func createDestinationLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> CLLocation {
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }


    // MARK: - CLLocationManager
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            
            // get the users location
            manager.startUpdatingLocation()
        }
        
        if status == .restricted || status == .denied {

            locationDelegate?.locationServiceRestricted!(message: "Turn on Location Services in Settings > Privacy to allow Wynfood to determine your current location")
        }
        
        if status == .notDetermined {
            
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        locationDelegate?.locationServiceDidFailed!(error: error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // last updated location
        if let location = locations.last {
            
            currentLocation = location
            
            locationDelegate?.didUpdateCurrentLocation!()
        }
    }
}


