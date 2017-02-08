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
import SwiftyTimer

class ViewController: UIViewController {
    @IBOutlet var activityLabel: UILabel!
    @IBOutlet var coordinateLabel: UILabel!
    @IBOutlet var venueLabel: UILabel!
    
    @IBOutlet var screenBrightnessLabel: UILabel!
    @IBOutlet var manualRefreshButton: UIButton!
    @IBOutlet var timerLabel: UILabel!
    
    let activityManager: CMMotionActivityManager! = CMMotionActivityManager()
    var placesClient: GMSPlacesClient?
    
    var nodes: [Node] = []
    
    var timer: Timer!
    var secondsUntilUpdate: Int = 0
    var timeTilUpdate = 1 // in minutes
    
    @IBAction func performRefresh(_ sender: Any) {
        updateData()
        self.secondsUntilUpdate = 500
        let timeString = "\(self.secondsUntilUpdate / 60):\(self.secondsUntilUpdate%60)"
        self.timerLabel.text = timeString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Timer
        self.secondsUntilUpdate = timeTilUpdate * 60
        self.timer = Timer.new(every: 1.second, {
            self.secondsUntilUpdate -= 1
            let timeString = "\(self.secondsUntilUpdate / 60):\(self.secondsUntilUpdate%60)"
            self.timerLabel.text = timeString
            
            
            if self.secondsUntilUpdate == 0 {
                self.secondsUntilUpdate = self.timeTilUpdate * 60
                self.updateData { (node) in
                    print(node.description())
                }
            }
        })
        
        self.timer.start()
        
        
        self.placesClient = GMSPlacesClient.shared()
        
        setUpActivityManager()
        updateData { (node) in
            // print(node.description())
        }
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.getScreenBrightness), name: .UIScreenBrightnessDidChange, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .UIScreenBrightnessDidChange, object: nil)
    }
    
    func updateData(completion: ((_ n: Node) -> Void)? = nil){
        var node: Node! = Node()
        
        DispatchQueue.main.async{
            self.getCurrentLocation { (location) in
                node.location = location
                self.coordinateLabel.text = "\(location)"
            }
            
            self.getCurrentVenue { (venue, venues) in
                node.topVenue = venue
                node.possibleVenues = venues
                self.venueLabel.text = venue.name
                print(node.description())
                completion!(node)
            }
            
            self.getScreenBrightness { (brightness) in
                node.brightness = brightness
                self.screenBrightnessLabel.text = "\(brightness)"
            }
            
//            self.activityManager.queryActivityStarting(from: <#T##Date#>, to: <#T##Date#>, to: <#T##OperationQueue#>, withHandler: { (<#[CMMotionActivity]?#>, <#Error?#>) in
//                <#code#>
//            })
        }
    }
        
    private func setUpActivityManager(){
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
