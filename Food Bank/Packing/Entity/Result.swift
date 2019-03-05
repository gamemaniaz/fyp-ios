import Foundation


class Result : NSObject, NSCoding, Codable{

    var beneficiary : Beneficiary!
    var id : Int!
    var packedItems : [PackedItem]!
    var packingStatus : Bool!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["id"] as? Int
        packingStatus = dictionary["packingStatus"] as? Bool
        if let beneficiaryData = dictionary["beneficiary"] as? [String:Any]{
            beneficiary = Beneficiary(fromDictionary: beneficiaryData)
        }
        packedItems = [PackedItem]()
        if let packedItemsArray = dictionary["packedItems"] as? [[String:Any]]{
            for dic in packedItemsArray{
                let value = PackedItem(fromDictionary: dic)
                packedItems.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if id != nil{
            dictionary["id"] = id
        }
        if packingStatus != nil{
            dictionary["packingStatus"] = packingStatus
        }
        if beneficiary != nil{
            dictionary["beneficiary"] = beneficiary.toDictionary()
        }
        if packedItems != nil{
            var dictionaryElements = [[String:Any]]()
            for packedItemsElement in packedItems {
                dictionaryElements.append(packedItemsElement.toDictionary())
            }
            dictionary["packedItems"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        beneficiary = aDecoder.decodeObject(forKey: "beneficiary") as? Beneficiary
        id = aDecoder.decodeObject(forKey: "id") as? Int
        packedItems = aDecoder.decodeObject(forKey: "packedItems") as? [PackedItem]
        packingStatus = aDecoder.decodeObject(forKey: "packingStatus") as? Bool
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if beneficiary != nil{
            aCoder.encode(beneficiary, forKey: "beneficiary")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if packedItems != nil{
            aCoder.encode(packedItems, forKey: "packedItems")
        }
        if packingStatus != nil{
            aCoder.encode(packingStatus, forKey: "packingStatus")
        }
    }
}
