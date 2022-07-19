//
//  NetworkManager.swift
//  NetworkModel
//
//  Created by Moon Jongseek on 2022/07/01.
//

import Foundation

class NetworkActer {
    let baseURL: String
    private var session = URLSession(configuration: URLSessionConfiguration.default,
                                     delegate: nil,
                                     delegateQueue: nil)
    
    private let request: (URL, NetworkService.ModelRoute?) -> URLRequest =  { url, route in
        var request = URLRequest(url: url)
        request.httpMethod = route?.method.rawValue ?? HTTPMethod.GET.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    deinit {
        self.session.finishTasksAndInvalidate()
    }
}

extension NetworkActer {
    func multipleObjectRouteValue(ids: [Int]) -> String {
        var result = ""
        if ids.count > 0 {
            result += "/"
            for id in ids {
                result += "\(id),"
            }
            _ = result.popLast()
        }
        return result
    }
    
    func jsonDecode<D: Codable>(data: Data, decodeTo: D.Type) throws -> D {
        guard let model = try? JSONDecoder().decode(D.self, from: data) else {
            throw NetworkError.errorDecodingJson
        }
        return model
    }
    
    /// Request Single Models by URL
    func sendRequest(url: URL) async throws -> Data {
        let request = self.request(url, nil)
        guard let (data, _) = try? await self.session.data(for: request) else {
            throw NetworkError.nilResponse
        }
        return data
    }
    
    /// Request Single or Multiple Models
    func sendRequest<D: Codable>(route: NetworkService.ModelRoute, ids: [Int] = [], decodeTo: D.Type, completeHandler: @escaping NetworkClosure<D>) {
        var urlString = self.baseURL + route.stringValue
        urlString += multipleObjectRouteValue(ids: ids)

        guard let url = URL(string: urlString) else {
            return completeHandler(nil, NetworkError.invalidURL)
        }

        let request = self.request(url, route)

        self.session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completeHandler(nil, .nilResponse)
                return
            }
            guard let result = try? JSONDecoder().decode(D.self, from: data) else {
                completeHandler(nil, .errorDecodingJson)
                return
            }

            completeHandler(result, nil)
        }
        .resume()
    }
    
    /// Request Models by Filter
    func sendRequest<D: Codable, F: FilterProtocol>(route: NetworkService.ModelRoute, filterBy filters: [F] = [], decodeTo: D.Type, completeHandler: @escaping NetworkClosure<D>) {
        let urlString = self.baseURL + route.stringValue
        
        guard let url = URL(string: urlString) else {
            return completeHandler(nil, NetworkError.invalidURL)
        }
        
        var request = self.request(url, route)
        
        if !filters.isEmpty {
            guard let jsonData = try? JSONEncoder().encode(filters) else {
                completeHandler(nil, .errorEncodingJson)
                return
            }
            request.httpBody = jsonData
        }
        
        self.session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completeHandler(nil, .nilResponse)
                return
            }
            
            guard let result = try? JSONDecoder().decode(D.self, from: data) else {
                completeHandler(nil, .errorDecodingJson)
                return
            }
            
            completeHandler(result, nil)
        }
        .resume()
    }
    
    /// Request Character Image Data
    func sendRequestImageData(url: URL) throws -> Data {
        guard let data = try? Data(contentsOf: url) else {
            throw NetworkError.nilImageData
        }
        return data
    }
    
    /// Request Character Image Data With Async
    func sendRequestImageData(url: URL) async throws -> Data {
        do {
            let (data, _) = try await self.session.data(from: url)
            return data
        } catch {
            throw NetworkError.nilImageData
        }
    }
}
