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
    
}

struct Venue {
    var name: String!
    var address: String!
    var likelihoodScore: Double!
}
