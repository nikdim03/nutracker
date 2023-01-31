//
//  NutritionManager.swift
//  Nutracker
//
//  Created by Dmitriy on 4/7/22.
//

import UIKit

protocol TitleManagerDelegate {
    func didUpdateTitles(_ titleManager: TitleManager, with titles: [TitleModel])
    func didFinishWithError(_ error: Error)
}

struct TitleManager {
    var delegate: TitleManagerDelegate?
    
    func fetchTitles(searchQuery: String, option: Int) {
        var urlString = "\(K.titlesBaseUrl)&query=\(searchQuery.replacingOccurrences(of: " ", with: "%20"))&api_key=\(K.apiKey)"
        
        switch option {
        case 1:
            urlString += "&dataType=Foundation"
        case 2:
            urlString += "&dataType=Foundation,Survey%20%28FNDDS%29,SR%20Legacy"
        default:
            break
        }
        
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let safeData = data {
                    if let titles = self.parseJson(safeData) {
                        self.delegate?.didUpdateTitles(self, with: titles)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJson(_ titleData: Data) -> [TitleModel]? {
        let decoder = JSONDecoder()
        do {
            var titlesArray = [TitleModel]()
            let decodedData = try decoder.decode(TitleData.self, from: titleData)
            for item in decodedData.foods {
                let decodedFoodId = item.fdcId
                let decodedName = item.description.capitalized
                let decodedType = item.dataType
                let decodedCategory = item.foodCategory
                let decodedBrand = (item.brandName == "" || item.brandName == nil) ? item.brandOwner : item.brandName
                
                let title = TitleModel(foodId: decodedFoodId, name: decodedName, type: decodedType, category: decodedCategory, brand: decodedBrand)
                titlesArray.append(title)
            }
            return titlesArray
        } catch {
            delegate?.didFinishWithError(error)
            return nil
        }
    }
}
