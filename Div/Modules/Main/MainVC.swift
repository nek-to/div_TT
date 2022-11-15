//
//  MainVC.swift
//  Div
//
//  Created by Kolya Gribok on 10.11.22.
//
import UIKit

final class MainVC: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet private weak var charactersTableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Parameters
    private var results: [Result] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getContent()
        activityIndicator.startAnimating()
        charactersTableView.register(UINib(nibName: "CharacterTVCell", bundle: nil), forCellReuseIdentifier: "characterCell")
    }
    
    // MARK: - Methods
    private func getContent() {
        NetworkManager.getContentFromAPI { [weak self] root in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
            if let root = root {
                self?.results = root.results!
                DispatchQueue.main.async {
                    self?.charactersTableView.reloadData()
                }
            } else {
                self?.failAlert()
            }
        }
    }

private func failAlert() {
    let alert = UIAlertController(title: "Oops", message: "Something goes wrong", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Try again",
                                  style: .default,
                                  handler: { [weak self] _ in
        self?.getContent()
    }))
    self.present(alert, animated: true)
}

// MARK: - Actions
@objc private func restartLoading() {
}
}

// MARK: - Extensions
// MARK: UITableViewDelegate
extension MainVC: UITableViewDelegate {
}

// MARK: UITableViewDataSource
extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = charactersTableView.dequeueReusableCell(withIdentifier: "characterCell") as! CharacterTVCell
        cell.delegate = self
        cell.configuration(result: results[indexPath.row])
        cell.episode = results[indexPath.row].episode
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        152
    }
}

// MARK: CharacterCellDelegate
extension MainVC: CharacterCellDelegate {
    func getEpisodesWithCharacter(_ cell: CharacterTVCell) {
        let episodeVC = UIStoryboard(name: "Episode", bundle: nil).instantiateViewController(withIdentifier: "EpisodeVC") as! EpisodeVC
        episodeVC.episodesUrl = cell.episode
        present(episodeVC, animated: true)
    }
}
