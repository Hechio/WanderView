//
//  TouristsTableView.swift
//  WanderView
//
//  Created by Steve Hechio on 17/08/2023.
//

import Foundation
import UIKit

class TouristsTableView: UIView {
    
    /*
     To trigger the segue to CryptoDetailViewController
     when a cell is tapped on.
     */
    private var controller: UIViewController!
    
    // MARK: - Properties
    var tableView: UITableView!
    let cellID = "TouristsTableCell"
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.isHidden = true
        button.addTarget(TouristsTableView.self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Tourist Profile"
        label.textAlignment = .center
        return label
    }()
    
    internal var viewModel = TouristsListViewModel()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, controller: UIViewController) {
        self.init(frame: frame)
        self.controller = controller
        setupUI()
          viewModel.delegate = self
          viewModel.fetchData(page: 1)
    }

    
    required init?(coder: NSCoder) {
      super.init(coder: coder)
    }
    
    func setupUI(){
        backgroundColor = .white
        
        // Add title label
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        // Add back button
        addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        
        setupTableView()
        
    }
    
    func setUpProfile(indexPath: IndexPath){
        let profileViewController = TouristProfileViewController()
        let cellViewModel = viewModel.cellViewModels[indexPath.row]
        profileViewController.tourist = Tourist(
            id: cellViewModel.id,
            touristName: cellViewModel.username ?? "Unknown",
            touristEmail: cellViewModel.email ?? "",
            touristProfilePicture: cellViewModel.profilePicture,
            touristLocation: cellViewModel.touristLocation,
            createdAt: cellViewModel.createdAt
        )
        willRemoveSubview(tableView)
        backButton.isHidden = false
        addSubview(profileViewController.self.view)
        
    }
    // MARK: - Setup Methods
    
    func setupTableView() {
     ActivityIndicatorHelper.shared.show(in: self)
      
      tableView = UITableView(frame: frame, style: .plain)
      tableView.backgroundColor = .white
      
      tableView.delegate = self
      tableView.dataSource = self
      tableView.prefetchDataSource = self
      
      tableView.register(TouristsCell.self, forCellReuseIdentifier: cellID)
      
      tableView.bounces = false
      tableView.separatorStyle = .none
      tableView.showsVerticalScrollIndicator = false
      tableView.contentInset.top = 8
      tableView.contentInset.bottom = 20
      
        addSubview(tableView)
    }
    
    @objc private func backButtonTapped() {
        subviews.forEach { $0.removeFromSuperview() }
        setupUI()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension TouristsTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TouristsCell
        let cellViewModel = viewModel.getCellViewModel(at: indexPath)
        cell.cellViewModel = cellViewModel
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setUpProfile(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
    
    
}

// MARK: - TouristsListViewModelDelegate
extension TouristsTableView: TouristsListViewModelDelegate {
    func dataDidLoad() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            ActivityIndicatorHelper.shared.hide()
        }
    }
}

//MARK: - Implement UITableViewDataSourcePrefetching for paging
extension TouristsTableView: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if let lastIndexPath = indexPaths.last, lastIndexPath.row >= viewModel.cellViewModels.count - 1 {
            viewModel.fetchNextPage()
        }
    }
}
