//
//  DetailViewController.swift
//  Film Piggy Bank
//
//  Created by Serov Stas on 11/12/2018.
//  Copyright © 2018 Serov Stas. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var favoriteBtn: UIBarButtonItem!
    
    weak var viewModel: DetailViewModel!
    
    //MARK: - Actions
    @IBAction func addToFavorite(_ sender: UIBarButtonItem) {
        viewModel.favorite = !viewModel.favorite
        showFavoriteBtn()
        viewModel.saveFavoriteToDataBase()
    }
    
    private func showFavoriteBtn() {
        favoriteBtn.image = viewModel.favorite ? UIImage(named: "favorite") : UIImage(named: "not_favorite")
    }
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showFavoriteBtn()
        viewModel.saveViewModelToDataBase()
        self.image.image = viewModel.image != nil ? viewModel.image! : UIImage(named: "no_photo")
        nameLabel.text = viewModel.filmName
        infoLabel.text = viewModel.info
        descriptionLabel.text = viewModel.filmDescription
    }
    
}
