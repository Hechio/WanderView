//
//  TouristProfileViewController.swift
//  WanderView
//
//  Created by Steve Hechio on 15/08/2023.
//

import UIKit
import Combine


class TouristProfileViewController: UIViewController {
    private var cancellables: Set<AnyCancellable> = []
    var tourist: Tourist?
    var viewModel = TouristProfileViewModel()
    
    
    private let backButton: UIButton = {
        let button = UIButton()
        let backButtonImage = UIImage(systemName: "chevron.left")
        button.setImage(backButtonImage, for: .normal)
        button.tintColor = .blue
        return button
    }()
    
    private var titleLabel: UILabel!
    
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
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let createdAtLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "background")
        
        setupViews()
        setUpViewModel()
        populateViews(with: tourist)
    }
    func setUpViewModel(){
        viewModel.$tourist
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tourist in
                guard let self = self, let tourist = tourist else {
                    return
                }
                self.populateViews(with: tourist)
            }
            .store(in: &cancellables)
        
        fetchData()
    }
    
    private func fetchData() {
        
        guard let touristID = tourist?.id else {
            return
        }
        viewModel.fetchData(id: touristID)
    }
    
    private func setupViews() {
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        titleLabel = getTitleLabel()
        view.addSubview(titleLabel)
        
        let titleBackStackView = UIStackView(arrangedSubviews: [backButton, titleLabel])
        titleBackStackView.translatesAutoresizingMaskIntoConstraints = false
        titleBackStackView.distribution = .fillProportionally
        titleBackStackView.axis = .horizontal
        titleBackStackView.spacing = 8
        
        let stackView = UIStackView(arrangedSubviews: [profileImageView, nameLabel, emailLabel, locationLabel, createdAtLabel, UIView()])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(titleBackStackView)
        
        NSLayoutConstraint.activate([
            titleBackStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleBackStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleBackStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleBackStackView.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleBackStackView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
    }
    
    private func populateViews(with tourist: Tourist?) {
        if let tourist = tourist {
            nameLabel.text = tourist.touristName
            emailLabel.text = tourist.touristEmail
            locationLabel.text = tourist.touristLocation
            createdAtLabel.text = Date.formattedString(from: tourist.createdAt)
            
            if let profilePictureURL = tourist.touristProfilePicture, let imageURL = URL(string: profilePictureURL) {
                profileImageView.load(url: imageURL, placeholder: UIImage(named: "person_icon"))
            } else {
                profileImageView.image = UIImage(named: "person_icon")
            }
            
        }
    }
    
    @objc func backButtonTapped() {
        NotificationCenter.default.post(name: Notification.Name("BackButtonClicked"), object: nil)
    }
    
    func getTitleLabel() -> UILabel {
        let newLabel = ViewHelper.createLabel(
            with: UIColor(named: "AccentColor") ?? .systemBlue,
            text: NSLocalizedString("Tourist Profile", comment: ""),
            alignment: .center, font: UIFont.boldSystemFont(ofSize: 22))
        return newLabel
    }
    
}
