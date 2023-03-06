//
//  WeatherModel.swift
//  WeatherForecastBySvist
//
//  Created by Artsem Svistunou on 04/03/2023.
//

import Foundation

struct WeatherModel {//структура модели данных погоды. Тип данных, который мы будем использывать
    
    let conditionID: Int//свойство с ID (для рисунка)
    let cityName: String//свойство c названием города
    let temperature: Double//свойство c температурой
    
    var temperatureString: String {//computed property выдающее температуру в String с одной цифрой после зяпятой 
        return String(format: "%.1f", temperature)
    }
    
    var getConditionName: String {//computed property выдающее название рисунка на основе ID погоды
        
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
