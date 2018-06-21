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
    var description: String = "No description provided."
    var address: String = ""
    var specialty: String = "No speciality listed."
    var acceptingNewPatients : Bool
    
    // Api returns distance in miles
    var distance: Int = 0
    var latitude: Float = 0.0
    var longitude: Float = 0.0
    
    // Doctor might not have an imageURL
    var imageURL: String?
    var imageData: Data?
    
    init(){
        self.imageURL = nil
        self.imageData = nil
        self.acceptingNewPatients = true
    }
    
}
