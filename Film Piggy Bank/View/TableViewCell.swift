//
//  TableViewCell.swift
//  Film Piggy Bank
//
//  Created by Serov Stas on 11/12/2018.
//  Copyright © 2018 Serov Stas. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var titelLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.movieImage.layer.cornerRadius = 6
        self.movieImage.clipsToBounds = true
        self.voteLabel.layer.cornerRadius = 4
        self.voteLabel.clipsToBounds = true
    }
    
    weak var viewModel: DetailViewModel! {
        didSet {
            imageURL = viewModel.imageURL
            titelLabel.text = viewModel.filmName
            descriptionLabel.text = viewModel.filmDescription
            favoriteImage.image = viewModel.favorite ? UIImage(named: "favorite") : nil
            voteLabel.text = viewModel.vote
        }
    }
    
    var imageURL: URL? {
        didSet {
            movieImage.image = nil
            
            if let img = viewModel.image {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.movieImage.image = img
            } else {
                
                if let url = imageURL {
                    activityIndicator.startAnimating()
                    activityIndicator.isHidden = false
                    Network.shared.downloadImage (url: url) { [weak self] (image) in
                        guard url == self?.imageURL else {return}
                        self?.viewModel.image = image
                        self?.activityIndicator.stopAnimating()
                        self?.activityIndicator.isHidden = true
                        self?.movieImage.image = image
                    }
                } else {
                    self.movieImage.image = UIImage(named: "no_photo")
                }
            }
        }
    }
    
}
