//
//  DataPersistenceManager.swift
//  MovieTMDB
//
//  Created by Dmitriy Stepanov on 30.08.2022.
//

import Foundation
import CoreData
import UIKit

class DataPersistenceManager {
    
    enum DatabaseError: Error {
        case failedToSaveData
        case failedToFetchData
    }
    
    static let shared = DataPersistenceManager()
    
    func downloadRirleWith(model: Title, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let item = TmdbData(context: context)
        
        item.original_title = model.original_title
        item.overview = model.overview
        item.id = Int64(model.id)
        item.poster_path = model.poster_path
        item.media_type = model.media_type
        item.original_language = model.original_language
        item.release_date = model.release_date
        item.vote_average = model.vote_average
        item.vote_count = Int64(model.vote_count)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }
    
    func fetchingDataFromDB(comletion: @escaping (Result<[TmdbData], Error>)->Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<TmdbData>
        request = TmdbData.fetchRequest()
       
        do{
            let titles = try context.fetch(request)
            comletion(.success(titles))
        } catch {
            comletion(.failure(DatabaseError.failedToFetchData))
        }
    }
}

