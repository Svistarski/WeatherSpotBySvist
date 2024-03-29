//
//  WeatherManager.swift
//  WeatherSpotBySvist
//
//  Created by Artsem Svistunou on 01/03/2023.
//

import Foundation
import CoreLocation 

protocol WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    
    func didFailWithErrors(error: Error)
        
}

struct WeatherManager {
    
    var weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=ed9acd0d805ecf9e2e0964410d4c0293&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchURL(cityName: String) {
        
        let urlString = "\(weatherURL)&q=\(cityName)"
        
        performRequest(with: urlString)
    }
    
    func fetchURL(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        
        performRequest(with: urlString)
    }
    
    func performRequest (with urlString:String) {
        
        if let url = URL(string: urlString) {
         
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, respons, error) in
                
                if error != nil {
                    delegate?.didFailWithErrors(error: error!)
                    return
                }
                
                if let safeData = data {
                    
                    if let weather = parseJSON(safeData){
                    
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
                
            task.resume()
        }
    }
    
    func parseJSON (_ weatherData: Data) -> WeatherModel? {
        
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp)
             
            return weather
            
        } catch {
            delegate?.didFailWithErrors(error: error)
            return nil
        }
    }
    
}
