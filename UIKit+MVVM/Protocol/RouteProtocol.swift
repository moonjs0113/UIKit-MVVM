//
//  Route.swift
//  NetworkModel
//
//  Created by Moon Jongseek on 2022/07/01.
//

import Foundation

protocol RouteProtocol {
    var stringValue: String { get }
    var method: HTTPMethod { get }
}
