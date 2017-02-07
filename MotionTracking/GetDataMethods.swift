//
//  GetDataMethods.swift
//  MotionTracking
//
//  Created by Jonathan Lam on 1/30/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation
import GooglePlaces
import SwiftLocation

extension ViewController {
    func getScreenBrightness(completion: (_ brightness: Double) -> Void){
        let brightness = Double(UIScreen.main.brightness)
        completion(brightness)
    }
    
    func getCurrentVenue(completion: @escaping (_ venue: Venue, _ possibleVenues: [Venue]) -> Void){
        placesClient?.currentPlace(callback: { (placeLikelihoods, error) -> Void in
            guard error == nil else {
                print("Current Place error: \(error!.localizedDescription)")
                return
            }
            
            if let placeLikelihoods = placeLikelihoods {
                var endIndex = 2
                
                if placeLikelihoods.likelihoods.count < 3{
                    endIndex = placeLikelihoods.likelihoods.endIndex
                }
                
                var venues: [Venue]! = []
                
                for likelihood in placeLikelihoods.likelihoods[0...endIndex]{
                    let place = likelihood.place
                    
                    var venue = Venue()
                    venue.name = place.name
                    venue.address = place.formattedAddress!
                    venue.likelihoodScore = likelihood.likelihood
                    
                    venues.append(venue)
                }
                
                completion(venues[0], venues)
            }
        })
    }
    
    func getCurrentLocation(continuous: Bool = false, completion: @escaping (_ location: (Double, Double)) -> Void){
        let getLocation = Location.getLocation
        
        _ = getLocation(.any, .oneShot, 300, { (foundLocation) in
            let coordinate = foundLocation.coordinate
            let location = (Double(coordinate.latitude), Double(coordinate.longitude))
            completion(location)
        }) { (_, error) in
            print("Could not get current location: \(error)")
        }
    }

}
