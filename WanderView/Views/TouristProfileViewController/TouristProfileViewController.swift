//
//  TouristProfileViewController.swift
//  WanderView
//
//  Created by Steve Hechio on 15/08/2023.
//

import UIKit

class TouristProfileViewController: UIViewController {

    var tourist: Tourist?
       
       private let profileImageView: UIImageView = {
           let imageView = UIImageView()
           imageView.translatesAutoresizingMaskIntoConstraints = false
           imageView.contentMode = .scaleAspectFit
           imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
           imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
           return imageView
       }()
       
       private let nameLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
       
       private let emailLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
       
       private let locationLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
       
       private let createdAtLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           view.backgroundColor = .white
           
           setupViews()
           populateViews()
       }
       
       private func setupViews() {
           let stackView = UIStackView(arrangedSubviews: [profileImageView, nameLabel, emailLabel, locationLabel, createdAtLabel])
           stackView.translatesAutoresizingMaskIntoConstraints = false
           stackView.axis = .vertical
           stackView.spacing = 10
           view.addSubview(stackView)
           
           NSLayoutConstraint.activate([
               stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
           ])
       }
       
       private func populateViews() {
           if let tourist = tourist {
               nameLabel.text = tourist.touristName
               emailLabel.text = tourist.touristEmail
               locationLabel.text = tourist.touristLocation
               createdAtLabel.text = tourist.createdAt
               
               if let profilePictureURL = tourist.touristProfilePicture, let imageURL = URL(string: profilePictureURL) {
                   profileImageView.load(url: imageURL, placeholder: UIImage(named: "person_icon"))
               } else {
                   profileImageView.image = UIImage(named: "person_icon")
               }
           }
       }

}
