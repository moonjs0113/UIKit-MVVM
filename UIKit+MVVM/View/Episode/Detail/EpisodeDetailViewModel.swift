//
//  EpisodeDetailViewModel.swift
//  UIKit+MVVM
//
//  Created by Moon Jongseek on 2022/07/18.
//

import Foundation

final class EpisodeDetailViewModel {
    var episode: Episode
    
    required init(episode: Episode) {
        self.episode = episode
    }
    
    func requestCharacterList(_ completeHandler: @escaping NetworkClosure<[Character]>) {
        let ids = getCharacterIDList()
        
        DispatchQueue.global().async {
            if ids.count == 1 {
                if let id = ids.first {
                    NetworkService.requestSingleObject(as: Character.self, id: id) { character, error in
                        guard let character = character else {
                            return completeHandler(nil, error)
                        }
                        let characters = [character]
                        completeHandler(characters, error)
                    }
                }
            } else {
                NetworkService.requestMultipleObjects(as: Character.self, id: ids) { characters, error in
                    guard let characters = characters else {
                        return completeHandler(nil, error)
                    }
                    completeHandler(characters, error)
                }
            }
        }
    }
    
    func getCharacterIDList() -> [Int] {
        return episode.characters.compactMap {
            $0.components(separatedBy: "/").last
        }
        .compactMap {
            Int($0)
        }
    }
}
