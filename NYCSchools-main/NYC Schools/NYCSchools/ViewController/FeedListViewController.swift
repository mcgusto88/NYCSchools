//
//  FeedListViewController.swift
//  NYCSchools
//
//  Created by Augustus Wilson on 2/21/23.
//  Copyright © 2021 Augustus Wilson. All rights reserved.
//

import UIKit

typealias FeedItemSelectionHandler = ((_ feedItem:FeedItem)->Void)

class FeedListViewController: UITableViewController {
    
    private var feedItems : [FeedItem] = []
    private let dataLoader : FeedItemsDataLoader
    private var selectionHandler: FeedItemSelectionHandler
    private let reuseIdentifier = "feedItemCell"
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    
    init(dataLoader:FeedItemsDataLoader,selectionHandler:@escaping FeedItemSelectionHandler) {
        self.dataLoader = dataLoader
        self.selectionHandler = selectionHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        setupUI()
        getFeedItems()
    }
    
    override func viewWillLayoutSubviews() {
        activityIndicator.center = self.view.center
    }
    
    private func setupUI() {
        self.tableView.accessibilityLabel = "FeedItems List"
        self.tableView.register(FeedItemTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
      
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false;
        activityIndicator.center = self.view.center
        activityIndicator.accessibilityLabel = "FeedItem Loading Indicator"
        self.view.addSubview(activityIndicator)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func getFeedItems() {
        activityIndicator.startAnimating()
        dataLoader.getFeedItems() { [weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            switch result {
            case .success(let feedItems ):
                self.feedItems = feedItems
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle:.alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(alertAction)
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                }
                break
            }
        }
    }
}

//DataSource
extension FeedListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        feedItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell : FeedItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? FeedItemTableViewCell else {
            return UITableViewCell()
        }
        let feedItem = feedItems[indexPath.row]
        cell.refreshWith(feedItem: feedItem)
        return cell
    }
        
}

//Delegate
extension FeedListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feedItem = feedItems[indexPath.row]
        selectionHandler(feedItem)
    }
}

