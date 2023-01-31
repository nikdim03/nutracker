//
//  FactsData.swift
//  Nutracker
//
//  Created by Dmitriy on 4/7/22.
//

import Foundation

struct FactsData: Decodable {
    let fdcId: Int
    let description, dataType: String
    let foodCategory: FoodCategory?
    let wweiaFoodCategory: WweiaFoodCategory?
    let brandedFoodCategory, brandOwner, brandName, ingredients: String?
    let servingSize: Int?
    let servingSizeUnit: String?
    let foodNutrients: [FoodNutrient]
}

struct FoodCategory: Decodable {
    let description: String
}

struct FoodNutrient: Decodable {
    let nutrient: Nutrient
    let amount: Double?
}

struct Nutrient: Decodable {
    let id: Int
    let name, unitName: String
}

struct WweiaFoodCategory: Decodable {
    let wweiaFoodCategoryDescription: String
}
