//
//  Doctor.swift
//  My Doctors
//
//  Created by Hieu Nguyen on 6/12/18.
//  Copyright © 2018 HMdev. All rights reserved.
//

import Foundation

class Doctor {
    var name: String = ""
    var gender: String = ""
    var title: String = ""
    var description: String = ""
    var clinic: String?
    var address: String = ""
    var specialty: String = ""
    var acceptingNewPatients : Bool?
    var languages: [String] = []
    
    // Api returns distance in miles
    var distance: Int = 0
    var latitude: Float = 0.0
    var longitude: Float = 0.0
    
    // Doctor might not have an imageURL
    var imageURL: String?
    var imageData: Data?
    
    init(){
        self.clinic = nil
        self.acceptingNewPatients = nil
        self.languages = []
    }
    
    convenience init(fName: String, lName: String, gender: String, title: String,
                     description: String, clinic: String, address: String, specialty: String, accept: Bool, lat: Float, long: Float){
        self.init()
        
        
        self.name = fName + " " + lName
        self.gender = gender
        self.title = title
        self.description = description
        self.clinic = clinic
        self.address = address
        self.acceptingNewPatients = accept
        self.specialty = specialty
        self.latitude = lat
        self.longitude = long
    }
    
}
