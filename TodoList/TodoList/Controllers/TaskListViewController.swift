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

class TaskListViewController: UIViewController {
    
    @IBOutlet weak var todoListTableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var disposeBag = DisposeBag()
    var taskList = BehaviorRelay<[Task]>(value: [])
    var filteredTasks: [Task]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
//        taskList.bind(to: todoListTableView.rx.items(cellIdentifier: "todoCell", cellType: UITableViewCell.self)) { row, task, cell in
//            cell.textLabel?.text = task.title
//        }.disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navVC = segue.destination as? UINavigationController,
            let addTaskVC = navVC.viewControllers.first as? AddTaskViewController else {
            return
        }
        addTaskVC.taskSubjectObservable.subscribe(onNext: { task in
            
            let priority = Priority(rawValue: self.segmentControl.selectedSegmentIndex - 1)
            
            var values = self.taskList.value
            values.append(task)
            self.taskList.accept(values)
            self.filterTask(by: priority)
            self.updateTableView()
        }).disposed(by: disposeBag)
    }
    
    func updateTableView() {
        DispatchQueue.main.async {
            self.todoListTableView.reloadData()
        }
    }
    
    @IBAction func priorityValueCahged(segmentedControl: UISegmentedControl) {
        let priority = Priority(rawValue: segmentControl.selectedSegmentIndex - 1)
        filterTask(by: priority)
        self.updateTableView()
    }
    
    func filterTask(by priority: Priority?) {
        guard let priority = priority else {
            self.filteredTasks = self.taskList.value
            return
        }
        self.taskList.map { tasks in
            return tasks.filter{ $0.priority == priority }
        }.subscribe(onNext: { [weak self] tasks in
            self?.filteredTasks = tasks
        }).disposed(by: disposeBag)
    }
}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        if let task = filteredTasks?[indexPath.row] {
            cell.textLabel?.text = task.title
        }
        return cell
    }
    
}
