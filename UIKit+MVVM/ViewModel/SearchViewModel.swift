//
//  ViewModel.swift
//  NetworkModel
//
//  Created by Moon Jongseek on 2022/07/04.
//

import Foundation

final class SearchViewModel<M: Codable & Model> {
    var totalCount: Int = 0
    
    func isVaildateInputID(_ text: String) -> Bool {
        let pattern: String = "^[0-9, ]{1,10000}$"
        let regex = try? NSRegularExpression(pattern: pattern)
        if regex?.firstMatch(in: text,
                             options: [],
                             range: NSRange(location: 0,
                                            length: text.count)) == nil {
            return false
        }
        return true
    }
    
    func convertStringToIntArray(_ text: String) -> [Int] {
        return text.components(separatedBy: [","," "]).compactMap { string in
            return Int(string)
        }
    }
    
    func getResultViewModel(model: [M]) -> ResultViewModel<M> {
        return ResultViewModel(models: model)
    }
    
    // Request
    func requestTotalCount(_ completeHandler: @escaping (Int?, Error?) -> ()) {
        DispatchQueue.global().async {
            NetworkService.requestTotalObject(as: M.self) { info, error in
                completeHandler(info?.info.count, error)
            }
        }
    }
    
    func requestMultipleInfo(ids: [Int], _ completeHandler: @escaping ([M]?, Error?) -> ()) {
        DispatchQueue.global().async {
            if ids.count == 1 {
                if let id = ids.first {
                    NetworkService.requestSingleObject(as: M.self, id: id) { object, error in
                        guard let object = object else {
                            return completeHandler(nil, error)
                        }
                        let objects = [object]
                        completeHandler(objects, error)
                    }
                }
            } else {
                NetworkService.requestMultipleObjects(as: M.self, id: ids) { objects, error in
                    completeHandler(objects, error)
                }
            }
        }
    }
    
    func requestFilterInfo(filter: [M.FilterType]) {
        DispatchQueue.global().async {
            NetworkService.requestObject(as: M.self, filterBy: filter) { info, error in
                guard let info = info, error == nil else {
                    if let error = error {
                        debugPrint(error)
                    }
                    return
                }
                if let results = info.results {
                    print(results.count)
                }
            }
        }
    }
}
