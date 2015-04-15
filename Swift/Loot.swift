//  Loot model

import Foundation

//  MARK: Loot constants

let UNKNOWN = "Uknown"
let TYPEGEAR = "Gear"
let TYPEPOTION = "Potion"
let GOLD = "Gold"
let CLARITYPOT = "Clarity_Potion"
let ENERGYPOT = "Energy_Potion"
let HEALTHPOT = "Health_Potion"
let BOW = "Bow"
let TSWORD = "Toy_Sword"
let SWORD = "Sword"
let DAGGER = "Dagger"
let AXE = "Axe"
let MACE = "Mace"
let SPEAR = "Spear"
let STAFF = "Staff"
let SSHIELD = "Small_Shield"
let LSHIELD = "Shield"
let HELMET = "Helmet"
let BARMOUR = "Body_Armour"
let ONEHAND = "One_Hand"
let TWOHAND = "Two_Hand"
let ONEHANDARMOUR = "One_Hand_Armour"
let GOLDSUFFIX = "_Gold"


let DAMAGE = 25
let GOLDDAMAGE = 50

class Loot: NSObject {
    let name: String        //  Name of loot
    let image: UIImage      //  Display image of loot
    let lootId: String      //  The unique id for this specific piece of loot
    
    //  Initialize loot
    init(name: String, imageName: String, lootId: String) {
        self.lootId = lootId
        self.name = name
        self.image = UIImage(named: imageName)!
    }
    
    //  MARK: Loot Getters
    
    func getImage() -> UIImage {
      return image
    }
    
    func getName() -> String {
        return name
    }
    
    func getId() -> String {
        return self.lootId
    }
    
    //  Displays the loot name in readable format
    func getPrettyName() -> String {
        var splitName = name.componentsSeparatedByString("_")
        var prettyName: String = ""
        for i in 0...splitName.count - 1 {
            if i != splitName.count - 1 {
                prettyName += splitName[i] + " "
            }
            else {
                prettyName += splitName[i]
            }
        }
        return prettyName;
    }
    
    func getClassType() -> String {
        return UNKNOWN
    }
}