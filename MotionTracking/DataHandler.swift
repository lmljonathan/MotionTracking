//
//  DataHandler.swift
//  MotionTracking
//
//  Created by Jonathan Lam on 11/6/16.
//  Copyright © 2016 Limitless. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation

class DataHandler {
    
    let base = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    var params = ["key": "AIzaSyCwz0NEe0TCqASETjbnWQNqbdQkwMIbmFo", "keyword": ""]
    
    // MARK: - Public Methods
    public func getVenue(location: CLLocationCoordinate2D, completion: @escaping (_ place: String) -> Void){
        self.params["location"] = "\(location.latitude),\(location.longitude)"
        let url = self.buildURLString(base: base, parameters: params)
        getData(from: url) { (place) in
            completion(place)
        }
    }
    
    // MARK: - Private Methods
    private func buildURLString(base: String, parameters: [String: String]) -> String{
        var result = base
        for (key, value) in parameters{
            let addString = key + "=" + value + "&"
            result += addString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        }
        return result
    }
    
    private func getData(from URLString: String, completion: @escaping (_ place: String) -> Void){
        Alamofire.request(URLString).responseJSON { response in
            if let json = response.result.value {
                //print("JSON: \(JSON)")
                let json = JSON(data: response.data!)
                if let place = json["results"][0]["name"].string {
                    completion(place)
                }
            }
        }
    }
    
    // MARK: - Init & Override
    init(){
        
    }
    
    
    
}
