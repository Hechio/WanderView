//
//  ViewController.swift
//  WanderView
//
//  Created by Steve Hechio on 15/08/2023.
//

import UIKit

class NewsFeedViewController: UIViewController {
    
    // MARK: - Properties
    var tableView: NewsFeedTableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        
    }
    
    func setUpTableView() {
        tableView = NewsFeedTableView(frame: view.frame)
        view.addSubview(tableView)
    }


}
