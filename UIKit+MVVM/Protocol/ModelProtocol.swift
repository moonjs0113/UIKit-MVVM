//
//  ModelProtocol.swift
//  NetworkModel
//
//  Created by Moon Jongseek on 2022/07/16.
//

import Foundation

protocol Model {
    associatedtype FilterType where FilterType: FilterProtocol
    var id: Int { get }
    var name: String { get }
}
