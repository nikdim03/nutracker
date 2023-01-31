//
//  FactsViewController.swift
//  Nutracker
//
//  Created by Dmitriy on 4/9/22.
//

import UIKit

class FactsViewController: UIViewController {
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var brandValueLabel: UILabel!
    @IBOutlet weak var servingValueLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var servingLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var waterLabel: UILabel!
    @IBOutlet weak var totalCarbsLabel: UILabel!
    @IBOutlet weak var fiberLabel: UILabel!
    @IBOutlet weak var sugarsLabel: UILabel!
    @IBOutlet weak var netCarbsLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var ingredientsValueLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var factsManager = FactsManager()
    var id: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        factsManager.delegate = self
        factsManager.fetchFacts(foodId: self.id)
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
}

//MARK: - FactsManagerDelegate
extension FactsViewController: FactsManagerDelegate {
    func didUpdateFacts(_ factsManager: FactsManager, with facts: FactsModel) {
        DispatchQueue.main.async {
            print(facts)
//            var categoryImageName: String {
//                if facts.category != nil {
//                    return facts.category!
//                } else {
//                    if facts.wweiaCategory != nil {
//                        return facts.wweiaCategory!
//                    } else {
//                        return facts.brandedCategory!
//                    }
//                }
//            }
//            self.categoryImage.image = UIImage(named: categoryImageName)
            
            self.nameLabel.text = facts.name
            self.typeLabel.text = "(\(facts.type))"
            if facts.brand != nil {
                self.brandValueLabel.text = facts.brand!
            } else {
                self.brandValueLabel.isHidden = true
                self.brandLabel.isHidden = true
            }
            if facts.servingSize != nil {
                self.servingValueLabel.text = facts.servingSize!
            } else {
                self.servingValueLabel.isHidden = true
                self.servingLabel.isHidden = true
            }
            if facts.calories != nil {
                self.caloriesLabel.text = facts.calories!
            } else {
                self.caloriesLabel.text = "!"
            }
            if facts.water != nil {
                self.waterLabel.text = facts.water!
            } else {
                self.waterLabel.text = "!"
            }
            if facts.carbs != nil {
                self.totalCarbsLabel.text = facts.carbs!
            } else {
                self.totalCarbsLabel.text = "!"
            }
            if facts.fiber != nil {
                self.fiberLabel.text = facts.fiber!
            } else {
                self.fiberLabel.text = "!"
            }
            if facts.sugars != nil {
                self.sugarsLabel.text = facts.sugars!
            } else {
                self.sugarsLabel.text = "!"
            }
            if facts.netCarbs != nil {
                self.netCarbsLabel.text = facts.netCarbs!
            } else {
                self.netCarbsLabel.text = "!"
            }
            if facts.protein != nil {
                self.proteinLabel.text = facts.protein!
            } else {
                self.proteinLabel.text = "!"
            }
            if facts.fat != nil {
                self.fatLabel.text = facts.fat!
            } else {
                self.fatLabel.text = "!"
            }
            if facts.ingredients != nil {
                self.ingredientsValueLabel.text = facts.ingredients!
            } else {
                self.ingredientsValueLabel.isHidden = true
                self.ingredientsLabel.isHidden = true
            }
            
            self.activityIndicator.stopAnimating()
        }
    }
    
    func didFinishWithError(_ error: Error) {
        print(error)
    }
}
