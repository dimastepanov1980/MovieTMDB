//
//  HomeVC.swift
//  MovieTMDB
//
//  Created by Dmitriy Stepanov on 23.08.2022.
//

import UIKit

enum Section : Int {
    case TrandingMovies = 0
    case Popular = 1
    case TrandingTV = 2
    case UpcommingMovies = 3
    case TopRated = 4
}

class HomeVC: UIViewController {
    
    private let homeTable = UITableView(frame: .zero, style: .grouped)
    let sectionTitles = ["Tranding Movies", "Popular",  "Tranding TV", "Upcomming Movies", "Top Rated"]
    private var herroImage : HerroHeaderUIView?
    private var randomHeroImages: Title?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        setTableDelegate()
        configureNavBar()
        configuereRandomHeroImages()
    }
    
    func configureTable() {
        view.addSubview(homeTable)
        homeTable.register(CollectionViewTableViewCell .self, forCellReuseIdentifier: CollectionViewTableViewCell .identifire)
        homeTable.frame = view.bounds
        homeTable.rowHeight = 200
        homeTable.sectionHeaderHeight = 40
        herroImage = HerroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height / 2.5))
        homeTable.tableHeaderView = herroImage
    }
    
    func configuereRandomHeroImages(){
        APICaller.shared.getMovies(typeMovie: TypeMovie.trendingMovies) { [weak self] result in
            switch result {
            case .success(let titles):
                let selectedTitle = titles.randomElement()
                self?.randomHeroImages = selectedTitle
                self?.herroImage?.configure(with: TitleViewModel(titleName: selectedTitle?.original_title ?? "", posterURL: selectedTitle?.poster_path ?? ""))
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setTableDelegate(){
        homeTable.delegate = self
        homeTable.dataSource = self
    }
    
    private func configureNavBar(){
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: nil, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil) ]
        navigationController?.navigationBar.tintColor = .white
    }
}



extension HomeVC: UITableViewDelegate, UITableViewDataSource {

// MARK: configure section and title
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
// MARK: configure font on section
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .regular)
        header.textLabel?.textColor = .white
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell .identifire, for: indexPath) as? CollectionViewTableViewCell  else {  return UITableViewCell() }
        
        cell.delegate = self
        
        switch indexPath.section {
            
        case Section.TrandingMovies.rawValue:
            APICaller.shared.getMovies(typeMovie: TypeMovie.trendingMovies) { result in
                switch result {
                case .success(let success):
                    cell.configureTitle(with: success)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Section.Popular.rawValue:
            APICaller.shared.getMovies(typeMovie: TypeMovie.popular) { result in
                switch result {
                case .success(let success):
                    cell.configureTitle(with: success)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Section.TrandingTV.rawValue:
            APICaller.shared.getMovies(typeMovie: TypeMovie.trendingTvs) { result in
                switch result {
                case .success(let success):
                    cell.configureTitle(with: success)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Section.UpcommingMovies.rawValue:
            APICaller.shared.getMovies(typeMovie: TypeMovie.upcomig) { result in
                switch result {
                case .success(let success):
                    cell.configureTitle(with: success)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Section.TopRated.rawValue:
            APICaller.shared.getMovies(typeMovie: TypeMovie.topRateMove) { result in
                switch result {
                case .success(let success):
                    cell.configureTitle(with: success)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        
        default: return UITableViewCell()
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffcet = view.safeAreaInsets.top
        let offcet = scrollView.contentOffset.y + defaultOffcet
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offcet))
    }
}

extension HomeVC: CollectionViewTableViewCellDelegate {
    
    func CollectionViewTableViewCellDidTapCell(withCell: CollectionViewTableViewCell, viewModel: DetailPreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitleDetailsViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


