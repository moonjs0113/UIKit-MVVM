//
//  ResultViewModel.swift
//  UIKit+MVVM
//
//  Created by Moon Jongseek on 2022/07/16.
//

import Foundation
import UIKit

final class ResultViewModel<M: Codable & Model>: ViewModelProtocol {
    var models: [M]
    
    init(models: [M]) {
        self.models = models
    }
    
    func requestInfo(index: Int) async throws -> M {
        return try await NetworkService.requestSingleObjectToURL(as: M.self, url: self.models[index].url)
    }
    
    func getCharacterViewModel(character: Character) -> CharacterDetailViewModel {
        return CharacterDetailViewModel(character: character)
    }
    
    func getLocationViewModel(location: Location) -> LocationDetailViewModel {
        return LocationDetailViewModel(location: location)
    }
    
    func getEpisodeViewModel(episode: Episode) -> EpisodeDetailViewModel {
        return EpisodeDetailViewModel(episode: episode)
    }
}
