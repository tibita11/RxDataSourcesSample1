//
//  DataStoraga.swift
//  RxDataSourcesSample1
//
//  Created by 鈴木楓香 on 2023/02/16.
//

import Foundation
import RxSwift

enum DBError: LocalizedError {
    case saveFailed
    case getFailed
    
    var errorDescription: String? {
        switch self {
        case .saveFailed:
            return "保存に失敗しました。"
        case .getFailed:
            return "取得に失敗しました。"
        }
    }
}




class DataStorage {
    
    /// UserDefaultsに保存する処理
    /// - Parameter object: 保存するSectionModel
    /// - Parameter key: UserDefaultsのキー値
    func saveData(object: [SectionModel], key: String) {
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(object)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(DBError.saveFailed.localizedDescription)
        }
    }
    
    /// UserDefaultsから取得する処理
    /// - Parameter key: UserDefaultsのキー値
    /// - Returns: Observable<[SectionModel]>
    func getData(key: String) -> Observable<[SectionModel]> {
        return Observable<[SectionModel]>.create { observer in
            let jsonDecoder = JSONDecoder()
            if let data = UserDefaults.standard.data(forKey: key) {
                do {
                    let sectionModel = try jsonDecoder.decode([SectionModel].self, from: data)
                    observer.onNext(sectionModel)
                    observer.onCompleted()
                } catch {
                    observer.onError(DBError.getFailed)
                }
                observer.onError(DBError.getFailed)
            }
            return Disposables.create()
        }
    }
    
}
