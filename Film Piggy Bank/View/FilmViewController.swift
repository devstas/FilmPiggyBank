//
//  FilmViewController.swift
//  Film Piggy Bank
//
//  Created by Serov Stas on 11/12/2018.
//  Copyright © 2018 Serov Stas. All rights reserved.
//

import UIKit

class FilmViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var favoriteBtn: UIBarButtonItem!
    
    var viewModel: MovieViewModel! {
        didSet {
            uploadFilm(searchText: "")
        }
    }
    var isShowFavorite = false
    
    //MARK: - Action
    @IBAction func favoriteBtn(_ sender: Any) {
        isShowFavorite = !isShowFavorite
        favoriteBtn.title = isShowFavorite ? "Всё" : "Избранное"
        searchBar.text = ""
        viewModel.showMoviesFromDB(onlyFavorite: isShowFavorite) {
            self.tableView.reloadData()
            // scroll to first cell
            let indexPat = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPat, at: .top, animated: false)
        }
    }
    
    private func uploadFilm(searchText: String) {
        viewModel.updateMovies(searchText: searchText) { [weak self] in
            self?.tableView.reloadData()
            self?.title = (self?.viewModel.networkStatus)! ? "online" : "offline"
        }
    }
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.hideKeyboardWhenTapOut()
        self.viewModel = MovieViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isShowFavorite {
            viewModel.showMoviesFromDB(onlyFavorite: true) { }
        }
        tableView.reloadData()
    }
    
    //MARK: - Navigate
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? DetailViewController else { return }
        guard let selectedCell = tableView.indexPathForSelectedRow?.row else { return }
        detailVC.viewModel = viewModel.getCellViewModel(index: selectedCell)
    }
    
}

extension FilmViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel != nil ? viewModel.getCountOfCell() : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCell", for: indexPath) as! TableViewCell
        if viewModel != nil {
            cell.viewModel = viewModel.getCellViewModel(index: indexPath.row)
        }
        return cell
    }
}


extension FilmViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        isShowFavorite = false
        guard let text = searchBar.text else { return }
        uploadFilm(searchText: text)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
}


extension UIViewController {
    func hideKeyboardWhenTapOut() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboardView() {
        view.endEditing(true)
    }
}
