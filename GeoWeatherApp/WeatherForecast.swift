//
//  WeatherForecast.swift
//  GeoWeatherApp
//
//  Created by Siarhei Bardouski on 3/13/20.
//  Copyright © 2020 Siarhei Bardouski. All rights reserved.
//


import UIKit

import Foundation

// MARK: - WeatherForecast
struct WeatherForecast: Codable {
    let latitude, longitude: Double
    let timezone: String
    let currently: Currently
    let hourly: Hourly
    let daily: Daily
    let flags: Flags
    let offset: Int
}

// MARK: - Currently
struct Currently: Codable {
    let time: Int
    let summary: Summary
    let icon: Icon
    let precipIntensity, precipProbability: Double
    let precipType: Icon?
    let temperature, apparentTemperature, dewPoint, humidity: Double
    let pressure, windSpeed, windGust: Double
    let windBearing: Int
    let cloudCover: Double
    let uvIndex: Int
    let visibility, ozone: Double
}

enum Icon: String, Codable {
    case clearNight = "clear-night"
    case cloudy = "cloudy"
    case fog = "fog"
    case partlyCloudyDay = "partly-cloudy-day"
    case partlyCloudyNight = "partly-cloudy-night"
    case rain = "rain"
    case clearDay = "clear-day"
    case snow = "snow"
}

enum Summary: String, Codable {
    case влажно = "Влажно"
    case влажноИНебольшаяОблачность = "Влажно и Небольшая Облачность"
    case влажноИОблачно = "Влажно и Облачно"
    case влажноИСильнаяОблачность = "Влажно и Сильная Облачность"
    case влажноИТуман = "Влажно и Туман"
    case возможенНебольшойДождьИВлажно = "Возможен Небольшой Дождь и Влажно"
    case облачно = "Облачно"
    case ясно = "Ясно"
    case небольшаяОблачность = "Небольшая Облачность"
    case возможенНезначительныйДождь = "Возможен Незначительный Дождь"
    case сильнаяОблачность = "Сильная Облачность"
    case туман = "Туман"
    case незначительныйДождь = "Незначительный Дождь"
}

// MARK: - Daily
struct Daily: Codable {
    let summary: String
    let icon: Icon
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let time: Int
    let summary: String
    let icon: Icon
    let sunriseTime, sunsetTime: Int
    let moonPhase, precipIntensity, precipIntensityMax: Double
    let precipIntensityMaxTime: Int
    let precipProbability: Double
    let precipType: Icon
    let temperatureHigh: Double
    let temperatureHighTime: Int
    let temperatureLow: Double
    let temperatureLowTime: Int
    let apparentTemperatureHigh: Double
    let apparentTemperatureHighTime: Int
    let apparentTemperatureLow: Double
    let apparentTemperatureLowTime: Int
    let dewPoint, humidity, pressure, windSpeed: Double
    let windGust: Double
    let windGustTime, windBearing: Int
    let cloudCover: Double
    let uvIndex, uvIndexTime: Int
    let visibility, ozone, temperatureMin: Double
    let temperatureMinTime: Int
    let temperatureMax: Double
    let temperatureMaxTime: Int
    let apparentTemperatureMin: Double
    let apparentTemperatureMinTime: Int
    let apparentTemperatureMax: Double
    let apparentTemperatureMaxTime: Int
}

// MARK: - Flags
struct Flags: Codable {
    let sources: [String]
    let nearestStation: Double
    let units: String

    enum CodingKeys: String, CodingKey {
        case sources
        case nearestStation = "nearest-station"
        case units
    }
}

// MARK: - Hourly
struct Hourly: Codable {
    let summary: String
    let icon: Icon
    let data: [Currently]
}

// MARK: - Minutely
struct Minutely: Codable {
    let summary: String
    let icon: Icon
    let data: [MinutelyDatum]
}

// MARK: - MinutelyDatum
struct MinutelyDatum: Codable {
    let time: Int
    let precipIntensity: Double
    let precipIntensityError: Double?
    let precipProbability: Double
    let precipType: Icon?
}
