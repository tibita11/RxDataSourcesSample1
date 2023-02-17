//
//  MainViewController.swift
//  RxDataSourcesSample1
//
//  Created by 鈴木楓香 on 2023/02/16.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    let disposeBag = DisposeBag()
    /// データソース
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel>(configureCell: {
        (dataSource, tableView, indexPath, item) in
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = item.name
        cell.contentConfiguration = config
        return cell
        
    }, titleForHeaderInSection: {
        (dataSource, indexPath) in
        return dataSource.sectionModels[indexPath].header
    })
    /// DB操作をするViewModel
    var viewModel: ViewModel!
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ViewModel()
        setupInput()
        setupTableView()
        setupNavigationBar()
        // DBに保存されているデータを反映
        viewModel.getData()
    }
    
    
    // MARK: - Action
    
    /// 入力処理の初期設定
    private func setupInput() {
        let input = ViewModelInput(addButton: addButton.rx.tap.asObservable(), itemDeleted: tableView.rx.itemDeleted.asObservable(), itemMoved: tableView.rx.itemMoved.asObservable())
        viewModel.setup(input: input)
    }
    
    /// TableViewに関する初期設定
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.contentInset.bottom = 12.0
        // delegateの設定
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        // TableView自動更新
        viewModel.output?.itemsObserver
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    /// ナビゲーションバーに関する初期設定
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    // 編集ボタンでTableViewを編集状態にする
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.isEditing = editing
    }



}


// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
}
