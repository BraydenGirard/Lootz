//  Factory class for database / networking layer
//  Currently set to run a Parse implementation

import Foundation

class DBFactory {
    class func execute() -> DatabaseManager {
        return ParseImpl()
    }
}