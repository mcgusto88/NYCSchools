//
//  FeedItemListNavigationCoordinator.swift
//  NYCSchools
//
//  Created by Augustus Wilson on 2/21/23.
//  Copyright © 2021 Augustus Wilson. All rights reserved.
//

import UIKit

protocol NavigationCoordinator {
    func getInitialViewController() -> UINavigationController;
}

class FeedItemListNavigationCoordinator : NavigationCoordinator {
    
    private var feedItemDataLoader : FeedItemsDataLoader {
        let isRunningUITests = ProcessInfo.processInfo.arguments.contains("UITests")
        let urlSession = URLSession(configuration: .default)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if isRunningUITests {
            return LocalFeedItemsLoader(networkClient: URLSessionNetworkClient(urlSession:urlSession) ,jsonDecoder: decoder)
        } else {
            return RemoteFeedItemsLoader(networkClient: URLSessionNetworkClient(urlSession:urlSession) ,jsonDecoder: decoder)
        }
    }
        
    func getInitialViewController() -> UINavigationController {
        let navigationController = UINavigationController()
        let listViewController = FeedListViewController(dataLoader: feedItemDataLoader) { [weak self] feedItem in
            guard let self = self else {return}
            let detailsViewController = self.getDetailsViewController(feedItem: feedItem)
            navigationController.pushViewController(detailsViewController, animated: true)
        }
        listViewController.title = "Schools List"
        navigationController.viewControllers = [listViewController];
        navigationController.navigationBar.isTranslucent = false
        return navigationController;
    }
    
    private func getDetailsViewController(feedItem:FeedItem) -> FeedDetailsViewController {
        let detailsViewController = FeedDetailsViewController(dataLoader: feedItemDataLoader, feedItem: feedItem)
        return detailsViewController
    }

    deinit {
        print("deinit")
    }

}



