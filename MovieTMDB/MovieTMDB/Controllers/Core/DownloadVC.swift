//
//  DownloadVC.swift
//  MovieTMDB
//
//  Created by Dmitriy Stepanov on 23.08.2022.
//

import UIKit

class DownloadVC: UIViewController {

    let downloadTable = UITableView()
    
    var titles = [TmdbData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemYellow
        
        title = "Downlaod"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        configureTable()
        delegateTable()
        fetchLocalStoargeFromData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadTable.frame = view.bounds
    }
    
    private func fetchLocalStoargeFromData (){
        DataPersistenceManager.shared.fetchingDataFromDB {[weak self] result in
            switch result {
                
            case .success(let titles):
                self?.titles = titles
                self?.downloadTable.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    
    func delegateTable(){
        downloadTable.delegate = self
        downloadTable.dataSource = self
    }
    
    func configureTable(){
        title = "Downloads"
        view.addSubview(downloadTable)
        downloadTable.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifire)
        downloadTable.rowHeight = 180
        downloadTable.sectionHeaderHeight = 40
    }

}

extension DownloadVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifire, for: indexPath) as? TitleTableViewCell else { return UITableViewCell()  }
        
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: title.original_title ?? "Unknow Titles", posterURL: title.poster_path ?? ""))
        return cell
    }
   
    
    
}

