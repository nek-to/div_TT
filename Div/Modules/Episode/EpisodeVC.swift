//
//  EpisodeVC.swift
//  Div
//
//  Created by Kolya Gribok on 10.11.22.
//

import UIKit

final class EpisodeVC: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet private weak var episodesTableView: UITableView!
    @IBOutlet private weak var episodeLabel: UILabel!
    
    // MARK: - Parameters
    private var episodes: [Episode] = []
    var episodesUrl: [String]?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        getEpisodesData()
        if episodesUrl!.count == 1 {
            episodeLabel.text = "Episode"
        } else {
            episodeLabel.text = "Episodes"
        }
        episodesTableView.register(UINib(nibName: "EpisodeTVCell", bundle: nil), forCellReuseIdentifier: "episodeCell")
    }
    
    // MARK: - Methods
    func getEpisodesData() {
        if let url = episodesUrl {
            url.forEach {
                NetworkManager.getEpisodes(urlLink: $0) { [weak self] root in
                    if let name = root?.name,
                       let airDate = root?.air_date,
                       let episode = root?.episode,
                       let link = root?.url {
                        self?.episodes.append(Episode(name: name,
                                                      airDate: airDate,
                                                      episode: episode,
                                                      link: link))
                    }
                    if self?.episodes.count == self?.episodesUrl?.count {
                        DispatchQueue.main.async {
                            self?.episodesTableView.reloadData()
                        }
                    }
                }
            }
        }
    }
}

    // MARK: - Extensions
    // MARK: UITableViewDelegate
extension EpisodeVC: UITableViewDelegate {
}

    // MARK: UITableViewDataSource
extension EpisodeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = episodesTableView.dequeueReusableCell(withIdentifier: "episodeCell") as! EpisodeTVCell
        cell.configuration(episode: episodes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        110
    }
}
