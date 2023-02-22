//
//  FeedItemsDataLoader.swift
//  NYCSchools
//
//  Created by Augustus Wilson on 2/21/23.
//  Copyright © 2021 Augustus Wilson. All rights reserved.
//

import Foundation

protocol FeedItemsDataLoader {
    var networkClient : HTTPClient { get }
    var jsonDecoder : JSONDecoder { get }
    func getFeedItems(completion: ((Result<[FeedItem],CustomError>)->Void)?);
    func getFeedItemDetails(id:String, completion: ((Result<FeedItemDetails,CustomError>)->Void)?);

}

class RemoteFeedItemsLoader : FeedItemsDataLoader {

    private let feedItemsBaseUrl = "https://data.cityofnewyork.us/resource/s3k6-pzi2.json";
    private let schoolSATScoresBaseUrl = "https://data.cityofnewyork.us/resource/f9bf-2cp4.json";

    var networkClient: HTTPClient
    var jsonDecoder: JSONDecoder

    init(networkClient:HTTPClient,jsonDecoder:JSONDecoder) {
        self.networkClient = networkClient
        self.jsonDecoder = jsonDecoder
    }
    
    func getFeedItems(completion: ((Result<[FeedItem], CustomError>) -> Void)?) {
        let feedItemsUrl = feedItemsBaseUrl
        networkClient.get(url: feedItemsUrl, queryParameters: nil) {  [weak self] result in
            guard let self = self else {return}
            switch(result){
            case .success(let data):
                do {
                    let feedItems = try self.jsonDecoder.decode([FeedItem].self, from: data)
                    completion?(.success(feedItems))
                }
                catch (let error) {
                    print(error)
                    completion?(.failure(.decodeError))
                }
                break;
            case.failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    func getFeedItemDetails(id:String, completion: ((Result<FeedItemDetails, CustomError>) -> Void)?) {
        let feedItemsUrl = schoolSATScoresBaseUrl + "?dbn=\(id)"
        networkClient.get(url: feedItemsUrl, queryParameters: nil) {  [weak self] result in
            guard let self = self else {return}
            switch(result){
            case .success(let data):
                do {
                    if let details = try self.jsonDecoder.decode([FeedItemDetails].self, from: data).first {
                        completion?(.success(details))
                    } else {
                        completion?(.failure(.noData))
                    }
                }
                catch (let error) {
                    print(error)
                    completion?(.failure(.decodeError))
                }
                break;
            case.failure(let error):
                completion?(.failure(error))
            }
        }
    }
}

class LocalFeedItemsLoader : FeedItemsDataLoader {
    var networkClient: HTTPClient
    
    var jsonDecoder: JSONDecoder
    
    init(networkClient:HTTPClient,jsonDecoder:JSONDecoder) {
        self.networkClient = networkClient
        self.jsonDecoder = jsonDecoder
    }
    
    func getFeedItems(completion: ((Result<[FeedItem], CustomError>) -> Void)?) {
        if let path = Bundle.main.path(forResource: "SchoolsList_MockData", ofType: "json") {
            let url = URL(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: url)
                let feedItems = try self.jsonDecoder.decode([FeedItem].self, from: data)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    completion?(.success(feedItems))
                }
            }
            catch(let error) {
                print(error)
                completion?(.failure(.decodeError))
            }
        }
    }

    func getFeedItemDetails(id:String, completion: ((Result<FeedItemDetails, CustomError>) -> Void)?) {
        if let path = Bundle.main.path(forResource: "SATScores_MockData", ofType: "json") {
            let url = URL(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: url)
                if let details = try self.jsonDecoder.decode([FeedItemDetails].self, from: data).first {
                    completion?(.success(details))
                } else {
                    completion?(.failure(.noData))
                }
            }
            catch(let error) {
                print(error)
                completion?(.failure(.decodeError))
            }
        }
    }

}



