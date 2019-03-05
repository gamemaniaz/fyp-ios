import Foundation


class PackedItem : NSCoding, Codable{

    var allocatedQuantity : Int!
    var category : String!
    var classification : String!
    var description : String!
    var inventoryQuantity : Int!
    var itemPackingStatus : Bool!
    var packedQuantity : Int!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        allocatedQuantity = dictionary["allocatedQuantity"] as? Int
        category = dictionary["category"] as? String
        classification = dictionary["classification"] as? String
        description = dictionary["description"] as? String
        inventoryQuantity = dictionary["inventoryQuantity"] as? Int
        itemPackingStatus = dictionary["itemPackingStatus"] as? Bool
        packedQuantity = dictionary["packedQuantity"] as? Int
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if allocatedQuantity != nil{
            dictionary["allocatedQuantity"] = allocatedQuantity
        }
        if category != nil{
            dictionary["category"] = category
        }
        if classification != nil{
            dictionary["classification"] = classification
        }
        if description != nil{
            dictionary["description"] = description
        }
        if inventoryQuantity != nil{
            dictionary["inventoryQuantity"] = inventoryQuantity
        }
        if itemPackingStatus != nil{
            dictionary["itemPackingStatus"] = itemPackingStatus
        }
        if packedQuantity != nil{
            dictionary["packedQuantity"] = packedQuantity
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        allocatedQuantity = aDecoder.decodeObject(forKey: "allocatedQuantity") as? Int
        category = aDecoder.decodeObject(forKey: "category") as? String
        classification = aDecoder.decodeObject(forKey: "classification") as? String
        description = aDecoder.decodeObject(forKey: "description") as? String
        inventoryQuantity = aDecoder.decodeObject(forKey: "inventoryQuantity") as? Int
        itemPackingStatus = aDecoder.decodeObject(forKey: "itemPackingStatus") as? Bool
        packedQuantity = aDecoder.decodeObject(forKey: "packedQuantity") as? Int
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if allocatedQuantity != nil{
            aCoder.encode(allocatedQuantity, forKey: "allocatedQuantity")
        }
        if category != nil{
            aCoder.encode(category, forKey: "category")
        }
        if classification != nil{
            aCoder.encode(classification, forKey: "classification")
        }
        if description != nil{
            aCoder.encode(description, forKey: "description")
        }
        if inventoryQuantity != nil{
            aCoder.encode(inventoryQuantity, forKey: "inventoryQuantity")
        }
        if itemPackingStatus != nil{
            aCoder.encode(itemPackingStatus, forKey: "itemPackingStatus")
        }
        if packedQuantity != nil{
            aCoder.encode(packedQuantity, forKey: "packedQuantity")
        }
    }
}
