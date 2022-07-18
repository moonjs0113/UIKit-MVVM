//
//  Episode.swift
//  NetworkModel
//
//  Created by Moon Jongseek on 2022/07/03.
//

import Foundation

struct Episode: Codable, Model {
    typealias FilterType = EpisodeFilter
    
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
    
    enum EpisodeFilter: FilterProtocol {
        case name(String)
        case episode(String)
        case page(Int)
        
        func getStringValue() -> String {
            switch self {
            case .name(let name):
                return "name=" + name
            case .episode(let episode):
                return "episode=" + episode
            case .page(let page):
                return "page=" + "\(page)"
            }
        }
    }
}
