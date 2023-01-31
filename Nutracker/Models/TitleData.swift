//
//  TitleData.swift
//  Nutracker
//
//  Created by Dmitriy on 4/8/22.
//

import Foundation

struct TitleData: Decodable {
    let foods: [Title]
}

struct Title: Decodable {
    let fdcId: Int
    let description: String
    let dataType: String
    let foodCategory: String
    let brandName: String?
    let brandOwner: String?
}
