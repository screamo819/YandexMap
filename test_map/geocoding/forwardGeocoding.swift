//
//  forwardGeocoding.swift
//  test_map
//
//  Created by Evgeny on 21.08.2022.
//

import UIKit

struct SearchManager {
    
    var searchURL = "https://geocode-maps.yandex.ru/1.x/?format=json&apikey=\(yaMapAPIfoJSON)"
    
     func fetchLocation(locationName: String, completion: @escaping([SearchModule]) -> Void) {
        let urlString = "\(searchURL)&geocode=\(locationName)&lang=ru_RU"
        performRequest(urlString: urlString) {
            (searchModules : [SearchModule]) in
//            print("searchModules")
//            print(searchModules)
//                dump(searchModules)
            if !searchModules.isEmpty {
                completion (searchModules)
            }
        }
    }
    
    //Delegate
     func performRequest(urlString: String, complection: @escaping([SearchModule]) -> ()) {
        if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let search = parseJSON(safeData) {
                        complection(search)
                        //return search
                    }
                }
            }
            task.resume()
        }
    }
    
     func parseJSON(_ locationData: Data) -> [SearchModule]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(SearchData.self, from: locationData)
            //print(decodedData.response.GeoObjectCollection.featureMember)
            var searchModules = [SearchModule]()
            for featureMember in decodedData.response.GeoObjectCollection.featureMember {
                let point = featureMember.GeoObject.Point.pos
                let pointArray = point.components(separatedBy: " ")
                let latitude = pointArray[0]
                let longitude = pointArray[1]
                let searchModule = SearchModule(locationAdress: featureMember.GeoObject.name,
                                                locationDescription: featureMember.GeoObject.description,
                                                lat: latitude,
                                                lon: longitude)
                searchModules.append(searchModule)
            }
            return searchModules
        } catch {
            print(error)
            return nil
        }
    }
    
}
