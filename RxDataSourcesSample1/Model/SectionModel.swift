//
//  SectionModel.swift
//  RxDataSourcesSample1
//
//  Created by 鈴木楓香 on 2023/02/16.
//

import Foundation
import RxDataSources

struct SectionModel: Codable {
    var header: String
    var items: [SampleData]
}

extension SectionModel: SectionModelType {
    init(original: SectionModel, items: [SampleData]) {
        self = original
        self.items = items
    }
}

