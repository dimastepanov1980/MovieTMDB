//
//  UpcommingVC.swift
//  MovieTMDB
// https://youtu.be/KCgYDCKqato?t=9113

//
//  Created by Dmitriy Stepanov on 23.08.2022.

import UIKit

class UpcommingVC: UIViewController {

    private let upcomingTable = UITableView()
    private var titles = [Title]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTable()
        setTableDelegate()
        fetchUpcomming()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    func fetchUpcomming(){
        
        APICaller.shared.getMovies(typeMovie: TypeMovie.upcomig) { [weak self] result in
            switch result {
            case .success(let success):
                self?.titles = success
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    


    
    func configureTable() {
        title = "Coming Soon"
        view.addSubview(upcomingTable)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        upcomingTable.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifire)
        upcomingTable.rowHeight = 180
        upcomingTable.sectionHeaderHeight = 40

        
    }
    
    func setTableDelegate(){
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title else { return }
        
        APICaller.shared.getYoutubeMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitleDetailsViewController()
                    vc.configure(with: DetailPreviewViewModel(title: titleName + " trailer", youTubeVideo: videoElement, description: title.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    

}

extension UpcommingVC : UITableViewDataSource, UITableViewDelegate {
    
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


