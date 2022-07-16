//
//  ViewModel.swift
//  NetworkModel
//
//  Created by Moon Jongseek on 2022/07/04.
//

import Foundation

final class ViewModel<M: Codable & Model> {
    var model: M?
    var id: Int = 0
    var totalCount: Int = 0
    
    func requestTotalCount(_ completeHandler: @escaping (Int?, Error?) -> ()) {
        DispatchQueue.global().async {
            NetworkService.requestTotalObject(as: M.self) { info, error in
                completeHandler(info?.info.count, error)
            }
        }
    }
    
    func requestInfo() {
        DispatchQueue.global().async { [weak self] in
            NetworkService.requestSingleObject(as: M.self, id: self?.id ?? 0) { model, error in
                guard let model = model, error == nil else {
                    if let error = error {
                        debugPrint(error)
                    }
                    return
                }
                DispatchQueue.main.async {
                    self?.model = model
                }
            }
        }
    }
    
    func requestMultipleInfo(ids: [Int]) {
        DispatchQueue.global().async {
            NetworkService.requestMultipleObjects(as: M.self, id: ids) { model, error in
                guard let model = model, error == nil else {
                    if let error = error {
                        debugPrint(error)
                    }
                    return
                }
                print(model)
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
