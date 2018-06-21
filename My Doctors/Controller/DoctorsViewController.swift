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
import SVProgressHUD
import RealmSwift

class DoctorsViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {
    
    //------------------------------------------------------------------------------------
    //MARK - Views
    let searchBarContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 153/255, green: 173/255, blue: 255/255, alpha: 0.5)
        
        return view
    }()
    
    let searchTextFieldContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "  Search by zipcode "
        textField.font = UIFont(name: "Menlo-Regular", size: 14)
        textField.backgroundColor = UIColor.white
        textField.keyboardType = UIKeyboardType.decimalPad
        

        return textField
    }()
    
    let doctorsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 200
        
        // Register our custom cell
        tableView.register(UINib(nibName: "DoctorInformationCell", bundle: nil), forCellReuseIdentifier: "customDoctorCell")
        
        return tableView
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Search", for: .normal)
        button.backgroundColor = UIColor(red: 153/255, green: 173/255, blue: 255/255, alpha: 0.5)
        button.titleLabel?.font = UIFont(name: "Menlo-Regular", size: 15)
        
        // Action
        button.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    //------------------------------------------------------------------------------------
    //MARK - API requirements
    //https://developer.betterdoctor.com/documentation15#/
    let docUrl = "https://api.betterdoctor.com/2016-03-01/practices"
    let docApiKey = "534c28f7bb1bea633e0ea1ad14594904"
    
    //https://www.zipcodeapi.com/API
    let zipUrl = "https://www.zipcodeapi.com/rest"
    let zipApiKey = "IvoPuX3RLG8ycre4ABkWfAajUz8lBt0bVpQqlnLe4WXPzJEJIikc4Hq3HwyCtVJ4"
    

    // Local Variables
    let locationManager = CLLocationManager()
    var userLocation = ""
    var doctorsArray = [Doctor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Assign locationManager delegate to this ViewController, whenInUse, and startUpdating
        startLocationManager()
        
        // Tableview delegates
        doctorsTableView.delegate = self
        doctorsTableView.dataSource = self
        
        // Textfield delegates
        searchTextField.delegate = self
        
        // UISetup
        setupUI()
        
    }

    //------------------------------------------------------------------------------------
    //MARK - Setup views and their constraints
    private func setupUI(){
        // Search bar container
        view.addSubview(searchBarContainerView)
        searchBarContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        searchBarContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchBarContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBarContainerView.heightAnchor.constraint(equalToConstant: 135).isActive = true
        
        // Textfield container that has rounded corners
        view.addSubview(searchTextFieldContainer)
        searchTextFieldContainer.bottomAnchor.constraint(equalTo: searchBarContainerView.bottomAnchor, constant: -9).isActive = true
        searchTextFieldContainer.trailingAnchor.constraint(equalTo: searchBarContainerView.trailingAnchor, constant: -100).isActive = true
        searchTextFieldContainer.leadingAnchor.constraint(equalTo: searchBarContainerView.leadingAnchor, constant: 23).isActive = true
        searchTextFieldContainer.heightAnchor.constraint(equalToConstant: 30).isActive = true
        searchTextFieldContainer.layoutIfNeeded()
        searchTextFieldContainer.layer.cornerRadius = searchTextFieldContainer.frame.size.height / 2
        searchTextFieldContainer.layer.masksToBounds = true
        
        // Search textfield within searchBarContainerView
        view.addSubview(searchTextField)
        searchTextField.bottomAnchor.constraint(equalTo: searchTextFieldContainer.bottomAnchor, constant: 0).isActive = true
        searchTextField.topAnchor.constraint(equalTo: searchTextFieldContainer.topAnchor, constant: 0).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: searchTextFieldContainer.trailingAnchor, constant: -10).isActive = true
        searchTextField.leadingAnchor.constraint(equalTo: searchTextFieldContainer.leadingAnchor, constant: 15).isActive = true
        searchTextField.layoutIfNeeded()
        searchTextField.layer.cornerRadius = searchTextField.frame.size.height / 5
        searchTextField.layer.masksToBounds = true

        // Doctor tableview
        view.addSubview(doctorsTableView)
        doctorsTableView.topAnchor.constraint(equalTo: searchBarContainerView.bottomAnchor, constant: 0).isActive = true
        doctorsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        doctorsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        doctorsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        doctorsTableView.backgroundColor = UIColor(red: 153/255, green: 173/255, blue: 255/255, alpha: 0.5)
        
        // Search Button
        view.addSubview(searchButton)
        searchButton.topAnchor.constraint(equalTo: searchTextFieldContainer.topAnchor, constant: 0).isActive = true
        searchButton.bottomAnchor.constraint(equalTo: searchTextFieldContainer.bottomAnchor, constant: 0).isActive = true
        searchButton.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: 25).isActive = true
        searchButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        
        // Bar Buttons
        // https://stackoverflow.com/questions/39768600/how-to-programmatically-set-action-for-barbuttonitem-in-swift-3/39768655
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonPressed))
        
    }
    
    //------------------------------------------------------------------------------------
    //MARK - TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchTextField.resignFirstResponder()
        
        // Makes true if false, false if true
        doctorsArray[indexPath.row].selected = !doctorsArray[indexPath.row].selected
        
        tableView.reloadData()
    }
    
    // Fix for dynamic cell heights that behaves as "jumpy" when scrolling
    // https://stackoverflow.com/questions/28244475/reloaddata-of-uitableview-with-dynamic-cell-heights-causes-jumpy-scrolling
    var cellHeights: [IndexPath : CGFloat] = [:]
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = cellHeights[indexPath] else { return 200.0 }
        return height
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
        
        // Set cell background color clear so that our tableview's background color is correct on loadup
        cell.backgroundColor = UIColor.clear

    }
    
    //------------------------------------------------------------------------------------
    //MARK - TableView Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctorsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = doctorsTableView.dequeueReusableCell(withIdentifier: "customDoctorCell", for: indexPath) as! DoctorInformationCell
        
        // Assign our custom cell properties with our doctor object
        cell.doctorNameLabel.text = doctorsArray[indexPath.row].name + ", " + doctorsArray[indexPath.row].title
        cell.specialtyLabel.text = doctorsArray[indexPath.row].specialty
        cell.locationLabel.text = doctorsArray[indexPath.row].address
        cell.distanceLabel.text = "\(doctorsArray[indexPath.row].distance) miles away"
        cell.descriptionLabel.text = doctorsArray[indexPath.row].bio
        
        if let imageData = doctorsArray[indexPath.row].imageData {
            cell.doctorImageView.image = UIImage(data: imageData)
        }

        // Ternary operator: value = condition ? valueIfTrue: valueIfFalse
        let green = UIColor(red: 112/255, green: 173/255, blue: 71/255, alpha: 1)
        let lavender = UIColor(red: 125/255, green: 142/255, blue: 211/255, alpha: 1)
        cell.containerView.backgroundColor = doctorsArray[indexPath.row].selected ? green : lavender

        return cell
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
        SVProgressHUD.show()
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            
            if response.result.isSuccess {
                print("Success!  Got doctor listing.")

                // Create JSON object
                let doctorListJSON: JSON = JSON(response.result.value!)
                
                self.doctorsArray = []
                
                // Call our function to parse and append Doctor objects
                self.parseDocJSON(json: doctorListJSON)
                SVProgressHUD.dismiss()
            } else {
                print("Error \(String(describing: response.result.error))")
                SVProgressHUD.dismiss()
            }
            
        }
    }
    
    //------------------------------------------------------------------------------------
    //MARK - Parse Doc api JSON object
    //Parsing JSON and appending Doctor objects to our [Doctor]
    func parseDocJSON(json: JSON){
        
        // Error handling if JSON object is empty
        if !json["data"].exists() {
            
            let alert = UIAlertController(title: "Error", message: "No doctors found or invalid zipcode", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        // Get size of practices for inner loop
        let numberOfPractices = json["data"].count
        
        // Loop through all practices, and get the list of doctors
        for i in 0...numberOfPractices {
            let numberOfDoctors = json["data"][i]["doctors"].count
            
            // Only parse the JSON if there is a doctor in the clinic
            if numberOfDoctors > 0 {
                for j in 0...numberOfDoctors - 1 {
                    
                    // Grabs a new doctor json object
                    let tempDocJSON = json["data"][i]["doctors"][j]
                    
                    // New temporary Doctor object to store future properties and append to list
                    let newDoctor = Doctor()
                    
                    // Note: Is there a better way to do this?
                    // Maybe GraphQL if allowed: https://www.raywenderlich.com/158433/getting-started-graphql-apollo-ios
                    if let firstName = tempDocJSON["profile"]["first_name"].string,
                        let lastName = tempDocJSON["profile"]["last_name"].string {
                        
                        newDoctor.name = "\(firstName) \(lastName)"
                    }
                    if let npi = tempDocJSON["npi"].string {
                        newDoctor.npi = npi
                    }
                    if let gender = tempDocJSON["profile"]["gender"].string {
                        newDoctor.gender = gender
                    }
                    if let title = tempDocJSON["profile"]["title"].string {
                        newDoctor.title = title
                    }
                    if let description = tempDocJSON["profile"]["bio"].string {
                        newDoctor.bio = description
                    }
                    if let specialty = tempDocJSON["specialties"][0]["name"].string {
                        newDoctor.specialty = specialty
                    }
                    
                    // Address and geolocation
                    if let latitude = json["data"][i]["lat"].float {
                        newDoctor.latitude = latitude
                    }
                    if let longitude = json["data"][i]["lon"].float {
                        newDoctor.longitude = longitude
                    }
                    if let streetAddress = json["data"][i]["visit_address"]["city"].string,
                        let state = json["data"][i]["visit_address"]["state"].string,
                        let zip = json["data"][i]["visit_address"]["zip"].string {
                        
                        newDoctor.address = "\(streetAddress), \(state) \(zip)"
                    }
                    
                    // Distance and ImageURL - Information might be missing (use optional)
                    if let distance = json["data"][i]["distance"].int {
                        newDoctor.distance = distance
                    }
                    if let imageURL = json["data"][i]["doctors"][j]["profile"]["image_url"].string {
                        newDoctor.imageURL = imageURL
                    }
                    
                    // Asynchronous process to download the image's data from imageURL
                    getImageData(doctor: newDoctor)
                    
                    // Append new doctor to [Doctor]
                    doctorsArray.append(newDoctor)
                }
            }
        }
        
        // Reloads our tableview data once we have parsed the JSON object from our API and store data into our cells
        doctorsTableView.reloadData()
    }
    
    //------------------------------------------------------------------------------------
    //MARK - Get ImageData from ImageURL and set doctor object imageData property
    func getImageData(doctor: Doctor){
        
        // Set UIImageView image property from a url
        // Link - https://stackoverflow.com/questions/39813497/swift-3-display-image-from-url
        if let photoURL = URL(string: doctor.imageURL!) {
            
            // Information on sessions
            // Link - https://developer.apple.com/reference/foundation/urlsessionconfiguration
            let session = URLSession(configuration: .default)
            
            let downloadImage = session.dataTask(with: photoURL) {
                (data, response, error) in
                
                if error != nil {
                    print(error!)
                } else {
                    if let imageData = data {
                        doctor.imageData = imageData
                    }
                }
            }
            
            // Call resume on download task - Task objects are always created in a suspended state and
            // must be sent the -resume message before they will execute. **FROM DEFINITION :)**
            downloadImage.resume()
            
        }
    }
    
    //------------------------------------------------------------------------------------
    //MARK - Button actions
    @objc func searchButtonPressed(sender: UIButton!){
        // Dismiss keyboard
        searchTextField.resignFirstResponder()
        
        // Makes api call to betterdoctor API using new geolocation
        getDoctorsByZip(url: zipUrl, zipcode: searchTextField.text!)
    }
    
    @objc func saveButtonPressed(sender: UIBarButtonItem!){
        saveDoctorsToRealm(list: doctorsArray)
        
        // Pop to a specific viewcontroller, in our case "DashboardViewController"
        // https://stackoverflow.com/questions/30003814/how-can-i-pop-specific-view-controller-in-swift
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: DashboardViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        
    }
    
    //------------------------------------------------------------------------------------
    //MARK - Get latitude and longitude from zipcode API
    //Link - https://www.zipcodeapi.com/API
    //This function makes an API request to
    func getDoctorsByZip(url: String, zipcode: String){
        
        // Format: url + <api_key>/info.<format>/<zip_code>/<units>
        let fullURL = url + "/\(zipApiKey)/info.json/\(zipcode)/degrees"
        
        Alamofire.request(fullURL, method: .get).responseJSON {
            response in
            
            if response.result.isSuccess {
                print("Success!  Location information.")
                
                // Create JSON object and location variable to use in parameters for api call
                let zipJSON: JSON = JSON(response.result.value!)
                var location = String()
                
                // Parse our json object
                if let lat = zipJSON["lat"].float, let long = zipJSON["lng"].float {
                    let searchInMileRadius = "50"
                    location = "\(lat),\(long),\(searchInMileRadius)"
                }
                
                let params = ["location": location, "user_location": self.userLocation, "user_key": self.docApiKey]
                
                // Empty our doctorsArray to prepare to append new doctors
                self.getDoctorListing(url: self.docUrl, parameters: params)
                
            } else {
                print("Error \(String(describing: response.result.error))")
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
            userLocation = latitude + "," + longitude
            
            let params = ["location": location, "user_location": userLocation, "user_key": docApiKey]
            
            // Use our location latitude and longitude as parameter for our API call
            getDoctorListing(url: docUrl, parameters: params)
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
    
    //------------------------------------------------------------------------------------
    //MARK - UITextfield Delegate Methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    // Dismiss keyboard when user taps view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // Set max length of textfield to 5 characters (ZIPCODE limit)
    // https://stackoverflow.com/questions/31363216/set-the-maximum-character-length-of-a-uitextfield-in-swift
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 5
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    //------------------------------------------------------------------------------------
    //MARK - Realm
    func saveDoctorsToRealm(list: [Doctor]){
        for doctors in list {
            if doctors.selected {
                doctors.writeToRealm()
                print("\(doctors.name) saved to Realm.")
            }
        }
    }
    
    //------------------------------------------------------------------------------------

}

