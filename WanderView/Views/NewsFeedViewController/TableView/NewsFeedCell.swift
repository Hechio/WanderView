//
//  NewsFeedCell.swift
//  WanderView
//
//  Created by Steve Hechio on 16/08/2023.
//

import Foundation
import UIKit

class NewsFeedCell: UITableViewCell {
    
    //MARK: - Outlets for UI elements
    var userProfilePhotoImageView: UIImageView!
    var userNameLabel: UILabel!
    var locationLabel: UILabel!
    var dateTimeLabel: UILabel!
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    var infoStackView: UIStackView!
    var multimediaSlideView: UICollectionView!
    var pageControl: UIPageControl!
    
    var multimediaItems: [MediaItem] = []
    
    // MARK: - View Model
    
    var cellViewModel : NewsFeedCellViewModel? {
        didSet {
            if let profileImage = cellViewModel?.profilePicture {
                userProfilePhotoImageView.loadImage(from: profileImage)
                userProfilePhotoImageView.makeCircular()
            }
            userNameLabel.text = cellViewModel?.username
            locationLabel.text = cellViewModel?.location
            dateTimeLabel.text = cellViewModel?.getFormattedDate()
            titleLabel.text = cellViewModel?.title
            descriptionLabel.text = cellViewModel?.description
            if let multimedia = cellViewModel?.getMultimediaItems() {
                multimediaItems = multimedia
                multimediaSlideView.reloadData()
                pageControl.numberOfPages = multimedia.count
                pageControl.isHidden = multimedia.count <= 1
            }
            
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupCell()
        multimediaSlideView.delegate = self
        multimediaSlideView.dataSource = self
        multimediaSlideView.register(MultimediaCell.self,
                                     forCellWithReuseIdentifier: MultimediaCell.reuseIdentifier)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
      selectionStyle = .none
      backgroundColor = .clear
    }
    
    
    
    private func setupUI() {
        /**User Profile Photo**/
        userProfilePhotoImageView = getImageView()
        contentView.addSubview(userProfilePhotoImageView)
        userProfilePhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        userNameLabel = getLabel(fontSize: 16, weight: .bold)
        
        locationLabel = getLabel(fontSize: 12, weight: .regular)
        dateTimeLabel = getLabel(fontSize: 12, weight: .regular)
        
        let locationDateTimeStackView = getStackView(axis: .horizontal)
        locationDateTimeStackView.addArrangedSubview(locationLabel)
        locationDateTimeStackView.addArrangedSubview(dateTimeLabel)
        
        infoStackView = getStackView(axis: .vertical)
        contentView.addSubview(infoStackView)
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.addArrangedSubview(userNameLabel)
        infoStackView.addArrangedSubview(locationDateTimeStackView)
        
        titleLabel = getLabel(fontSize: 18, weight: .semibold)
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel = getLabel(fontSize: 12, weight: .regular)
        contentView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        
        pageControl = getPageControl()
        contentView.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        multimediaSlideView = getCollectionView()
        contentView.addSubview(multimediaSlideView)
        multimediaSlideView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userProfilePhotoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            userProfilePhotoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            userProfilePhotoImageView.widthAnchor.constraint(equalToConstant: 50),
            userProfilePhotoImageView.heightAnchor.constraint(equalToConstant: 50),
            
            infoStackView.leadingAnchor.constraint(equalTo: userProfilePhotoImageView.trailingAnchor, constant: 8),
            infoStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            
            multimediaSlideView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            multimediaSlideView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            multimediaSlideView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            multimediaSlideView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -8),
            
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
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
    
    func getCollectionView() -> UICollectionView {
        let collectionView = ViewHelper.createCollectionView()
        return collectionView
    }
    
    func getPageControl() -> UIPageControl {
        return ViewHelper.createPageControl()
    }
}

extension NewsFeedCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return multimediaItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MultimediaCell.reuseIdentifier, for: indexPath) as! MultimediaCell
        let mediaItem = multimediaItems[indexPath.item]
        cell.mediaItem = mediaItem
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let currentPage = Int(scrollView.contentOffset.x / pageWidth)
        pageControl.currentPage = currentPage
    }
}
