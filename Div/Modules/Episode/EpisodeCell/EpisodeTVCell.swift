//
//  EpisodeTVCell.swift
//  Div
//
//  Created by Kolya Gribok on 10.11.22.
//
import UIKit

final class EpisodeTVCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var airDateLabel: UILabel!
    @IBOutlet private weak var episodeLabel: UILabel!
    @IBOutlet private weak var linkButton: UIButton!
    
    // MARK: - Parameters
    var link: String?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        linkButton.layer.cornerRadius = linkButton.frame.height/2
    }
    
    // MARK: - Methods
    func configuration(episode: Episode) {
        nameLabel.text = episode.name
        airDateLabel.text = episode.airDate
        episodeLabel.text = episode.episode
        link = episode.link
    }

    // MARK: - Actions
    @IBAction private func openEpisodeLink(_ sender: UIButton) {
        if let link = link {
            UIApplication.shared.open(URL(string: link)!)
        }
    }
}
