//
//  ViewController.swift
//  WeatherApp
//
//  Created by user on 06.10.2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var cityTableView: UITableView!
    var cityArray: [String] = []
    var tempArray: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityTableView.delegate = self
        cityTableView.dataSource = self
        
    }
    
    
    @IBAction func searchCityAction(_ sender: Any) {
        let alert = UIAlertController(title: "Введите город", message: "Напишите ваш город на английском", preferredStyle: .alert)
        alert.addTextField { textField in textField.placeholder = "Город"
        }
    let submit  = UIAlertAction(title: "Найти", style: .default) { action in self.getWeather(city: alert.textFields![0].text!)
        
    }
    let cancel = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
    alert.addAction(submit)
    alert.addAction(cancel)
    present(alert, animated: true, completion: nil)
}
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! CityTableViewCell
        
        cell.cityNameLabel.text = cityArray[indexPath.row]
        cell.cityTempLabel.text = tempArray[indexPath.row]
        
        return cell
     }
    
    func getWeather(city: String) {
    let url = "http://api.weatherapi.com/v1/current.json?key=49acf8b477c2468fb4660624212909&q=\(city)"
        AF.request(url, method: .get).validate().responseJSON { response in switch response.result {
        case .success(let value):
            let json = JSON(value)
            print("JSON: \(json)")
            self.cityArray.append(json["location"]["name"].stringValue)
            self.tempArray.append(json["current"]["temp_c"].stringValue)
            self.cityTableView.reloadData()
        case.failure(let error):
            print(error)
            }
        }
    }
    
}

