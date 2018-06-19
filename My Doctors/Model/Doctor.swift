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
    var acceptingNewPatients : Bool?
    var languages: [String] = []
    
    // Api returns distance in miles
    var distance: Float = 0
    // Doctor might not have an imageURL
    var imageURL: String?
    var imageData: Data?
    
    init(){
        self.clinic = nil
        self.acceptingNewPatients = nil
        self.languages = []
    }
    
    convenience init(fName: String, lName: String, gender: String, title: String,
         description: String, clinic: String, address: String, accept: Bool){
        self.init()
        
        
        self.name = fName + " " + lName
        self.gender = gender
        self.title = title
        self.description = description
        self.clinic = clinic
        self.address = address
        self.acceptingNewPatients = accept
    }
    
}
