//
//  ViewController.swift
//  My Doctors
//
//  Created by Hieu Nguyen on 6/12/18.
//  Copyright © 2018 HMdev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    //------------------------------------------------------------------------------------
    //MARK - API requirements
    let url = "https://api.betterdoctor.com/2016-03-01/practices"
    let apiKey = "534c28f7bb1bea633e0ea1ad14594904"
    var params: [String: String] = [:]
    var doctorsJSON = JSON()
    
    // Instance variables
    let locationManager = CLLocationManager()
    var doctorsArray = [Doctor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Assign locationManager delegate to this ViewController, whenInUse, and startUpdating
        startLocationManager()
        
    }

    
    
    //------------------------------------------------------------------------------------
    //MARK - Networking
    // Provided by Alamofire Documentation:  This function makes a .get request to our API endpoint that
    // provides a list of practices near a user's location.  The returned JSON object can be parsed to
    // get detailed information on:
    //                              practice's location,
    //                              doctors (name,bio,rating),
    //                              specialties
    func getDoctorListing(url: String, parameters: [String:String]){
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            
            if response.result.isSuccess {
                print("Success!  Got doctor listing.")

                // Create JSON object
                let doctorListJSON: JSON = JSON(response.result.value!)
                
                // Call our function to parse and append Doctor objects
                self.parseData(json: doctorListJSON)
                
            } else {
                print("Error \(String(describing: response.result.error))")
            }
            
        }
    }
    
    // Parsing JSON and appending Doctor objects to our [Doctor]
    func parseData(json: JSON){
        // Get size of practices for inner loop
        let numberOfPractices = json["data"].count
        
        // Loop through all practices, and get the list of doctors
        for i in 0...numberOfPractices {
            let numberOfDoctors = json["data"][i]["doctors"].count
            
            // Only parse the JSON if there is a doctor in the clinic
            if numberOfDoctors > 0 {
                for j in 0...numberOfDoctors - 1 {
                    // Doctor Bio
                    let clinic = json["data"][i]["name"].string
                    let firstName = json["data"][i]["doctors"][j]["profile"]["first_name"].string
                    let lastName = json["data"][i]["doctors"][j]["profile"]["last_name"].string
                    let gender = json["data"][i]["doctors"][j]["profile"]["gender"].string
                    let title = json["data"][i]["doctors"][j]["profile"]["title"].string
                    let description = json["data"][i]["doctors"][j]["profile"]["bio"].string
                    let streetAddress = json["data"][i]["visit_address"]["street"].string! + ", " + json["data"][i]["visit_address"]["city"].string!
                    let state = json["data"][i]["visit_address"]["state"].string
                    let zip = json["data"][i]["visit_address"]["zip"].string
                    let fullAddress = streetAddress + ", " + state! + " " + zip!
                    
                    // New Doctor object
                    let newDoctor = Doctor(fName: firstName!, lName: lastName!, gender: gender!, title: title!, description: description!, clinic: clinic!, address: fullAddress, accept: true)

                    
                    // Distance and ImageURL - Information might be missing (use optional)
                    if let distance = json["data"][i]["distance"].float {
                        newDoctor.distance = distance
                    }
                    if let imageURL = json["data"][i]["doctors"][j]["profile"]["image_url"].string {
                        newDoctor.imageURL = imageURL
                    }

                    // Append new doctor to [Doctor]
                    doctorsArray.append(newDoctor)
                }
            }
        }
    }
    

    
    
    //------------------------------------------------------------------------------------
    //MARK - Location manager delegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Because locationManager gives us an array of CLLocations, we want to retrieve the last location
        let location = locations[locations.count - 1]
        
        // Conditional to check if location is valid using "horizontalAccuracy".  If valid then stop
        // updating location (save's user battery and better UX), store user location, and unassign delegate.
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            let searchInMilesRadius = "50"
            let location = latitude + "," + longitude + "," + searchInMilesRadius
            let userLocation = latitude + "," + longitude
            
            params = ["location": location, "user_location": userLocation, "user_key": apiKey]
            getDoctorListing(url: url, parameters: params)
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func startLocationManager(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
}

