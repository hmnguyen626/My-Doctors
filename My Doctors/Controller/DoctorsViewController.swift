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

class DoctorsViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate {
    

    //------------------------------------------------------------------------------------
    //MARK - Declare Views
    let searchBarContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 153/255, green: 173/255, blue: 255/255, alpha: 0.5)
        
        return view
    }()
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "  Search by zipcode "
        textField.font = UIFont(name: "Menlo-Regular", size: 16)
        textField.backgroundColor = UIColor.white

        
        
        return textField
    }()
    
    //------------------------------------------------------------------------------------
    //MARK - API requirements
    //https://developer.betterdoctor.com/documentation15#/
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
        
        // UISetup
        setupUI()
    }

    //------------------------------------------------------------------------------------
    //MARK - Setup Views
    private func setupUI(){
        // Top container
        view.addSubview(searchBarContainerView)
        searchBarContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        searchBarContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchBarContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBarContainerView.heightAnchor.constraint(equalToConstant: 135).isActive = true
        
        // Embeded search textfield in top container
        view.addSubview(searchTextField)
        searchTextField.bottomAnchor.constraint(equalTo: searchBarContainerView.bottomAnchor, constant: -8).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: searchBarContainerView.trailingAnchor, constant: -35).isActive = true
        searchTextField.leadingAnchor.constraint(equalTo: searchBarContainerView.leadingAnchor, constant: 35).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        // Rounded corners for textfield
        searchTextField.layoutIfNeeded()
        searchTextField.layer.cornerRadius = searchTextField.frame.size.height / 2
        searchTextField.layer.masksToBounds = true
        
        

    }
    
    //------------------------------------------------------------------------------------
    //MARK - TableView Delegate Methods
    
    
    //------------------------------------------------------------------------------------
    //MARK - TableView Datasource Methods
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("")
//    }
    
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
                    // Note: Is there a better way to do this?
                    // Maybe GraphQL: https://www.raywenderlich.com/158433/getting-started-graphql-apollo-ios
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
                    
                    // Testing
                    print(newDoctor.name)
                    print(newDoctor.address)
                    print(newDoctor.description)
                    print("================\n\n")
                    
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
        // https://www.reddit.com/r/swift/comments/517862/what_should_the_horizontal_accuracy_be_for_core/
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            let searchInMilesRadius = "50"
            let location = latitude + "," + longitude + "," + searchInMilesRadius
            let userLocation = latitude + "," + longitude
            
            params = ["location": location, "user_location": userLocation, "user_key": apiKey]
            
            // Use our location latitude and longitude as parameter for our API call
            getDoctorListing(url: url, parameters: params)
        }
    }
    
    // Catches an error and alert user of what type of error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func startLocationManager(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
}

