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
        
        // Configure the view for the selected state
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
    
    
    
    
    
    
    
    
    
    
    
    
//    // Views
//    let doctorPhotoImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = true
//
//        //https://stackoverflow.com/questions/15499376/uiimageview-aspect-fit-and-center
//        imageView.contentMode = .scaleAspectFit
//
//        return imageView
//    }()
//
//    let doctorNameLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont(name: "Menlo-Regular", size: 20)
//
//        return label
//    }()

//    // Setup custom cell view
//    private func setupUI(){
//        // Doctor imageview
//        self.addSubview(doctorPhotoImageView)
//        doctorPhotoImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
//        doctorPhotoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
//        doctorPhotoImageView.heightAnchor.constraint(equalToConstant: 75).isActive = true
//        doctorPhotoImageView.widthAnchor.constraint(equalToConstant: 75).isActive = true
//
//        // Doctor name label
//        self.addSubview(doctorNameLabel)
//        doctorNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
//        doctorNameLabel.leadingAnchor.constraint(equalTo: doctorPhotoImageView.trailingAnchor, constant: 30).isActive = true
//        doctorNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 30).isActive = true
//        doctorNameLabel.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 130).isActive = true
//
//
//    }
    
}
