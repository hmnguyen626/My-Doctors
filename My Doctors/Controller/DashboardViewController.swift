//
//  DashboardNavigationController.swift
//  My Doctors
//
//  Created by Hieu Nguyen on 6/13/18.
//  Copyright © 2018 HMdev. All rights reserved.
//

import UIKit
import RealmSwift

class DashboardViewController: UIViewController {
    
    // Variables
    var cellHeights: [IndexPath : CGFloat] = [:]

    // Retrieves our array of Doctor objects from locally stored Realm
    var doctorsArray = userRealm.objects(Doctor.self)
    
    //MARK: - Declare views
    let doctorsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 200
        
        // Register our custom cell
        tableView.register(UINib(nibName: "DoctorInformationCell", bundle: nil), forCellReuseIdentifier: "customDoctorCell")
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegates
        doctorsTableView.delegate = self
        doctorsTableView.dataSource = self
        
        setupView()
    }
    
    // Retrieves array of Doctors and update tableview data when view appears
    override func viewDidAppear(_ animated: Bool) {
        doctorsArray = userRealm.objects(Doctor.self)
        doctorsTableView.reloadData()
    }
    
    //Mark: - Bar Button
    //Why lazy var is needed: Declare Completely Outside viewDidLoad()
    //https://stackoverflow.com/questions/40392617/swift-3-0-uibarbuttonitem-action-not-work
    lazy var searchBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(barButtonAction))
        barButtonItem.tag = 1
        
        return barButtonItem
    }()
    
    //MARK: - UISETUP
    private func setupView(){
        view.backgroundColor = UIColor(red: 153/255, green: 179/255, blue: 255/255, alpha: 1)
        self.navigationItem.rightBarButtonItem = searchBarButton
        
        // Tableview
        view.addSubview(doctorsTableView)
        doctorsTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        doctorsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        doctorsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        doctorsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        doctorsTableView.backgroundColor = UIColor(red: 153/255, green: 173/255, blue: 255/255, alpha: 0.5)
    }
    
    //MARK: - Barbutton Actions
    @objc func barButtonAction(sender: UIBarButtonItem){
        self.performSegue(withIdentifier: "goToDoctorsID", sender: self)
    }
    
    
}


extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Tableview Delegate Methods
    // Fix for dynamic cell heights that behaves as "jumpy" when scrolling
    // https://stackoverflow.com/questions/28244475/reloaddata-of-uitableview-with-dynamic-cell-heights-causes-jumpy-scrolling
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = cellHeights[indexPath] else { return 200.0 }
        return height
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
        
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            // Reference the doctor at index path
            let doctor = doctorsArray[indexPath.row]
            
            // Delete that doctor
            try! userRealm.write {
                userRealm.delete(doctor)
            }
            
            doctorsTableView.reloadData()
        }
    }
    
    //MARK: - Tableview Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctorsArray.count
    }
    
    // Populate our cells
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
        
        return cell
    }
    
    
}





