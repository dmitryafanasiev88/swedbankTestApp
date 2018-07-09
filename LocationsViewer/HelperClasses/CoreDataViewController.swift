import UIKit
import CoreData

class CoreDataViewController: UIViewController {
    var fetchResultController: NSFetchedResultsController<NSFetchRequestResult>?
    
    final func fetchLocalData() {
        do {
            try fetchResultController?.performFetch()
        } catch {
            print("\n-------Error due to fetching data in \(String(describing: self))-------\n")
        }
    }
    
    func configureFetchController() {
        // Override
    }
}
