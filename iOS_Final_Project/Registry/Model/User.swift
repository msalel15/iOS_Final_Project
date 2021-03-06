//
//  User.swift
//  iOS_Final_Project
//
//  Created by Ege Melis Ayanoğlu on 4.12.2019.
//  Copyright © 2019 Bogo. All rights reserved.
//

import Foundation
import UIKit

struct User {
    var profileImage: UIImage
    let isDriver: Bool
    let username: String
    let password: String
    let firstName: String
    let surname: String
    let email: String
    let phoneNumber: String
    var sex: String
    let age: Int
    // If user is a driver
    var carModel: String?
    var plaque: String?
    var rating: Double = 0
    var voteNumber: Int = 0
    let totalDistance: Int = 0
    var id:Int = 0
    init(profileImage: UIImage, isDriver: Bool,username: String, password: String, name: String,
         surname: String, email: String, phonenumber: String,
         age: Int, sex: String) {
        self.isDriver = isDriver
        self.username = username
        self.password = password
        self.firstName = name
        self.surname = surname
        self.email = email
        self.phoneNumber = phonenumber
        self.age = age
        self.sex = sex
        self.profileImage=profileImage
        
    }
    
    init(profileImage: UIImage,isDriver: Bool, username: String, password: String, name: String,
         surname: String, email: String, phonenumber: String,
         age: Int, sex: String, carModel: String, plaque: String) {
        self.isDriver = isDriver
        self.username = username
        self.password = password
        self.firstName = name
        self.surname = surname
        self.email = email
        self.phoneNumber = phonenumber
        self.age = age
        self.sex = sex
        self.carModel = carModel
        self.plaque = plaque
        self.profileImage=profileImage
    }
}
