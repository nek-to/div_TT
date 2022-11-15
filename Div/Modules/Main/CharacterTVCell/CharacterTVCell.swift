//
//  CharacterTVCell.swift
//  Div
//
//  Created by Kolya Gribok on 10.11.22.
//

import UIKit

// MARK: - Protocol
protocol CharacterCellDelegate: AnyObject {
    func getEpisodesWithCharacter(_ cell: CharacterTVCell)
}

final class CharacterTVCell: UITableViewCell {
    // MARK: - @IBOutlet
    @IBOutlet private weak var characterImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var genderLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var statusBackgroundView: UIView!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var watchButton: UIButton!
    
    // MARK: - Parameters
    var episode: [String]?
    weak var delegate: CharacterCellDelegate?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        styling()
        self.watchButton.addTarget(self, action: #selector(seeEpisodes), for: .touchUpInside)
    }
    
    // MARK: - Methods
    func configuration(result: Result) {
        let queue = DispatchQueue(label: result.image)
        queue.async { [weak self] in
            if let image = try? Data(contentsOf: URL(string: result.image)!) {
                DispatchQueue.main.async {
                    if result.status.lowercased() == "dead" {
                        self?.characterImage.image = self?.grayscale(image: UIImage(data: image)!)
                    } else {
                        self?.characterImage.image = UIImage(data: image)
                    }
                }
            }
        }
        nameLabel.text = result.name
        genderLabel.text = "\(result.species), \(result.gender.lowercased())"
        statusLabel.text = result.status.uppercased()
        statusColorChanger(setStatus: result.status)
        locationLabel.text = result.location.name
    }
    
    private func styling() {
        characterImage.layer.cornerRadius = 40
        watchButton.layer.cornerRadius = watchButton.frame.height/2
        statusBackgroundView.layer.cornerRadius = statusBackgroundView.frame.height/2
    }
    
    private func statusColorChanger(setStatus: String) {
        switch setStatus {
        case "Dead":
            statusBackgroundView.backgroundColor = #colorLiteral(red: 0.9989554286, green: 0.9095879793, blue: 0.8794814348, alpha: 1)
            statusLabel.textColor = #colorLiteral(red: 0.9151733518, green: 0.2193000317, blue: 0.0004108922149, alpha: 1)
        case "unknown":
            statusBackgroundView.backgroundColor = #colorLiteral(red: 0.9341395497, green: 0.9341614842, blue: 0.9341497421, alpha: 1)
            statusLabel.textColor = #colorLiteral(red: 0.6286719441, green: 0.6286870837, blue: 0.6286789179, alpha: 1)
        default:
            statusBackgroundView.backgroundColor = #colorLiteral(red: 0.7809593081, green: 0.9890357852, blue: 0.7261964083, alpha: 1)
            statusLabel.textColor = #colorLiteral(red: 0.1903263032, green: 0.6249754429, blue: 0.08535888046, alpha: 1)
        }
    }
    
    private func grayscale(image: UIImage) -> UIImage? {
        let context = CIContext(options: nil)
        if let filter = CIFilter(name: "CIPhotoEffectTonal") {
            filter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
            if let output = filter.outputImage,
               let cgImage = context.createCGImage(output, from: output.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return image
    }
    
    // MARK: - Actions
    @objc private func seeEpisodes(_ sender: UIButton) {
        if episode != nil,
           delegate != nil {
            self.delegate?.getEpisodesWithCharacter(self)
        }
    }
}
