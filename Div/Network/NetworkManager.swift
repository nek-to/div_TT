//
//  NetworkManager.swift
//  Div
//
//  Created by Kolya Gribok on 10.11.22.
//

import Foundation

final class NetworkManager {
    // MARK: - Network
    static func getContentFromAPI(completion: @escaping (Root?) -> Void) {
        guard let url = URL(string: APIConstants.content.rawValue) else {
            print("Network error")
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if data != nil, error == nil {
                do {
                    let resData = try JSONDecoder().decode(Root.self, from: data!)
                    completion(resData)
                } catch {
                    completion(nil)
                    print("LOG: content - ",error)
                }
            } else {
                completion(nil)
            }
        }
        .resume()
    }
    
    static func getEpisodes(urlLink: String, completion: @escaping (Root?) -> Void) {
        guard let url = URL(string: urlLink) else {
            print("Network error")
            completion(nil)
            return
        }
        let queue = DispatchQueue(label: urlLink)
        queue.async {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if data != nil, error == nil {
                    do {
                        let episodeData = try JSONDecoder().decode(Root.self, from: data!)
                        completion(episodeData)
                    } catch {
                        completion(nil)
                        print("LOG: episodes - ",error)
                    }
                }
            }.resume()
        }
    }
}

// MARK: - Response struct
struct Root: Decodable {
    // character response
    let results: [Result]?
    // episodes response
    let name: String?
    let air_date: String?
    let episode: String?
    let url: String?
}
