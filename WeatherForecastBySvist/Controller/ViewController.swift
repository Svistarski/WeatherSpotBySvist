//
//  ViewController.swift
//  WeatherForecastBySvist
//
//  Created by Artsem Svistunou on 19/02/2023.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()//создаем экземпляр класса WeatherManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self//делаем класс делегатом ТФ
        weatherManager.delegate = self//делаем класс делегатом WeatherManager
    }
}
//    MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {//расширение для протокола UITextFieldDelegate
    
    @IBAction func searchPressed(_ sender: UIButton) {//кнопка с лупой (поиск)
        
        searchTextField.endEditing(true)//вызываем метод, который прячет клавиатуру, а также триггерит функцию textFieldDidEndEditing
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {//функция нажатия на кнопку Return в ТФ
        
        searchTextField.endEditing(true)//вызываем метод, который прячет клавиатуру, а также триггерит функцию textFieldDidEndEditing
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {//функция, которая вызывается когда юзер пытается выйти с ТФ (тапает на поиск или Return). Спрашивает делегат стоит ли закончить редактирование
        
        if searchTextField.text != "" {//если юзер что-то написал
            return true//возвращаем true (заканчиваем редактирование)
        } else {
            searchTextField.placeholder = "Type something"//меняем плейсхолдер ТФ на "Type something"
            return false//возвращаем false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {//функция, которая вызывается когда юзер заканчивает редактирование ТФ
        
        if let city = searchTextField.text {//константа с названием города, который вписал юзер а ТВ. if let тк не хотим передавать optional в функцию fetchURL
            weatherManager.fetchURL(cityName: city)//передаем city в функцию fetchURL
        }
        
        searchTextField.text = ""//делаем ТФ пустым
    }
    
}
//    MARK: - WeatherManagerDelegate

extension ViewController: WeatherManagerDelegate {//расширение для протокола WeatherManagerDelegate
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {//функция обновления погоды
        DispatchQueue.main.async {//выводим процесс на главный поток
            self.temperatureLabel.text = weather.temperatureString//выводим температуру на экран
            self.conditionImageView.image = UIImage(systemName: weather.getConditionName)//выводим рисунок на экран
            self.cityLabel.text = weather.cityName//выводим на экран
        }
    }
    
    func didFailWithErrors(error: Error) {//функция, если выкинет ошибку
        print(error)
    }
}
