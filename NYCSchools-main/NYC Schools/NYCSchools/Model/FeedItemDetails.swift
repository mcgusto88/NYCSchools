//
//  FeedItem.swift
//  NYCSchools
//
//  Created by Augustus Wilson on 2/21/23.
//  Copyright © 2021 Augustus Wilson. All rights reserved.
//

import Foundation

struct FeedItemDetails : Codable {
    let dbn: String
    let schoolName: String
    let numOfSatTestTakers: String
    let satCriticalReadingAvgScore: String
    let satMathAvgScore: String
    let satWritingAvgScore: String
}
