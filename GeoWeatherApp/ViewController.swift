//
//  ViewController.swift
//  GeoWeatherApp
//
//  Created by Siarhei Bardouski on 3/13/20.
//  Copyright © 2020 Siarhei Bardouski. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
   
    @IBOutlet weak var cityNowNameLabel: UILabel!
    @IBOutlet weak var weatherNowLabel: UILabel!
    @IBOutlet weak var weatherNowdescriptionLabel: UILabel!
    @IBOutlet weak var temperatureNowLabel: UILabel!
    @IBOutlet weak var weatherFiveDaysTableView: UITableView!
    @IBOutlet weak var hourlyWeatherCollectionView: UICollectionView!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var uvIndexLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var feelsLikeTemp: UILabel!
    
    
    let locationManager = CLLocationManager()
    var degreeSymbol = "º"
    var responseModel: WeatherForecast?
    var cityModel: CityForecast?
    var lat = 0.0
    var lon = 0.0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestLocationPermission()
        weatherFiveDaysTableView.delegate = self
        weatherFiveDaysTableView.dataSource = self
        self.weatherFiveDaysTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
   //MARK: -GetCurrentLocation
    func requestLocationPermission(){
        currentWeatherRequest()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]){
        if  let location = locations.first{
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        print(lat)
        print(lon)
            currentWeatherRequest()
            currentCityRequest()
           manager.stopUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        if CLLocationManager.locationServicesEnabled(){
            switch(CLLocationManager.authorizationStatus()){
            case .notDetermined, .restricted, .denied:
                showAlert("Пожалуйста разрешите определять вашу геопозицию")
            case .authorizedAlways, .authorizedWhenInUse:
                print("locationEnaabled")
            @unknown default:
                fatalError()
            }
        }else {
            showAlert("Включите сервсы геолокации на вашем устройстве")
            print("locationDisabled")
        }
        manager.stopUpdatingLocation()
    }
    
    class func isLocationEnabled() -> (status: Bool, message: String) {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                return (false,"No access")
            case .authorizedAlways, .authorizedWhenInUse:
                return(true,"Access")
            @unknown default:
                fatalError()
            }
        } else {
            return(false,"Turn On Location Services to Allow App to Determine Your Location")
        }
    }
    
   
   // MARK: -GettingWeatherFromAPI
    func currentCityRequest(){
        let session = URLSession.shared
        let cityURL = URL(string: "https://geocode.xyz/\(lat),\(lon)?json=1&auth=99935088070210889445x4982")!
    //    print(cityURL)
        let cityTask = session.dataTask(with: cityURL){ (data: Data?, respose: URLResponse?,error: Error?) in
            if let error = error{
                print("Error: \n \(error)")
            } else {
                if let jsonData = data{
                    
                    do {
                        let dataString = String(data: jsonData, encoding: String.Encoding.utf8)
                        print("\(dataString!)")
                        let decoder = JSONDecoder()
                        self.cityModel = try decoder.decode(CityForecast.self, from: jsonData)
                        
                        DispatchQueue.main.async {
                            self.cityNowNameLabel.text = self.cityModel?.city
                        }
                    } catch let error {
                        print("Error: \(error)")
                    }
                    
                } else {
                    print("Error didn't receive data")
                }
                
            }
            }
        cityTask.resume()
    }
    func currentWeatherRequest() {
        let session = URLSession.shared
        let weatherURL = URL(string: "https://api.darksky.net/forecast/1dcbd502506839effc15e04a5ecb687f/\(lat),\(lon)?lang=ru" )!
        let dataTask = session.dataTask(with: weatherURL) { (data: Data?,response: URLResponse?,error: Error?) in
            if let error = error {
                print("Error:\n\(error)")
                
            } else {
                if let jsonData = data {
                 
                    do {
                        let dataString = String(data: jsonData, encoding: String.Encoding.utf8)
              print("\(dataString!)")
                    let decoder = JSONDecoder()
                        self.responseModel = try decoder.decode(WeatherForecast.self, from: jsonData)
                        
                        DispatchQueue.main.async {
                            self.weatherNowLabel.text =  (self.responseModel?.currently.summary).map { $0.rawValue }
                            self.weatherNowdescriptionLabel.text = (self.responseModel?.currently.icon).map { $0.rawValue }
                            self.weatherFiveDaysTableView.reloadData()
                            self.hourlyWeatherCollectionView.reloadData()
                            self.reloadView()
                           
                        }
                        
                    } catch let error {
                      print("Error: \(error)")
                    }
                }else {
                print("Error: did not receive data")
                    
            }
            }
        }
        dataTask.resume()
        
    }
   
    public func reloadView(){
           
        self.cityNowNameLabel.text = self.cityModel?.city
        
        
           let temperatureNow = responseModel?.currently
           if let currentTemp = temperatureNow?.temperature {
            self.temperatureNowLabel.text = "\(String(describing: Int((currentTemp - 32) * 5 / 9)))\(self.degreeSymbol)"
           } else {
               self.temperatureNowLabel.text = "No data"
           }
        let dateList = responseModel?.daily
        if let sunriseDate = dateList?.data[0].sunriseTime{
            let dateFormatter = DateFormatter()
            let date = Date(timeIntervalSince1970: (TimeInterval(sunriseDate)))
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.setLocalizedDateFormatFromTemplate("HHmm")
            self.sunriseLabel.text = "Восход: \n \(dateFormatter.string(from: date))"
        } else {
            self.sunriseLabel.text = "No data"
        }
        if let sunsetDate = dateList?.data[0].sunsetTime{
            let dateFormatter = DateFormatter()
            let date = Date(timeIntervalSince1970: (TimeInterval(sunsetDate)))
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.setLocalizedDateFormatFromTemplate("HHmm")
            self.sunsetLabel.text = "Закат: \n \(dateFormatter.string(from: date))"

        } else {
            self.sunsetLabel.text = "No data"
        }
        
        let nowADay = responseModel?.currently
        if let nowHumidity = nowADay?.humidity {
            self.humidityLabel.text = "Влажность:\n \(nowHumidity)"
        } else { self.humidityLabel.text = "No data"
        }
        
        if let nowPressure = nowADay?.pressure{
            self.pressureLabel.text = "Давление:\n \(String(describing: nowPressure))"} else{
            self.pressureLabel.text = "No data"
        }
        if let nowUVIndex = nowADay?.uvIndex{
            self.uvIndexLabel.text = "УФ-индекс: \n\(String(describing: nowUVIndex))%"} else{
            self.uvIndexLabel.text = "No data"
        }
        if let nowVisibility = nowADay?.visibility{
            self.visibilityLabel.text = "Видимость:\n \(String(describing: nowVisibility))км"} else {
             self.visibilityLabel.text = "No data"
        }
        if let nowWind = nowADay?.windSpeed{
        self.windLabel.text = "Скорость ветра:\n\(String(describing:nowWind))км/ч"
        } else {
            self.windLabel.text = "No data"
        }
        if let nowTemperature = nowADay?.apparentTemperature{
            self.feelsLikeTemp.text = "Чувствуется как:\n \(Int((nowTemperature - 32) / 1.8))\(self.degreeSymbol)"
        }
    }
    
    //MARK: -HourlyWeather
     public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return responseModel?.hourly.data[0...24].count ?? 25
    }
     
    public  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HourlyWeatherViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyWeather", for: indexPath) as! HourlyWeatherViewCell
    
    let dateList = responseModel?.hourly
    if let nowDate = dateList?.data[indexPath.row].time{
        let dateFormatter = DateFormatter()
        let date = Date(timeIntervalSince1970: (TimeInterval(nowDate)))
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("HH")
        if indexPath.row == 0 {
            cell.hour.text = "Now"
        } else {
        cell.hour.text = dateFormatter.string(from: date)
        print(dateFormatter.string(from: date))
    }
        }
        let dailyWeather = responseModel?.hourly.data[indexPath.row]
        if let hourWeather = dailyWeather?.icon{
        cell.weather.text = String(describing: hourWeather)
            print(String(describing: dateList?.icon))} else {
            cell.weather.text = "No data"
        }
        if let hourlyTemp = dailyWeather?.temperature { cell.temp.text = "\(String(describing: Int((hourlyTemp - 32) * 5 / 9)))\(degreeSymbol)"} else {
            cell.temp.text = "No data"
        }
    print(String(describing: dateList?.data[indexPath.row].temperature))
        
        return cell
    }
    
   
      // MARK: -WeekWeatherTableViewCells
public    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return responseModel?.hourly.data[1...7].count ?? 7
        }
        
   public  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeekDay", for: indexPath) as? WeekDayWeatherViewCell else { return UITableViewCell() }
    let dateList = responseModel?.daily
    if let nowDate = dateList?.data[indexPath.row].time {
        let dateFormatter = DateFormatter()
            let date = Date(timeIntervalSince1970: (TimeInterval(nowDate)))
            dateFormatter.locale = Locale(identifier: "ru_UK")
            dateFormatter.setLocalizedDateFormatFromTemplate("EEEE")
        cell.dayLabel.text = "\(String(describing: dateFormatter.string(from: date + 86400)))"
    } else {
        cell.dayLabel.text = "No data"
    }
    
    let weatherList = responseModel?.daily.data[indexPath.row + 1]
    if let dailyWeather = weatherList?.summary {
        cell.weatherLabel.text = dailyWeather
        
    } else {
        cell.weatherLabel.text = "No data"
    }
    
    let listArray = responseModel?.daily.data[indexPath.row + 1]
    if let minTemperature = listArray?.temperatureLow {
        cell.minTempLabel.text = "\(String(describing: Int(( minTemperature - 32) / 1.8)))\(degreeSymbol)"
    } else {
        cell.minTempLabel.text = "No data"
    }
    if let maxTemperature = listArray?.temperatureHigh {
        cell.maxTempLabel.text = "\(String(describing: Int( (maxTemperature - 32) / 1.8)))\(degreeSymbol)"
    } else {
        cell.maxTempLabel.text = "No data"
    }
    
    return cell
    
    }
         
    
     private  func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
        }
    
    
    }
    func showAlert(_ message: String){
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
     //   self.present(alert, animated: true, completion: nil)
    }



