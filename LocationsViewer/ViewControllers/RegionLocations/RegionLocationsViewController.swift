import UIKit
import CoreData
import Foundation


class RegionLocationsViewController: CoreDataTableViewController {
    var viewModel = RegionLocationsViewModel(RegionLocationCell.defaultReuseIdentifier)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.register(UINib(nibName: viewModel.cellReuseIdentifier, bundle: nil),
                            forCellReuseIdentifier: viewModel.cellReuseIdentifier)
        tableView?.delegate = self
        tableView?.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = viewModel.region?.name
    }
    
    override func configureFetchController() {
        if let fetchRequest = viewModel.fetchRequest {
            self.fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                    managedObjectContext: AppDelegate.shared.persistentContainer.viewContext,
                                                                    sectionNameKeyPath: viewModel.sectionNameKeyPath,
                                                                    cacheName: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? LocationDetailsViewController,
            let indexPath = sender as? IndexPath {
            if let terminal = fetchResultController?.object(at: indexPath) as? Terminal {
                controller.viewModel.terminal = terminal
            }
        }
    }
    
}

extension RegionLocationsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultController?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellReuseIdentifier, for: indexPath)
        if let cell = cell as? RegionLocationCell,
            let terminal = fetchResultController?.object(at: indexPath) as? Terminal {
            cell.customizeWithTerminal(terminal)
        }
        return cell
    }
    
}

extension RegionLocationsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let segueId = viewModel.segueId {
            performSegue(withIdentifier: segueId.rawValue, sender: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.cellHeight
    }

}
