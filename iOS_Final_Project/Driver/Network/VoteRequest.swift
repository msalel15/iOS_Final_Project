//
//  VoteRequest.swift
//  iOS_Final_Project
//
//  Created by Ege Melis Ayanoğlu on 16.12.2019.
//  Copyright © 2019 Bogo. All rights reserved.
//

import Foundation

struct VoteRequest: Codable {
    let tripId: Int
    let point: Int
    let isDriver: Bool
}
