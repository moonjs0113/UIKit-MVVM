//
//  CharacterDetailViewModel.swift
//  UIKit+MVVM
//
//  Created by Moon Jongseek on 2022/07/17.
//

import Foundation

final class CharacterDetailViewModel {
    var character: Character
    var imageData: Data?
    var error: NetworkError?
    
    required init(character: Character) {
        self.character = character
    }
    
    func requestImageData() throws {
        self.imageData = try NetworkService.requestImageData(url: character.image)
    }
    
    func requestLocationData(url: String) async throws -> Location {
        return try await NetworkService.requestSingleObjectToURL(as: Location.self, url: url)
    }
    
    func requestEpisodeList(_ completeHandler: @escaping NetworkClosure<[Episode]>) {
        let ids = getEpisodeIDList()
        
        DispatchQueue.global().async {
            if ids.count == 1 {
                if let id = ids.first {
                    NetworkService.requestSingleObject(as: Episode.self, id: id) { episode, error in
                        guard let episode = episode else {
                            return completeHandler(nil, error)
                        }
                        let episodes = [episode]
                        completeHandler(episodes, error)
                    }
                }
            } else {
                NetworkService.requestMultipleObjects(as: Episode.self, id: ids) { episodes, error in
                    guard let episodes = episodes else {
                        return completeHandler(nil, error)
                    }
                    completeHandler(episodes, error)
                }
            }
        }
    }
    
    func getEpisodeIDList() -> [Int] {
        return character.episode.compactMap {
            $0.components(separatedBy: "/").last
        }
        .compactMap {
            Int($0)
        }
    }
    
    func clearError() {
        error = nil
    }
}
