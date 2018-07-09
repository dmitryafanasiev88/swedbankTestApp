import Foundation
import CoreData


protocol RegionCustomizationProtocol {
    func customizeWithRegion(_ region: Region?)
}

open class Region: NSManagedObject {
    @NSManaged open var name : String
    @NSManaged open var country: String
    
}

extension Region {
    
    @nonobjc static func regionWithName(_ name: String) -> Region? {
        return Region.regionWithNameInContext(name, context: AppDelegate.shared.persistentContainer.viewContext)
    }
    
    @nonobjc static func regionWithNameInContext(_ name: String, context: NSManagedObjectContext) -> Region? {
        return Region.fetchFromContext(context: context, withPredicate: NSPredicate(format: "name == '\(name)'"), sortDescriptors: nil)?.first
    }
    
    @nonobjc static func regionWithNameOrNewRegion(_ name: String) -> Region {
        return regionWithNameOrNewRegionInContext(name, context: AppDelegate.shared.persistentContainer.viewContext)
    }
    
    @nonobjc static func regionWithNameOrNewRegionInContext(_ name: String, context: NSManagedObjectContext) -> Region {
        let region: Region = Region.regionWithNameInContext(name, context: context) ?? context.insertObject()
        region.name = name
        return region
    }
}
