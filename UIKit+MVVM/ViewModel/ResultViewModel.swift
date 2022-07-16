//
//  ResultViewModel.swift
//  UIKit+MVVM
//
//  Created by Moon Jongseek on 2022/07/16.
//

import Foundation

final class ResultViewModel<M: Codable & Model> {
    var models: [M]
    
    init(models: [M]) {
        self.models = models
    }
    
    func requestInfo(id: Int, _ completeHandler: @escaping (M?, Error?) -> ()) {
        DispatchQueue.global().async {
            NetworkService.requestSingleObject(as: M.self, id: id) { object, error in
                guard let object = object else {
                    return completeHandler(nil, error)
                }
                completeHandler(object, error)
            }
        }
    }
}
