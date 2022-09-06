//
//  APICaller.swift
//  MovieTMDB
//
//  Created by Dmitriy Stepanov on 22.08.2022.
//

import Foundation
import UIKit

struct Constans {
    static let baseURL = "https://api.themoviedb.org"
    static let API_KEY = "3d8c4618059cb074ba7187853bf758cb"
    static let youtubeAPI_KEY = "AIzaSyDJTvqGOe56bgBZ4NEK58KNK13NCy7FHV4"
    static let youtubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}
struct TypeMovie {
    static let trendingMovies = "/3/trending/movie/day?api_key="
    static let upcomig = "/3/movie/upcoming?api_key="
    static let trendingTvs = "/3/trending/tv/day?api_key="
    static let popular = "/3/movie/popular?api_key="
    static let topRateMove = "/3/movie/top_rated?api_key="
    static let discover = "/3/discover/movie?api_key="
}


class APICaller {
    static let shared = APICaller()
    func getMovies( typeMovie: String, completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constans.baseURL)\(typeMovie)\(Constans.API_KEY)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
// Пробуем подлючить и распечатать дату в консоле
//              let results = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//              print(results)
                let results = try JSONDecoder().decode(TMDBResponce.self, from: data)
                completion(.success(results.results))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
        }
    

    func search(with query: String, completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constans.baseURL)/3/search/movie?api_key=\(Constans.API_KEY)&query=\(query)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(TMDBResponce.self, from: data)
                completion(.success(results.results))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getYoutubeMovie(with query: String, completion: @escaping (Result<VideoElemet, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constans.youtubeBaseURL)q=\(query)&key=\(Constans.youtubeAPI_KEY)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(YoutubeSearchResponce.self, from: data)
                print(results)
                completion(.success(results.items[0]))
            }
            catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
    
