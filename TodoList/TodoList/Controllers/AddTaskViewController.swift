//
//  AddTaskViewController.swift
//  TodoList
//
//  Created by Prasad on 5/10/20.
//  Copyright © 2020 Prasad. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var takTextField: UITextField!
    
    private var taskSubject =  PublishSubject<Task>()
    var taskSubjectObservable: Observable<Task> {
        taskSubject.asObserver()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        guard let priority = Priority(rawValue: self.segmentControl.selectedSegmentIndex),
            let title = takTextField.text else { return }
        
        let task = Task(title: title, priority: priority)
        taskSubject.onNext(task)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
