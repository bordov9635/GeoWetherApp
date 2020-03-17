//
//  File.swift
//  GeoWeatherApp
//
//  Created by Siarhei Bardouski on 3/16/20.
//  Copyright © 2020 Siarhei Bardouski. All rights reserved.
//

import Foundation

//MARK: -CityForecast
struct CityForecast: Codable {
    let statename, distance, elevation, state: String
    let latt, city, prov: String
    let intersection: Intersection
    let geocode, geonumber, country, stnumber: String
    let staddress, inlatt: String
    let alt: Alt
    let timezone, region, postal, longt: String
    let remainingCredits, confidence, inlongt: String
    let cityForecastClass: Class
    let altgeocode: String

    enum CodingKeys: String, CodingKey {
        case statename, distance, elevation, state, latt, city, prov, intersection, geocode, geonumber, country, stnumber, staddress, inlatt, alt, timezone, region, postal, longt
        case remainingCredits = "remaining_credits"
        case confidence, inlongt
        case cityForecastClass = "class"
        case altgeocode
    }
}

// MARK: - Alt
struct Alt: Codable {
    let loc: [LOC]
}

// MARK: - LOC
struct LOC: Codable {
    let staddress, stnumber, postal, latt: String
    let city, prov, longt: String
    let locClass: Class
    let dist: String?

    enum CodingKeys: String, CodingKey {
        case staddress, stnumber, postal, latt, city, prov, longt
        case locClass = "class"
        case dist
    }
}

// MARK: - Class
struct Class: Codable {
}

// MARK: - Intersection
struct Intersection: Codable {
    let distance, xlat, xlon, street2: String
    let street1: String
}
