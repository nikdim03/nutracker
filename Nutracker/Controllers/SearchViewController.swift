//
//  ViewController.swift
//  Nutracker
//
//  Created by Dmitriy on 4/7/22.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var foundationButton: UIButton!
    @IBOutlet weak var brandButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var titleManager = TitleManager()
    var titlesArray = [TitleModel]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextfield.layer.cornerRadius = 10
        tableView.layer.cornerRadius = 10
        
        foundationButton.changesSelectionAsPrimaryAction = true
        brandButton.changesSelectionAsPrimaryAction = true
        foundationButton.setImage(UIImage.init(systemName: "square"), for: .normal)
        foundationButton.setImage(UIImage.init(systemName: "checkmark.square"), for: .selected)
        brandButton.setImage(UIImage.init(systemName: "square"), for: .normal)
        brandButton.setImage(UIImage.init(systemName: "checkmark.square"), for: .selected)
        
        switch defaults.integer(forKey: "option") {
        case 1:
            foundationButton.isSelected = true
            brandButton.isSelected = false
        case 2:
            foundationButton.isSelected = false
            brandButton.isSelected = false
        default:
            foundationButton.isSelected = false
            brandButton.isSelected = true
        }
        titleManager.delegate = self
        titleManager.fetchTitles(searchQuery: "", option: self.defaults.integer(forKey: "option"))
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    @IBAction func foundationButtonPressed(_ sender: UIButton) {
        if foundationButton.isSelected {
            brandButton.isSelected = false
        }
        titleManager.fetchTitles(searchQuery: searchTextfield.text!, option: getOption())
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    @IBAction func brandButtonPressed(_ sender: UIButton) {
        if brandButton.isSelected {
            foundationButton.isSelected = false
        }
        titleManager.fetchTitles(searchQuery: searchTextfield.text!, option: getOption())
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    func getOption() -> Int {
        if foundationButton.isSelected {
            defaults.set(1, forKey: "option")
            return 1
        } else {
            if !brandButton.isSelected {
                defaults.set(2, forKey: "option")
                return 2
            } else {
                defaults.set(3, forKey: "option")
                return 3
            }
        }
    }
}

//MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.searchCellIdentifier, for: indexPath)
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        let titleString = NSMutableAttributedString(string: titlesArray[indexPath.row].name)
        switch titlesArray[indexPath.row].type {
        case K.Types.brandedType:
            let brandString = NSMutableAttributedString(string: "[\(titlesArray[indexPath.row].brand!)] ")
            titleString.insert(brandString, at: 0)
            titleString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 15), range: NSRange(location: 0, length: brandString.length))
            titleString.addAttribute(.foregroundColor, value: UIColor(named: K.Colors.brandedColor)!, range: NSRange(location: 0, length: titleString.length))
        case K.Types.foundationType:
            titleString.addAttribute(.foregroundColor, value: UIColor(named: K.Colors.foundationColor)!, range: NSRange(location: 0, length: titleString.length))
        case K.Types.surveyType:
            titleString.addAttribute(.foregroundColor, value: UIColor(named: K.Colors.surveyColor)!, range: NSRange(location: 0, length: titleString.length))
        case K.Types.SRLegacyType:
            titleString.addAttribute(.foregroundColor, value: UIColor(named: K.Colors.SRLegacyColor)!, range: NSRange(location: 0, length: titleString.length))
        default:
            print("Error matching type")
        }
        cell.textLabel?.attributedText = titleString
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.factsSegueIdentifier, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! FactsViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.id = titlesArray[indexPath.row].foodId
        }
    }
}

//MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextfield.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextfield.text != "" {
            return true
        } else {
            searchTextfield.placeholder = "Type something and then press return"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        titleManager.fetchTitles(searchQuery: textField.text!, option: defaults.integer(forKey: "option"))
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
}

//MARK: - TitleManagerDelegate
extension SearchViewController: TitleManagerDelegate {
    func didUpdateTitles(_ titleManager: TitleManager, with titles: [TitleModel]) {
        DispatchQueue.main.async {
            if self.foundationButton.isSelected {
                self.titlesArray = titles
            } else {
                var sortedArray = titles.filter({ $0.type == K.Types.foundationType })
                sortedArray += titles.filter({ $0.type != K.Types.foundationType })
                self.titlesArray = sortedArray
            }
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    func didFinishWithError(_ error: Error) {
        print(error)
    }
}
