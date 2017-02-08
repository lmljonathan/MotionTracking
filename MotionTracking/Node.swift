//
//  Node.swift
//  MotionTracking
//
//  Created by Jonathan Lam on 11/10/16.
//  Copyright © 2016 Limitless. All rights reserved.
//

import Foundation
import UIKit

struct Node {
    var location: (Double, Double)?
    var activity: String?
    
    var topVenue: Venue?
    var possibleVenues: [Venue]?
    var brightness: Double?
    
    func description() -> String {
        return "Top Venue: \(topVenue)\nBrightness: \(brightness)\nLocation: \(location)"
    }
    func toDictionary() -> [String:Any] {
        return ["longitude":location?.0,"latitude":location?.1,"venue":topVenue?.name,"brightness":brightness]
    }
}

struct Venue {
    var name: String!
    var address: String!
    var likelihoodScore: Double!
}
