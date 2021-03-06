//
//  RNMService.swift
//  NetworkModel
//
//  Created by Moon Jongseek on 2022/07/01.
//

import Foundation

typealias NetworkClosure<D: Codable> = (D?, NetworkError?) -> Void

enum NetworkService {
    static let baseURL = "https://rickandmortyapi.com/api/"
    static let manager = NetworkActer(baseURL: baseURL)
}

extension NetworkService {
    enum ModelRoute: String, RouteProtocol {
        var stringValue: String {
            self.rawValue
        }
        
        var method: HTTPMethod {
            return .GET
        }
        
        case character
        case location
        case episode
        
        static func convertToString<M: Codable>(to model: M.Type) -> ModelRoute? {
            switch model {
            case is Character.Type:
                return .character
            case is Location.Type:
                return .location
            case is Episode.Type:
                return .episode
            default:
                return nil
            }
        }
    }
    
    static func requestTotalObject<M: Codable>(as model: M.Type, completeHandler: @escaping NetworkClosure<ModelList<M>>) {
        guard let route = ModelRoute.convertToString(to: model) else {
            completeHandler(nil, .invalidType)
            return
        }
        
        manager.sendRequest(route: route, decodeTo: ModelList<M>.self) { info, error in
            completeHandler(info, error)
        }
    }
    
    static func requestObject<M: Codable, F: FilterProtocol>(as model: M.Type, filterBy filter: [F] = [], completeHandler: @escaping NetworkClosure<ModelList<M>>) {
        guard let route = ModelRoute.convertToString(to: model) else {
            completeHandler(nil, .invalidType)
            return
        }
        
        manager.sendRequest(route: route, filterBy: filter, decodeTo: ModelList<M>.self) { info, error in
            completeHandler(info, error)
        }
    }
    
    // Single or Multile Object(s)
    static func requestSingleObject<M: Codable>(as model: M.Type, id: Int, completeHandler: @escaping NetworkClosure<M>) {
        guard let route = ModelRoute.convertToString(to: model) else {
            completeHandler(nil, .invalidType)
            return
        }
        
        manager.sendRequest(route: route, ids: [id], decodeTo: model.self) { result, error in
            completeHandler(result, error)
        }
    }
    
    static func requestSingleObjectToURL<M: Codable>(as model: M.Type, url: String?) async throws -> M {
        guard let url = URL(string: url ?? "") else {
            throw NetworkError.invalidURL
        }
        
        let data = try await manager.sendRequest(url: url)
        return try manager.jsonDecode(data: data, decodeTo: model.self)
    }
    
    static func requestMultipleObjects<M: Codable>(as model: M.Type, id: [Int], completeHandler: @escaping NetworkClosure<[M]>) {
        guard let route = ModelRoute.convertToString(to: model) else {
            completeHandler(nil, .invalidType)
            return
        }
        
        manager.sendRequest(route: route, ids: id, decodeTo: [M].self) { result, error in
            completeHandler(result, error)
        }
    }
    
    static func requestImageData(url: String) throws -> Data {
        guard let url = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let imageData = try manager.sendRequestImageData(url: url)
            return imageData
        } catch (let e as NetworkError) {
            throw e
        }
    }
    
    static func requestImageData(url: String) async throws -> Data {
        guard let url = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let imageData = try await manager.sendRequestImageData(url: url)
            return imageData
        } catch (let e as NetworkError) {
            throw e
        }
    }
}
