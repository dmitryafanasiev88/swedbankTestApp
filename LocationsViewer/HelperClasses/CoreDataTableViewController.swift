import UIKit

class CoreDataTableViewController: CoreDataViewController {
    @IBOutlet weak var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tableView = tableView {
            tableView.tableHeaderView = UIView(frame: CGRect(x: 0,
                                                             y: 0,
                                                             width: tableView.frame.width,
                                                             height: 1))
            tableView.tableFooterView = UIView(frame: CGRect(x: 0,
                                                             y: 0,
                                                             width: tableView.frame.width,
                                                             height: 1))
            tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        }
        
        configureFetchController()
        performFetch()
    }
    
    final func performFetch() {
        fetchLocalData()
        tableView?.reloadData()
    }
    
}

