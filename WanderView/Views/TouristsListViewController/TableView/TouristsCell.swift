//
//  TouristsCell.swift
//  WanderView
//
//  Created by Steve Hechio on 17/08/2023.
//

import Foundation
import UIKit

class TouristsCell: UITableViewCell {
    
    //MARK: - Outlets for UI elements
    var userProfilePhotoImageView: UIImageView!
    var userNameLabel: UILabel!
    var emailLabel: UILabel!
    var infoStackView: UIStackView!
    
    // MARK: - View Model
    var cellViewModel: TouristCellViewModel? {
        didSet {
            if let profileImage = cellViewModel?.profilePicture {
                userProfilePhotoImageView.loadImage(from: profileImage)
                userProfilePhotoImageView.makeCircular()
            }else {
                userProfilePhotoImageView.image = UIImage(named: "person_icon")
            }
            
            userNameLabel.text = cellViewModel?.username
            emailLabel.text = cellViewModel?.email
        }
    }
    
    // MARK: - Init Methods
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      
      setupCell()
      addViews()
    }
    
    required init?(coder: NSCoder) {
      super.init(coder: coder)
    }
    
    func setupCell() {
      selectionStyle = .none
      backgroundColor = .clear
    }
    
    func addViews() {
        userProfilePhotoImageView = getImageView()
        contentView.addSubview(userProfilePhotoImageView)
        userProfilePhotoImageView.translatesAutoresizingMaskIntoConstraints = false

        userNameLabel = getLabel(fontSize: 16, weight: .bold)
        
        emailLabel = getLabel(fontSize: 12, weight: .regular)
        
        infoStackView = getStackView(axis: .vertical)
        contentView.addSubview(infoStackView)
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.addArrangedSubview(userNameLabel)
        infoStackView.addArrangedSubview(emailLabel)
        
        NSLayoutConstraint.activate([
            userProfilePhotoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            userProfilePhotoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            userProfilePhotoImageView.widthAnchor.constraint(equalToConstant: 68),
            userProfilePhotoImageView.heightAnchor.constraint(equalToConstant: 68),
            
            infoStackView.leadingAnchor.constraint(equalTo: userProfilePhotoImageView.trailingAnchor, constant: 8),
            infoStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            infoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        
        ])
    }
    
    
    // MARK: - UI Helper Methods
    
    func getLabel(fontSize: CGFloat, weight: UIFont.Weight) -> UILabel {
        let newLabel = ViewHelper.createLabel(
            with: .darkGray, text: "", alignment: .left,
            font: UIFont.systemFont(ofSize: fontSize, weight: weight))
        return newLabel
    }
    
    func getStackView(axis: NSLayoutConstraint.Axis) -> UIStackView {
        let stackView = ViewHelper.createStackView(
            axis, distribution: .fill)
        stackView.spacing = 8
        stackView.alignment = .leading
        return stackView
    }
    
    func getImageView() -> UIImageView {
        let imageView = ViewHelper.createImageView()
        return imageView
    }
}
