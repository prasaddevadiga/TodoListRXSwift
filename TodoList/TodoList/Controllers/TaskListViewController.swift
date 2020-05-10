//
//  TaskListViewController.swift
//  TodoList
//
//  Created by Prasad on 5/10/20.
//  Copyright © 2020 Prasad. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

let cellIdentifier = "todoCell"
class TaskListViewController: UIViewController {
    
    @IBOutlet weak var todoListTableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var disposeBag = DisposeBag()
    var filteredTaskList = BehaviorRelay<[Task]>(value: [])
    var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = UIColor.init(red: 112/255, green: 171/255, blue: 175/255, alpha: 1)
        filteredTaskList.bind(to: todoListTableView.rx.items(cellIdentifier: cellIdentifier , cellType: UITableViewCell.self)) { row, task, cell in
            cell.textLabel?.text = task.title
        }.disposed(by: disposeBag)
        
        segmentControl.rx.selectedSegmentIndex.subscribe(onNext: { [weak self] selectedIndex in
            self?.filter(by: Priority(rawValue: selectedIndex - 1))
        }).disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navVC = segue.destination as? UINavigationController,
            let addTaskVC = navVC.viewControllers.first as? AddTaskViewController else {
            return
        }
        addTaskVC.taskSubjectObservable.subscribe(onNext: { [weak self] task in
            guard let weakSelf = self else { return }
            weakSelf.tasks.append(task)
            weakSelf.filter(by: Priority(rawValue: weakSelf.segmentControl.selectedSegmentIndex - 1))
        }).disposed(by: disposeBag)
    }
    
    private func filter(by priority: Priority?) {
        guard let priority = priority else {
            self.filteredTaskList.accept(self.tasks)
            return
        }
        let filteredTasks = self.tasks.filter { $0.priority == priority }
        self.filteredTaskList.accept(filteredTasks)
    }
}
