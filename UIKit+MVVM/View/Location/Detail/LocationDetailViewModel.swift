//
//  LocationDetailViewModel.swift
//  UIKit+MVVM
//
//  Created by Moon Jongseek on 2022/07/18.
//

import Foundation

final class LocationDetailViewModel {
    var location: Location
    
    required init(location: Location) {
        self.location = location
    }
}
