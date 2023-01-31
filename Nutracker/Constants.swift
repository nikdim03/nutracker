//
//  Constants.swift
//  Nutracker
//
//  Created by Dmitriy on 4/8/22.
//

import Foundation

struct K {
    static let titlesBaseUrl = "https://api.nal.usda.gov/fdc/v1/foods/search?pageSize=200"
    static let factsBaseUrl = "https://api.nal.usda.gov/fdc/v1/food/"
    static let apiKey = "p1teESJm9kZae79xp04vt3GRYycflx9FhtE3M8Ro"
    static let searchCellIdentifier = "SearchCell"
    static let factsSegueIdentifier = "goToFacts"
    
    struct Types {
        static let brandedType = "Branded"
        static let foundationType = "Foundation"
        static let surveyType = "Survey (FNDDS)"
        static let SRLegacyType = "SR Legacy"

    }
    struct Colors {
        static let brandedColor = "BrandedColor"
        static let foundationColor = "FoundationColor"
        static let surveyColor = "SurveyColor"
        static let SRLegacyColor = "SRLegacyColor"
    }
}
