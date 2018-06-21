//
//  Doctor.swift
//  My Doctors
//
//  Created by Hieu Nguyen on 6/12/18.
//  Copyright © 2018 HMdev. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Doctor : Object {
    @objc dynamic var name: String = ""
    @objc dynamic var gender: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var bio: String = "No description provided."
    @objc dynamic var address: String = ""
    @objc dynamic var specialty: String = "No speciality listed."
    @objc dynamic var npi: String = ""
    @objc dynamic var acceptingNewPatients: Bool = true
    @objc dynamic var selected: Bool = false
    
    // Api returns distance in miles
    @objc dynamic var distance: Int = 0
    @objc dynamic var latitude: Float = 0.0
    @objc dynamic var longitude: Float = 0.0
    
    // Doctor might not have an imageURL
    @objc dynamic var imageURL: String?
    @objc dynamic var imageData: Data?
    
    // Primary key to avoid duplicates in our Realm DB
    override static func primaryKey() -> String {
        return "npi"
    }

    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: AnyObject, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        fatalError("init(value:schema:) has not been implemented")
    }
    
}

extension Doctor {
    // Save self to our Realm
    func writeToRealm() {
        do {
            try userRealm.write {
                // Add Doctor to realm list, and if primary key exists, then update
                userRealm.add(self, update: true)
            }
        } catch {
            print(error)
        }
    }
}




