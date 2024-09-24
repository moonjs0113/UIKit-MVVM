# Rick & Morty Dictionary

[![Swift Version][swift-image]](https://swift.org/)
[![Xcode Version][Xcode-image]](https://developer.apple.com/kr/xcode/)
[![Platform][Platform-image]](https://developer.apple.com/kr/ios/)

[swift-image]:https://img.shields.io/badge/Swift-5.9-orange?style=flat
[Xcode-image]: https://img.shields.io/badge/Xcode-15.2-blue?style=flat
[Platform-image]: https://img.shields.io/badge/iOS-16.0+-blue?style=flat

# Description
UIKit과 MVVM 패턴을 사용해보는 프로젝트입니다.

레포지토리를 변경하였습니다. -> [RickAndMorty App](https://github.com/moonjs0113/RickAndMorty.git)
Open API Server [Rick And Morty API](https://rickandmortyapi.com/)

# 1. Project Structure
``` shell
Xcode Project
├── App/
│   ├── Info.plist
│   ├── Assets.xcassets
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
├── Extension/
│   ├── UIActivityIndicatorView+Extension.swift
│   ├── UIViewController+Extension.swift
│   └── UIWindow+Extension.swift
├── Model/
│   ├── Character.swift
│   ├── Episode.swift
│   ├── Info.swift
│   ├── Location.swift
│   └── ResponseModel.swift
├── NetworkModule/
│   ├── HTTPMethod.swift
│   ├── NetworkError.swift
│   ├── NetworkManager.swift
│   └── NetworkService.swift
├── Protocol/
│   ├── FilterProtocol.swift
│   ├── ModelProtocol.swift
│   ├── RouteProtocol.swift
│   └── ViewModelProtocol.swift
├── Storyboard/
│   ├── LaunchScreen.storyboard
│   └── Main.storyboard
├── View/
│   ├── Character/
│   │   ├── Detail/
│   │   │   ├── CharacterDetailView.xib
│   │   │   ├── CharacterDetailView.swift
│   │   │   ├── CharacterDetailViewModel.swift
│   │   │   └── CharacterDetailViewController.swift
│   │   └── Search/
│   │       └── CharacterSearchViewController.swift
│   ├── Episode/
│   │   ├── Detail/
│   │   │   ├── EpisodeDetailView.xib
│   │   │   ├── EpisodeDetailView.swift
│   │   │   ├── EpisodeDetailViewModel.swift
│   │   │   └── EpisodeDetailViewController.swift
│   │   └── Search/
│   │       └── EpisodeSearchViewController.swift
│   ├── Location/
│   │   ├── Detail/
│   │   │   ├── LocationDetailView.xib
│   │   │   ├── LocationDetailView.swift
│   │   │   ├── LocationDetailViewModel.swift
│   │   │   └── LocationDetailViewController.swift
│   │   └── Search/
│   │       └── LocationSearchViewController.swift
│   └── Result/
│       └── ResultViewController.swift
└── ViewModel/
    ├── ResultViewModel.swift
    └── SearchViewModel.swift
```
