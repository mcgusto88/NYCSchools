//
//  FeedItem.swift
//  NYCSchools
//
//  Created by Augustus Wilson on 7/15/21.
//  Copyright © 2021 Augustus Wilson. All rights reserved.
//

import Foundation

struct FeedItem : Codable {
    let dbn: String
    let schoolName: String
    let location: String
    let phoneNumber: String
    let website: String
}
