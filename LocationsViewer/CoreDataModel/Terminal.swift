import Foundation
import CoreData

protocol TerminalDataCustomizationProtocol {
    func customizeWithData(_ data: TerminalData)
}

protocol TerminalCustomizationProtocol {
    func customizeWithTerminal(_ terminal: Terminal?)
}

enum Country: String {
    case Estonia
    case Latvia
    case Lithuania
    
    var downloadURL: String {
        get {
            switch self {
                case .Estonia: return "https://www.swedbank.ee/finder.json"
                case .Latvia: return "https://ib.swedbank.lv/finder.json"
                case .Lithuania: return "https://ib.swedbank.lt/finder.json"
            }
        }
    }
}

enum TerminalType: Int {
    case Branch = 0
    case ATM = 1
    case BNA = 2
    
    var description: String {
        get {
            switch self {
                case .Branch: return "BR"
                case .ATM: return "A"
                case .BNA: return "R"
            }
        }
    }
    
    var name: String {
        get {
            switch self {
            case .Branch: return "Branch"
            case .ATM: return "ATM (Automated Teller Machine)"
            case .BNA: return "BNA (Bunch Note Acceptor)"
            }
        }
    }
}


open class Terminal: NSManagedObject, TerminalDataCustomizationProtocol {
    @NSManaged open var id: String
    @NSManaged open var name : String?
    @NSManaged open var country: String?
    @NSManaged open var address : String?
    @NSManaged open var region : String?
    @NSManaged open var type: NSNumber?
    @NSManaged open var latitude: NSNumber?
    @NSManaged open var longitude: NSNumber?
    @NSManaged open var availability: String?
    @NSManaged open var info: String?
    @NSManaged open var noCash: NSNumber?
    @NSManaged open var coinsStation: NSNumber?
    
    func customizeWithData(_ data: TerminalData) {
        self.name = data.n
        self.address = data.a
        self.region = data.r
        self.availability = data.av
        self.info = data.i
        if let t = data.t {
            self.type = NSNumber(value: t)
        }
        if let lat = data.lat {
            self.latitude = NSNumber(value:lat)
        }
        if let lon = data.lon {
            self.longitude = NSNumber(value: lon)
        }
        if let noCash = data.ncash {
            self.noCash = NSNumber(value: noCash)
        }
        if let coinsStation = data.cs {
            self.coinsStation = NSNumber(value: coinsStation)
        }
    }
    
    func getTerminalType() -> TerminalType? {
        if let t = self.type,
            let terminalType = TerminalType(rawValue: t.intValue) {
            return terminalType
        }
        return nil
    }
    
}

extension Terminal {
    
    @nonobjc static func terminalWithId(_ id: String) -> Terminal? {
        return Terminal.terminalWithIdInContext(id, context: AppDelegate.shared.persistentContainer.viewContext)
    }
    
    @nonobjc static func terminalWithIdInContext(_ id: String, context: NSManagedObjectContext) -> Terminal? {
        return Terminal.fetchFromContext(context: context, withPredicate: NSPredicate(format: "id == %@", id), sortDescriptors: nil)?.first
    }
    
    @nonobjc static func terminalWithIdOrNewTerminal(_ id: String) -> Terminal {
        return terminalWithIdOrNewTerminalInContext(id, context: AppDelegate.shared.persistentContainer.viewContext)
    }
    
    @nonobjc static func terminalWithIdOrNewTerminalInContext(_ id: String, context: NSManagedObjectContext) -> Terminal {
        var terminal: Terminal? = Terminal.terminalWithIdInContext(id, context: context)
        if terminal != nil {
//            print("existing \(terminal!.id)")
        } else {
            terminal = context.insertObject()
            terminal!.id = id
        }
        
        return terminal!
    }
}
