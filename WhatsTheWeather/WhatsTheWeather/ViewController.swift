//
//  ViewController.swift
//  WhatsTheWeather
//
//  Created by Антон Данилов on 17.05.2020.
//  Copyright © 2020 Антон Данилов. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        let key = "61fc680cb989727b2f8c5a82ab572c6f"
        var city = searchBar.text!.replacingOccurrences(of: " ", with: "%20")
        var urlString = "http://api.weatherstack.com/current?access_key=\(key)&query=\(city)"
        var url = URL(string: urlString)
        
        var locationName: String?
        var tempetature: Double?
        var errorHasOccured: Bool = false
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do {
                let json = try  JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                
                if let _ = json["error"] {
                    errorHasOccured = true
                }
                
                if let location = json["location"] {
                    locationName = location["name"] as? String
                }
                
                if let current = json["current"] {
                    tempetature = current["temperature"] as? Double
                }
                
                DispatchQueue.main.async {
                    if errorHasOccured {
                        self.cityLabel.text = "Error has occured"
                        self.temperatureLabel.isHidden = true
                        
                    } else {
                        self.cityLabel.text = locationName
                        self.temperatureLabel.text = "\(tempetature!)"
                        
                        self.temperatureLabel.isHidden = false
                    }
                }
                
            } catch let jsonError {
                print(jsonError)
            }
        }
        task.resume()
    }
}
