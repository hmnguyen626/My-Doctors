//
//  DoctorInformation.swift
//  My Doctors
//
//  Created by Hieu Nguyen on 6/18/18.
//  Copyright © 2018 HMdev. All rights reserved.
//

import UIKit

class DoctorInformationCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var doctorImageView: UIImageView!
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var specialtyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    private func setupUI(){
        
        // Corner radius for container
        containerView.layoutIfNeeded()
        containerView.layer.cornerRadius = containerView.frame.size.height / 10
        containerView.layer.masksToBounds = true
        
        // Make ImageView Circular
        doctorImageView.layoutIfNeeded()
        doctorImageView.layer.cornerRadius = doctorImageView.frame.size.height / 2
        doctorImageView.layer.masksToBounds = true
        
    }
    
    
}
