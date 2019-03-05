import Foundation


class Beneficiary : NSObject, NSCoding, Codable{

    var address : String!
    var contactNumber : String!
    var contactPerson : String!
    var email : String!
    var hasTransport : Bool!
    var memberType : String!
    var name : String!
    var numBeneficiary : Int!
    var score : Double!
    var username : String!
    var usertype : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        address = dictionary["address"] as? String
        contactNumber = dictionary["contactNumber"] as? String
        contactPerson = dictionary["contactPerson"] as? String
        email = dictionary["email"] as? String
        hasTransport = dictionary["hasTransport"] as? Bool
        memberType = dictionary["memberType"] as? String
        name = dictionary["name"] as? String
        numBeneficiary = dictionary["numBeneficiary"] as? Int
        score = dictionary["score"] as? Double
        username = dictionary["username"] as? String
        usertype = dictionary["usertype"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if address != nil{
            dictionary["address"] = address
        }
        if contactNumber != nil{
            dictionary["contactNumber"] = contactNumber
        }
        if contactPerson != nil{
            dictionary["contactPerson"] = contactPerson
        }
        if email != nil{
            dictionary["email"] = email
        }
        if hasTransport != nil{
            dictionary["hasTransport"] = hasTransport
        }
        if memberType != nil{
            dictionary["memberType"] = memberType
        }
        if name != nil{
            dictionary["name"] = name
        }
        if numBeneficiary != nil{
            dictionary["numBeneficiary"] = numBeneficiary
        }
        if score != nil{
            dictionary["score"] = score
        }
        if username != nil{
            dictionary["username"] = username
        }
        if usertype != nil{
            dictionary["usertype"] = usertype
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        address = aDecoder.decodeObject(forKey: "address") as? String
        contactNumber = aDecoder.decodeObject(forKey: "contactNumber") as? String
        contactPerson = aDecoder.decodeObject(forKey: "contactPerson") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        hasTransport = aDecoder.decodeObject(forKey: "hasTransport") as? Bool
        memberType = aDecoder.decodeObject(forKey: "memberType") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        numBeneficiary = aDecoder.decodeObject(forKey: "numBeneficiary") as? Int
        score = aDecoder.decodeObject(forKey: "score") as? Double
        username = aDecoder.decodeObject(forKey: "username") as? String
        usertype = aDecoder.decodeObject(forKey: "usertype") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if address != nil{
            aCoder.encode(address, forKey: "address")
        }
        if contactNumber != nil{
            aCoder.encode(contactNumber, forKey: "contactNumber")
        }
        if contactPerson != nil{
            aCoder.encode(contactPerson, forKey: "contactPerson")
        }
        if email != nil{
            aCoder.encode(email, forKey: "email")
        }
        if hasTransport != nil{
            aCoder.encode(hasTransport, forKey: "hasTransport")
        }
        if memberType != nil{
            aCoder.encode(memberType, forKey: "memberType")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if numBeneficiary != nil{
            aCoder.encode(numBeneficiary, forKey: "numBeneficiary")
        }
        if score != nil{
            aCoder.encode(score, forKey: "score")
        }
        if username != nil{
            aCoder.encode(username, forKey: "username")
        }
        if usertype != nil{
            aCoder.encode(usertype, forKey: "usertype")
        }
    }
}
