//
//  WeatherData.swift
//  WeatherForecastBySvist
//
//  Created by Artsem Svistunou on 04/03/2023.
//

import Foundation

struct WeatherData: Codable {//структура куда будут возвращаться данные из API. Decodable тк может раскодировать себя из внешних источников другого формата (в нашем случае JSON)
    
    let name: String//свойство для название города
    let main: Main//свойство для температуры через структуру Main
    let weather: [Weather]//свойство для ID погоды. [] тк в JSON находиться в массиве)
}

struct Main: Codable {//структура сождержащая свойство температуры (main-temp как в JSON)
    let temp: Double//свойство температуры
}

struct Weather: Codable {//структура сождержащая ID погоды (weather-description как в JSON)
    let id: Int//свойство ID погоды
}
