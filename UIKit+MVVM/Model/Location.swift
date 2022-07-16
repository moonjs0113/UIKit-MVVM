//
//  Location.swift
//  NetworkModel
//
//  Created by Moon Jongseek on 2022/07/03.
//

import Foundation

struct Location: Codable, Model {
    typealias FilterType = LocationFilter
    
    let id: Int
    let name: String
    let type: String?
    let dimension: String?
    let residents: [String]?
    let url: String
    let created: String?
    
    enum LocationFilter: FilterProtocol {
        case name(String)
        case type(String)
        case dimension(String)
        case page(Int)
        
        func getStringValue() -> String {
            switch self {
            case .name(let name):
                return "name=" + name
            case .type(let type):
                return "type=" + type
            case .dimension(let dimension):
                return "dimension=" + dimension
            case .page(let page):
                return "page=" + "\(page)"
            }
        }
    }
}
