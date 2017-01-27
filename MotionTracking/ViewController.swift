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

class ViewController: UIViewController {
    
    @IBOutlet var activityLabel: UILabel!
    @IBOutlet var coordinateLabel: UILabel!
    @IBOutlet var venueLabel: UILabel!
    
    @IBOutlet var screenBrightnessLabel: UILabel!
    @IBOutlet var manualRefreshButton: UIButton!
    
    let activityManager: CMMotionActivityManager! = CMMotionActivityManager()
    var placesClient: GMSPlacesClient?
    
    var locationNames: [String] = []
    var locationAddresses: [String] = []
    var likelihoodScores: [Double] = []
    
    var nodes: [Node] = []
    
    lazy var activityTimer: Timer! = Timer.scheduledTimer(timeInterval: 60 * 5,
                                                          target: self,
                                                          selector: #selector(self.updateData),
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
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.getScreenBrightness), name: .UIScreenBrightnessDidChange, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .UIScreenBrightnessDidChange, object: nil)
    }
    
    func updateData(node: inout Node){
        getCurrentLocation(node: &node)
        getCurrentVenue(node: &node)
        getScreenBrightness(node: &node)
    }
    
    func getScreenBrightness(node: inout Node){
        node.brightness = Double(UIScreen.main.brightness)
        self.screenBrightnessLabel.text = "\(UIScreen.main.brightness)"
    }
    
    func getCurrentVenue(node: inout Node){
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
                
                for likelihood in placeLikelihoods.likelihoods[0...endIndex]{
                    let place = likelihood.place
                    self.locationNames.append(place.name)
                    self.locationAddresses.append(place.formattedAddress!)
                    self.likelihoodScores.append(likelihood.likelihood)
                }
                
                if self.locationNames.count > 0{
                    self.venueLabel.text = self.locationNames[0]
                    print("locationNames: \(self.locationNames)\nlocationLiklihoods: \(self.likelihoodScores)\nlocationAddresses: \(self.locationAddresses)")
                }
            }
        })
    }
    
    func getCurrentLocation(node: inout Node, continuous: Bool = false){
        let getLocation = Location.getLocation
        
        getLocation(.any, .oneShot, 300, { (foundLocation) in
            let coordinate = foundLocation.coordinate
            node.location = (Double(coordinate.latitude), Double(coordinate.longitude))
            self.coordinateLabel.text =  "\(coordinate.latitude) \(coordinate.longitude)"
        }) { (_, error) in
            print("Could not get current location: \(error)")
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
