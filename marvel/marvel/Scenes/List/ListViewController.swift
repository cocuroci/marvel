import UIKit

protocol ListDisplaying {
    
}

final class ListViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
}

extension ListViewController: ListDisplaying {
    
}
