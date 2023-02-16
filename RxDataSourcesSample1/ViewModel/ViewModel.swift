//
//  DataStorege.swift
//  RxDataSourcesSample1
//
//  Created by 鈴木楓香 on 2023/02/16.
//

import Foundation
import RxSwift
import RxCocoa


/// 通知処理
struct ViewModelInput {
    let addButton: Observable<Void>
}

/// UI更新処理
protocol ViewModelOutput {
    var itemsObserver: Observable<[SectionModel]> { get }
}


protocol ViewModelType {
    var output: ViewModelOutput? { get }
    func setup(input: ViewModelInput, model: DataStorage)
}


class ViewModel: ViewModelType {
    
    var output: ViewModelOutput?
    
    let disposeBag = DisposeBag()
    
    init() {
        // 初期設定
        output = self
    }
    
    /// データの変更通知をする
    private var items = BehaviorRelay<[SectionModel]>(value: [])
    
    /// 初期設定
    func setup(input: ViewModelInput, model: DataStorage) {
        // 新しいSampleDataを追加し、DBに保存する
        input.addButton
            .subscribe(onNext: { [weak self] in
                // 前回値を取得して新規SampleDataを配列に追加
                var section = self!.items.value
                if section.count == 0 {
                    // 登録がない場合
                    let newData = [SectionModel(header: "Section1", items: [SampleData(name: "Sample")])]
                    section = newData
                } else {
                    // 登録がある場合
                    let newData = SampleData(name: "Sample")
                    section[0].items.append(newData)
                }
                // DBに保存
                model.saveData(object: section, key: Const.userDefaulsKey)
                // プロパティを変更
                self!.items.accept(section)
            })
            .disposed(by: disposeBag)
    }
    
}


// MARK: - DataStoregeOutput

extension ViewModel: ViewModelOutput {
    var itemsObserver: Observable<[SectionModel]> {
        return items.asObservable()
    }
    
    
}
