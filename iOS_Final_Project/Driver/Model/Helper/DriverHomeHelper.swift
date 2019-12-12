//
//  DriverHomeHelper.swift
//  iOS_Final_Project
//
//  Created by Ege Melis Ayanoğlu on 10.12.2019.
//  Copyright © 2019 Bogo. All rights reserved.
//

import Foundation

class DriverHomeHelper {
    var selectedUsername: String?
    
    func getRatingImageArray(rating: Double) -> [String] {
        var ratingImageArray = [String]()
        ratingImageArray = ["star.fill", "star.fill",
            "star.lefthalf.fill", "star", "star"]
        return ratingImageArray
    }
}