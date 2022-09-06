//
//  SearchVC.swift
//  MovieTMDB
//
//  Created by Dmitriy Stepanov on 23.08.2022.
//

import UIKit

class SearchVC: UIViewController {

    private let discoverTable = UITableView()
    private var titles = [Title]()
    private var searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTable()
        setTableDelegate()
        fetchDisciverMoviews()
        configSearchController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
        searchController.searchResultsUpdater = self
    }
    
    func configSearchController(){
        searchController = UISearchController(searchResultsController: SearchResultsViewController())
        searchController.searchBar.placeholder = "Search for a Movie or a Tv Show"
        searchController.searchBar.searchBarStyle = .minimal
        navigationController?.navigationBar.tintColor = .white
        navigationItem.searchController = searchController
    }
    
    func fetchDisciverMoviews(){
        
        searchController.searchResultsUpdater = self
        
        APICaller.shared.getMovies(typeMovie: TypeMovie.discover) { [weak self] result in
            switch result {
            case .success(let success):
                self?.titles = success
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    
    func setTableDelegate(){
        discoverTable.delegate = self
        discoverTable.dataSource = self
    }
    
    func configureTable(){
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(discoverTable)
        discoverTable.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifire)
        discoverTable.rowHeight = 180
        discoverTable.sectionHeaderHeight = 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title else { return }
        print(titleName)
        
        APICaller.shared.getYoutubeMovie(with: titleName) { result in
            
            switch result {
            case .success(let videoEllement):
                DispatchQueue.main.async {
                    let vc = TitleDetailsViewController()
                    vc.configure(with: DetailPreviewViewModel(title: titleName + "trailer", youTubeVideo: videoEllement, description: title.overview ?? ""))
                    self.navigationController?.pushViewController(vc, animated: true)
                }
               
            case.failure(let error):
                print(error.localizedDescription)
                
            }
        }
        
    }
    

}


extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifire, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: title.original_title ?? "Unknow Titles", posterURL: title.poster_path ?? ""))
        return cell
        
    }
   
    
    
}


extension SearchVC : UISearchResultsUpdating, SearchResultsViewControllerDelegate {

    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let serchBar = searchController.searchBar
       guard let query = serchBar.text,
            !query.trimmingCharacters(in: .whitespaces).isEmpty,
                query.trimmingCharacters(in: .whitespaces).count >= 3,
             let resultController = searchController.searchResultsController as? SearchResultsViewController else {
                 return
             }
        resultController.delegate = self
        
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success( let title):
                    resultController.titles = title
                    print(title)
                    resultController.searchResultCollectionView.reloadData()
                case .failure( let error):
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    
    func searchResultsViewControllerDidTapItems(_ viewModel: DetailPreviewViewModel) {
        
        DispatchQueue.main.async { [weak self] in
            let vc = TitleDetailsViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    
    
}
