//
//  FactsManager.swift
//  Nutracker
//
//  Created by Dmitriy on 4/9/22.
//

import UIKit

protocol FactsManagerDelegate {
    func didUpdateFacts(_ factsManager: FactsManager, with facts: FactsModel)
    func didFinishWithError(_ error: Error)
}

struct FactsManager {
    var delegate: FactsManagerDelegate?
    
    func fetchFacts(foodId: Int) {
        let urlString = "\(K.factsBaseUrl)\(foodId)?&api_key=\(K.apiKey)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let safeData = data {
                    if let facts = self.parseJson(safeData) {
                        self.delegate?.didUpdateFacts(self, with: facts)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJson(_ factsData: Data) -> FactsModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(FactsData.self, from: factsData)
            
            var netCarbs: Double? = nil
            
            let decodedFoodId = decodedData.fdcId
            let decodedName = decodedData.description.capitalized
            let decodedType = decodedData.dataType
            let decodedCategory = decodedData.foodCategory?.description
            let decodedWweiaCategory = decodedData.wweiaFoodCategory?.wweiaFoodCategoryDescription
            let decodedBrandedCategory = decodedData.brandedFoodCategory
            let decodedBrand = decodedData.brandName == "" ? decodedData.brandOwner?.capitalized : decodedData.brandName?.capitalized
            let decodedIngredients = decodedData.ingredients?.lowercased()
            var servingSizeString: String? {
                if decodedData.servingSize != nil {
                    return String(format: "%.0f", decodedData.servingSize!) + decodedData.servingSizeUnit!
                } else {
                    return nil
                }
            }
            var caloriesString: String? {
                if let decodedCalories = decodedData.foodNutrients.first(where: {$0.nutrient.id == 1008}) {
                    return String(format: "%.0f", decodedCalories.amount!) + decodedCalories.nutrient.unitName
                } else {
                    return nil
                }
            }
            var waterString: String? {
                if let decodedWater = decodedData.foodNutrients.first(where: {$0.nutrient.id == 1051}) {
                    return String(format: "%.1f", decodedWater.amount!) + decodedWater.nutrient.unitName
                } else {
                    return nil
                }
            }
            var carbsString: String? {
                if let decodedCarbs = decodedData.foodNutrients.first(where: {$0.nutrient.id == 1005}) {
                    netCarbs = decodedCarbs.amount!
                    return String(format: "%.1f", decodedCarbs.amount!) + decodedCarbs.nutrient.unitName
                } else {
                    return nil
                }
            }
            var fiberString: String? {
                if let decodedFiber = decodedData.foodNutrients.first(where: {$0.nutrient.id == 1079}) {
                    netCarbs! -= decodedFiber.amount!
                    return String(format: "%.1f", decodedFiber.amount!) + decodedFiber.nutrient.unitName
                } else {
                    return nil
                }
            }
            var netCarbsString: String? {
                if netCarbs != nil {
                    return String(format: "%.1f", netCarbs!) + "g"
                } else {
                    return nil
                }
            }
            var sugarsString: String? {
                if let decodedSugars = decodedData.foodNutrients.first(where: {$0.nutrient.id == 2000}) {
                    return String(format: "%.1f", decodedSugars.amount!) + decodedSugars.nutrient.unitName
                } else {
                    return nil
                }
            }
            var proteinString: String? {
                if let decodedProtein = decodedData.foodNutrients.first(where: {$0.nutrient.id == 1003}) {
                    return String(format: "%.1f", decodedProtein.amount!) + decodedProtein.nutrient.unitName
                } else {
                    return nil
                }
            }
            var fatString: String? {
                if let decodedFat = decodedData.foodNutrients.first(where: {$0.nutrient.id == 1004}) {
                    return String(format: "%.1f", decodedFat.amount!) + decodedFat.nutrient.unitName
                } else {
                    return nil
                }
            }
            
            let facts = FactsModel(foodId: decodedFoodId, name: decodedName, type: decodedType, category: decodedCategory, wweiaCategory: decodedWweiaCategory, brandedCategory: decodedBrandedCategory, brand: decodedBrand, ingredients: decodedIngredients, servingSize: servingSizeString, calories: caloriesString, water: waterString, carbs: carbsString, fiber: fiberString, netCarbs: netCarbsString, sugars: sugarsString, protein: proteinString, fat: fatString)
            return facts
        } catch {
            delegate?.didFinishWithError(error)
            return nil
        }
    }
}
