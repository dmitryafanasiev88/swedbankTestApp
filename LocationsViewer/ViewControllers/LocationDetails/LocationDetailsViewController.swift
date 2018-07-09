import Foundation
import UIKit

class LocationDetailsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView?
    
    var viewModel = LocationDetailsViewModel(LocationDetailsCell.defaultReuseIdentifier)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.register(UINib(nibName: viewModel.cellReuseIdentifier, bundle: nil),
                            forCellReuseIdentifier: viewModel.cellReuseIdentifier)
        tableView?.dataSource = self
        tableView?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = viewModel.terminal?.name
    }
}

extension LocationDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getSectionRowCount(section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellReuseIdentifier, for: indexPath)
        if let cell = cell as? LocationDetailsCell {
            let data = viewModel.getCellInfo(indexPath)
            cell.fieldName = data.type
            cell.fieldValue = data.value
        }
        return cell
    }
    
}

extension LocationDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return viewModel.footerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.getRowHeight(indexPath, tableViewWidth: tableView.frame.width)
    }
    
}
