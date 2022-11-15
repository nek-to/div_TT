//
//  Result.swift
//  Div
//
//  Created by Kolya Gribok on 10.11.22.
//
import Foundation

struct Result: Codable {
    let name: String
    let status: String
    let species: String
    let gender: String
    let origin: Origin
    let location: Location
    let image: String
    let episode: [String]
}
