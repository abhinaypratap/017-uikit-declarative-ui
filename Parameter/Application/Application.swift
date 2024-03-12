//
//  Application.swift
//  Parameter
//
//  Created by Abhinay Pratap on 12/03/24.
//

import Foundation

struct Application: Decodable {
    let screens: [Screen]
}

struct Screen: Decodable {
    let id: String
    let title: String
    let type: String
    let rows: [Row]
}

struct Row: Decodable {
    let title: String
}
