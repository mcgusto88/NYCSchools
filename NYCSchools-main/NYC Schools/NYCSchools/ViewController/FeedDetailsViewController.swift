//
//  FeedDetailsViewController.swift
//  NYCSchools
//
//  Created by Augustus Wilson on 2/21/23.
//  Copyright © 2021 Augustus Wilson. All rights reserved.
//

import UIKit

class FeedDetailsViewController: UIViewController {
    
    private let feedItem : FeedItem?
    private let dataLoader : FeedItemsDataLoader
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    private let schoolName : UILabel  = {
        let label  =  UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.accessibilityIdentifier = "School Name"
        label.font = UIFont.init(name: "AvenirNext-DemoBold", size: 16.0)
        label.numberOfLines = 0
        return label;
    }()
    
    private let satCriticalReadingAvgScore : UILabel  = {
        let label  =  UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.accessibilityIdentifier = "Reading Score"
        label.font = UIFont.init(name: "AvenirNext-Regular", size: 14.0)
        return label;
    }()
    

    private  let satMathAvgScore : UILabel  = {
        let label  =  UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.accessibilityIdentifier = "Math Score"
        label.font = UIFont.init(name: "AvenirNext-Regular", size: 14.0)
        return label;
    }()
    
    private let satWritingAvgScore : UILabel  = {
        let label  =  UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.accessibilityIdentifier = "Writing Score"
        label.font = UIFont.init(name: "AvenirNext-Regular", size: 14.0)
        return label;
    }()
    
    
    init(dataLoader:FeedItemsDataLoader,feedItem:FeedItem) {
        self.dataLoader = dataLoader
        self.feedItem = feedItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SAT Scores"
        self.edgesForExtendedLayout = []
        view.backgroundColor = .white
        setupUI();
        setupContraints()
        
        if let feedItem = feedItem {
            getFeedItemDetails(id:feedItem.dbn)
        }
    }
        
    private func setupUI() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false;
        activityIndicator.center = self.view.center
        activityIndicator.accessibilityLabel = "Loading Indicator"
        self.view.addSubview(activityIndicator)
        
        view.addSubview(schoolName)
        view.addSubview(satCriticalReadingAvgScore)
        view.addSubview(satMathAvgScore)
        view.addSubview(satWritingAvgScore)
    }
    
    
    private func getFeedItemDetails(id:String) {
        activityIndicator.startAnimating()
        dataLoader.getFeedItemDetails(id: id) { [weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            switch result {
            case .success(let details ):
                DispatchQueue.main.async {
                    self.refreshUI(details)
                }
                
            case .failure(let error):
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle:.alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                    self?.navigationController?.popViewController(animated: true)
                })
                
                alertController.addAction(alertAction)
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                }
                break
            }
        }
    }
    
    private func refreshUI(_ details:FeedItemDetails) {
        schoolName.text = details.schoolName
        satCriticalReadingAvgScore.text = "Reading : \(details.satCriticalReadingAvgScore)"
        satMathAvgScore.text = "Math : \(details.satMathAvgScore)"
        satWritingAvgScore.text = "Writing : \(details.satWritingAvgScore)"
    }

    private func setupContraints() {

        NSLayoutConstraint.activate([
            schoolName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 24),
            schoolName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            schoolName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            satCriticalReadingAvgScore.topAnchor.constraint(equalTo:schoolName.bottomAnchor,constant: 24),
            satCriticalReadingAvgScore.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            satCriticalReadingAvgScore.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])

        NSLayoutConstraint.activate([
            satMathAvgScore.topAnchor.constraint(equalTo:satCriticalReadingAvgScore.bottomAnchor,constant: 8),
            satMathAvgScore.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            satMathAvgScore.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])

        NSLayoutConstraint.activate([
            satWritingAvgScore.topAnchor.constraint(equalTo:satMathAvgScore.bottomAnchor,constant: 8),
            satWritingAvgScore.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            satWritingAvgScore.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }

}


