//
//  searchData.swift
//  test_map
//
//  Created by Evgeny on 21.08.2022.
//

import Foundation

struct SearchData: Decodable {
    let response: Response
}

struct Response: Codable {
    let GeoObjectCollection: geoObjectCollection
}

struct geoObjectCollection: Codable {
    let featureMember: [FeatureMember]
}

struct FeatureMember: Codable {
    let GeoObject: geoObject
}
struct geoObject: Codable {
    let name: String
    let description: String?
    let Point: point
}

struct point: Codable {
    let pos: String
}


