//
//  WeatherManager.swift
//  WeatherForecastBySvist
//
//  Created by Artsem Svistunou on 01/03/2023.
//

import Foundation

protocol WeatherManagerDelegate {//создаем протокол, чтобы многократно использовать функцию didUpdateWeather в других классах
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    
    func didFailWithErrors(error: Error)
        
}

struct WeatherManager {//структура отвечающая за запрос в API
    
    var weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=ed9acd0d805ecf9e2e0964410d4c0293&units=metric"//создаем свойство с URL по умолчанию
    
    var delegate: WeatherManagerDelegate?
    
    func fetchURL(cityName: String) {//функция вставляет в URL по умолчанию название города
        
        let urlString = "\(weatherURL)&q=\(cityName)"//содержит модифицированый URL c названием города
        
        performRequest(with: urlString)//вызываем функцию performRequest с нашим urlString в качестве инпута
    }
    
    func performRequest (with urlString:String) {//функция делает нетворкинк с API
        
        if let url = URL(string: urlString) {//url с нашим параметром, if let тк класс URL optional
         
            let session = URLSession(configuration: .default)//сессия со стандартной конфигурацией
            
            let task = session.dataTask(with: url) { (data, respons, error) in // создаем таск для сессии вставляя наш URL и комплишен хэндлер (клоужер с нужными параметрами)
                
                if error != nil {//если выскакивает ошибка
                    delegate?.didFailWithErrors(error: error!)//вызываем функцию делигата
                    return//заканчиваем функцию
                }
                
                if let safeData = data {//создаем безопасные данные через optional binding
                    
                    if let weather = parseJSON(safeData){//вставляем данные в функцию parseJSON. if let тк выдает optional output
                    
                        delegate?.didUpdateWeather(self, weather: weather)//вставляем weather в функцию didUpdateWeather для делегата (в нашем случае ViewController)
                    }
                }
            }
                
            task.resume()//запускаем таск, resume тк dataTask всегда находиться в suspended состоянии
        }
    }
    
    func parseJSON (_ weatherData: Data) -> WeatherModel? {//фукция для парсинга из JSON. Возвращаем optional WeatherModel тк может выкинуть nil
        
        let decoder = JSONDecoder()//создаем декодер
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)//раскодированые данные. WeatherData как DataType. weatherData - наш параметр
            
            let id = decodedData.weather[0].id//создаем ID
            let temp = decodedData.main.temp//создаем температуру
            let name = decodedData.name//создаем название
            
            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp)//экземпляр класса WeatherModel с создаными константами как параметрами
             
            return weather//возвращаем weather
            
        } catch {
            delegate?.didFailWithErrors(error: error)//вызываем функцию делигата
            return nil
        }
    }
    
}
