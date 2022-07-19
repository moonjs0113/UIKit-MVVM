//
//  NetworkError.swift
//  NetworkModel
//
//  Created by Moon Jongseek on 2022/07/01.
//

import Foundation

enum NetworkError: Error {
    case invalidType
    case invalidURL
    case nilResponse
    case nilImageData
    case managerIsNil
    case errorEncodingJson
    case errorDecodingJson
}
