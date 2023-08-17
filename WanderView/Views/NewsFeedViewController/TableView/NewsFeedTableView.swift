//
//  NewsFeedTableView.swift
//  WanderView
//
//  Created by Steve Hechio on 17/08/2023.
//

import Foundation
import UIKit

class NewsFeedTableView: UIView {
    
    // MARK: - Properties
    var tableView: UITableView!
    let cellID = "NewsFeedTableCell"
    
    
    // MARK: - View Model
    
    internal var viewModel = NewsFeedViewModel()
    
    // MARK: - Init methods
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      setupTableView()
        viewModel.delegate = self // Set the delegate to self
        viewModel.fetchData(page: 1) // Start loading data
    }
    
    required init?(coder: NSCoder) {
      super.init(coder: coder)
    }
    
    
    // MARK: - Setup Methods
    
    func setupTableView() {
        ActivityIndicatorHelper.shared.show(in: self)
      
      tableView = UITableView(frame: frame, style: .plain)
      tableView.backgroundColor = .white
      
      tableView.delegate = self
      tableView.dataSource = self
      tableView.prefetchDataSource = self
      
      tableView.register(NewsFeedCell.self, forCellReuseIdentifier: cellID)
      
      tableView.bounces = false
      tableView.separatorStyle = .none
      tableView.showsVerticalScrollIndicator = false
      tableView.contentInset.top = 8
      tableView.contentInset.bottom = 20
      
        addSubview(tableView)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension NewsFeedTableView : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! NewsFeedCell
        let cellViewModel = viewModel.getCellViewModel(at: indexPath)
        cell.cellViewModel = cellViewModel
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
        
}

//MARK: - Implement UITableViewDataSourcePrefetching for paging
extension NewsFeedTableView: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if let lastIndexPath = indexPaths.last, lastIndexPath.row >= viewModel.cellViewModels.count - 1 {
            viewModel.fetchNextPage()
        }
    }
}

// MARK: - NewsFeedViewModelDelegate
extension NewsFeedTableView: NewsFeedViewModelDelegate {
    func dataDidLoad() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            ActivityIndicatorHelper.shared.hide()
        }
    }
}
