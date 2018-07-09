import Foundation
import UIKit
import CoreData

class LocationsViewController: CoreDataTableViewController {
    var viewModel = LocationsViewModel(RegionCell.defaultReuseIdentifier)
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        
        tableView?.register(UINib(nibName: viewModel.cellReuseIdentifier, bundle: nil),
                            forCellReuseIdentifier: viewModel.cellReuseIdentifier)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.refreshControl = self.refreshControl
        
        viewModel.downloadCallback = { [weak self] in
            self?.performFetch()
            self?.refreshControl.endRefreshing()
        }
        viewModel.download()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Regions"
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
        if let controller = segue.destination as? RegionLocationsViewController,
            let indexPath = sender as? IndexPath {
            if let region = fetchResultController?.object(at: indexPath) as? Region {
                controller.viewModel.region = region
            }
        }
    }
    
    @objc func onRefresh() {
        viewModel.download()
    }
    
}

extension LocationsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchResultController?.sections?[section].objects?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = self.fetchResultController?.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.fetchResultController?.sections?[section].name ?? nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellReuseIdentifier, for: indexPath)
        if let cell = cell as? RegionCell,
            let region = self.fetchResultController?.object(at: indexPath) as? Region {
            cell.customizeWithRegion(region)
        }
        return cell
    }
    
}

extension LocationsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let segueId = viewModel.segueId {
            performSegue(withIdentifier: segueId.rawValue, sender: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return viewModel.footerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.cellHeight
    }
    
}
