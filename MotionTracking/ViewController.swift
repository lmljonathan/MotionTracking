//
//  ViewController.swift
//  MotionTracking
//
//  Created by Jonathan Lam on 10/31/16.
//  Copyright © 2016 Limitless. All rights reserved.
//

import UIKit
import CoreMotion
import GooglePlaces
import SwiftLocation

fileprivate extension Selector {
    static let updateData =
        #selector(ViewController.updateData)
}

class ViewController: UIViewController {
    @IBOutlet var activityLabel: UILabel!
    @IBOutlet var coordinateLabel: UILabel!
    @IBOutlet var venueLabel: UILabel!
    
    @IBOutlet var screenBrightnessLabel: UILabel!
    @IBOutlet var manualRefreshButton: UIButton!
    
    let activityManager: CMMotionActivityManager! = CMMotionActivityManager()
    var placesClient: GMSPlacesClient?
    
    var nodes: [Node] = []
        
    lazy var activityTimer: Timer! = Timer.scheduledTimer(timeInterval: 60 * 1,
                                                          target: self,
                                                          selector: .updateData,
                                                          userInfo: nil,
                                                          repeats: true)
    
    @IBAction func performRefresh(_ sender: Any) {
        updateData()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.placesClient = GMSPlacesClient.shared()
        
        setUpActivityManager()
        updateData()
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.getScreenBrightness), name: .UIScreenBrightnessDidChange, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .UIScreenBrightnessDidChange, object: nil)
    }
    
    func updateData(){
        var node: Node! = Node()
        
        getCurrentLocation { (location) in
            node.location = location
            self.coordinateLabel.text = "\(location)"
        }
        
        getCurrentVenue { (venue, venues) in
            node.topVenue = venue
            node.possibleVenues = venues
            self.venueLabel.text = venue.name
            print(venues)
        }
        
        getScreenBrightness { (brightness) in
            node.brightness = brightness
            self.screenBrightnessLabel.text = "\(brightness)"
        }
        
    }
        
    private func setUpActivityManager(){
        self.activityTimer.fire()
        activityManager.startActivityUpdates(to: OperationQueue.main) { (motionActivity) in
            if motionActivity?.stationary == true{
                self.activityLabel.text = "Standing Still"
            }
            if motionActivity?.running == true{
                self.activityLabel.text = "Running"
            }
            if motionActivity?.walking == true{
                self.activityLabel.text = "Walking"
            }
            if motionActivity?.cycling == true{
                self.activityLabel.text = "Cycling"
            }
            if motionActivity?.automotive == true{
                self.activityLabel.text = "Driving"
            }
            
        }
    }
}
