//
//  ViewController.swift
//  C2 HomeWork 14
//
//  Created by Вадим on 29.10.2020.
//  Copyright © 2020 Vadim. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UITableViewController {
    
    private let cellID = "cell"
    var tasks: Results<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasks = realm.objects(Task.self)
        
        setupView()
        
        // Table view cell register
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tasks = realm.objects(Task.self)
    }

    /// Setup view
    private func setupView() {
        view.backgroundColor = .white
        setupNavigationBar()
    }
    
    /// Setup navigation bar
    private func setupNavigationBar() {
        
        // Set title for navigation bar
        title = "Tasks list"
        
        // Title color
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        // Navigation bar color
        let backColor = UIColor(
            displayP3Red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )
        navigationController?.navigationBar.barTintColor = backColor
        navigationController?.navigationBar.backgroundColor = backColor
        
        // Set large title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Add button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add",
            style: .plain,
            target: self,
            action: #selector(addNewTask)
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Edit",
            style: .plain,
            target: self,
            action: #selector(editTask)
        )
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func addNewTask() {
        addAlert(title: "New Task", message: "What do you want to do?",
                 complition: {
                    self.tableView.insertRows(
                        at: [IndexPath(row: self.tasks.count - 1, section: 0)],
                        with: .automatic)
                 })
    }

    @objc private func editTask() {
        tableView.isEditing = !tableView.isEditing
        if navigationItem.leftBarButtonItem?.title == "Edit" {
            navigationItem.leftBarButtonItem?.title = "Done"
        } else { navigationItem.leftBarButtonItem?.title = "Edit" }
    }
}

// MARK: - UITableViewDataSource
extension ViewController {
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
        ) -> Int {
        return tasks.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
        ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID,
                                                 for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.name
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let task = self.tasks[indexPath.row]
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") {
            _, indexPath in
            StorageManager.deleteTask(task)
            tableView.deleteRows(at: [indexPath], with: .left)
        }

        let renameAction = UITableViewRowAction(style: .normal, title: "Rename") {
            _, indexPath in
            self.renameAlert(title: "Rename Task",
                            message: "Enter new name for current task",
                            for: task,
                            complition: {
                                tableView.reloadRows(at: [indexPath], with: .automatic)
                            })
        }

        return [deleteAction, renameAction]
    }
}


// MARK: - Setup Alert Controller
extension ViewController {
    
    private func addAlert(title: String, message: String, complition: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        // Save action
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            
            guard let newValue = alert.textFields?.first?.text else { return }
            guard !newValue.isEmpty else { return }
            
            let newTask = Task()
            newTask.name = newValue
            StorageManager.addTask(newTask)
        
            if complition != nil { complition!() }
        }
        
        // Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { _ in
            if let indexPath = self.tableView.indexPathForSelectedRow {
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
        
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func renameAlert(title: String, message: String, for task: Task,
                             complition: (() -> Void)? = nil) {

        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)

        // Rename action
        let renameAction = UIAlertAction(title: "Rename", style: .default) { _ in

            guard let newValue = alert.textFields?.first?.text else { return }
            guard !newValue.isEmpty else { return }

            StorageManager.rename(task, with: newValue)
            if complition != nil { complition!() }
        }

        // Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { _ in
            if let indexPath = self.tableView.indexPathForSelectedRow {
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
        }



        alert.addTextField()
        alert.textFields?.first?.text = task.name
        alert.textFields?.first?.clearButtonMode = .whileEditing
        alert.addAction(renameAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
}
