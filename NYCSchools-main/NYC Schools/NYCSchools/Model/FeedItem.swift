//
//  FeedItem.swift
//  NYCSchools
//
//  Created by Augustus Wilson on 2/21/23.
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
