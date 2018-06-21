//
//  DashboardNavigationController.swift
//  My Doctors
//
//  Created by Hieu Nguyen on 6/13/18.
//  Copyright © 2018 HMdev. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    //--------------------------------------------------------------------------------------------
    //MARK - Declare views
    let topContainer: UIView = {
        let view = UIView()
        
        
        return view
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupView()
        
        
    }
    
    // Why lazy var is needed: Declare Completely Outside viewDidLoad()
    // https://stackoverflow.com/questions/40392617/swift-3-0-uibarbuttonitem-action-not-work
    lazy var searchBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(barButtonAction))
        barButtonItem.tag = 1
        
        return barButtonItem
    }()

    
    //--------------------------------------------------------------------------------------------
    //MARK - UISETUP
    private func setupView(){
        view.backgroundColor = UIColor(red: 153/255, green: 179/255, blue: 255/255, alpha: 1)
        
        self.navigationItem.rightBarButtonItem = searchBarButton
        
    }
    
    //--------------------------------------------------------------------------------------------
    //MARK - Actions
    @objc func barButtonAction(sender: UIBarButtonItem){
        if sender.tag == 1 {
            
            // Testing - Perform segue
            // Suggested:  Use protocol/delegate to send data backwards
            self.performSegue(withIdentifier: "goToDoctorsID", sender: self)
            
        } else {
            print("Testing")
        }
        
        
    }
    
}
