//
//  EpisodeDetailView.swift
//  UIKit+MVVM
//
//  Created by Moon Jongseek on 2022/07/18.
//

import UIKit

class EpisodeDetailView: UIView {
    private var viewModel: EpisodeDetailViewModel!
    
    // MARK: - Interface Builder
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var airDateLabel: UILabel!
    
    @IBOutlet weak var charactersButton: UIButton!
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Private Method
    private func commonInit() {
        Bundle.main.loadNibNamed("EpisodeDetailView", owner: self, options: .none)
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func fetchData() {
        idLabel.text = "ID: \(viewModel.episode.id)"
        episodeLabel.text = viewModel.episode.episode
        airDateLabel.text = viewModel.episode.air_date
    }
    
    func prepareView(viewModel: EpisodeDetailViewModel) {
        self.viewModel = viewModel
    }
    
    func getTitleText() -> String {
        return viewModel.episode.name
    }
    
    func goToCharacterList(completeHandler: @escaping NetworkClosure<[Character]>) {
        viewModel.requestCharacterList { characters, error in
            DispatchQueue.main.async {
                completeHandler(characters, error)
            }
        }
    }

}
