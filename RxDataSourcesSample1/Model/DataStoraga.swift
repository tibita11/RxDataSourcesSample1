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
    
    var errorDescription: String? {
        switch self {
        case .saveFailed:
            return "保存に失敗しました。"
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
    
}
