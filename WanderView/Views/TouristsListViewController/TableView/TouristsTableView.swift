//
//  TouristsTableView.swift
//  WanderView
//
//  Created by Steve Hechio on 17/08/2023.
//

import Foundation
import UIKit

class TouristsTableView: UIView {
    
    // MARK: - Properties
    private var controller: UIViewController!
    private var profileViewController = TouristProfileViewController()
    
    var titleLable: UILabel!
    var tableView: UITableView!
    let cellID = "TouristsTableCell"
    
    internal var viewModel = TouristsListViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(controller!, name: Notification.Name("BackButtonClicked"), object: nil)
    }
    
    convenience init(frame: CGRect, controller: UIViewController) {
        self.init(frame: frame)
        self.controller = controller
        setupUI()
        viewModel.delegate = self
        viewModel.fetchData(page: 1)
        NotificationCenter.default.addObserver(self, selector: #selector(backButtonNotificationReceived), name: Notification.Name("BackButtonClicked"), object: nil)
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupUI(){
        backgroundColor = UIColor(named: "background")
        setupTableView()
        
    }
    
    func setUpProfile(indexPath: IndexPath){
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
        addSubview(profileViewController.self.view)
        
    }
    // MARK: - Setup Methods
    
    func setupTableView() {
        titleLable = getTitleLabel()
        addSubview(titleLable)
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            titleLable.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLable.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLable.heightAnchor.constraint(equalToConstant: 44)
        ])
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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLable.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
        ])
    }
    
    @objc private func backButtonNotificationReceived() {
        profileViewController = TouristProfileViewController()
        subviews.forEach { $0.removeFromSuperview() }
        setupUI()
    }
    
    func getTitleLabel() -> UILabel {
        let newLabel = ViewHelper.createLabel(
            with: UIColor(named: "AccentColor") ?? .systemBlue,
            text: NSLocalizedString("Tourists", comment: ""),
            alignment: .center, font: UIFont.boldSystemFont(ofSize: 22))
        return newLabel
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
