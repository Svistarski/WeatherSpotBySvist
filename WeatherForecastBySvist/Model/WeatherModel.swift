//
//  WeatherModel.swift
//  WeatherForecastBySvist
//
//  Created by Artsem Svistunou on 04/03/2023.
//


import Foundation

struct WeatherModel {
    
    let conditionID: Int
    let cityName: String
    let temperature: Double
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var getConditionName: String {
        
        switch conditionID {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 700...781:
            return "cloud.fog"
        case 801...804:
            return "cloud"
        default:
            return "sun.max"
        }
        
    }
}
