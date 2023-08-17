//
//  TouristListViewController.swift
//  WanderView
//
//  Created by Steve Hechio on 15/08/2023.
//

import UIKit

class TouristListViewController: UIViewController {
    
    // MARK: - Properties
    var tableView: TouristsTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    func setUpTableView() {
        tableView = TouristsTableView(frame: view.frame, controller: self)
        view.addSubview(tableView)
    }
    

}
