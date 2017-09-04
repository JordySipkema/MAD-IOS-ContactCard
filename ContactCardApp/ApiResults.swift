//
// Results.swift
//
// Created by SwiftyFire on 2017-09-04
// SwiftyFire is a development tool made by Greg Bateman
// It was created to reduce the tedious amount of time required to create
// model classes when using SwiftyJSON to parse JSON in swift
//

class ApiResults {
    var info: Info
    var results: [ResultsElement]
    
    init(json: JSON) {
        self.info = Info(json: json["info"])
        self.results = json["results"].arrayValue.map({ element in
            return ResultsElement(json: element)
        })
    }
    
    class Info {
        var seed: String
        var version: String
        var page: Double
        var results: Double
        
        init(json: JSON) {
            self.seed = json["seed"].stringValue
            self.version = json["version"].stringValue
            self.page = json["page"].doubleValue
            self.results = json["results"].doubleValue
        }
    }
    
    class ResultsElement {
        var cell: String
        var location: Location
        var dob: String
        var nat: String
        var phone: String
        var gender: String
        var name: Name
        var registered: String
        var picture: Picture
        var email: String
        
        init(json: JSON) {
            self.cell = json["cell"].stringValue
            self.location = Location(json: json["location"])
            self.dob = json["dob"].stringValue
            self.nat = json["nat"].stringValue
            self.phone = json["phone"].stringValue
            self.gender = json["gender"].stringValue
            self.name = Name(json: json["name"])
            self.registered = json["registered"].stringValue
            self.picture = Picture(json: json["picture"])
            self.email = json["email"].stringValue
        }
        
        class Location {
            var state: String
            var street: String
            var city: String
            var postcode: Double
            
            init(json: JSON) {
                self.state = json["state"].stringValue
                self.street = json["street"].stringValue
                self.city = json["city"].stringValue
                self.postcode = json["postcode"].doubleValue
            }
        }
        
        class Name {
            var title: String
            var first: String
            var last: String
            
            init(json: JSON) {
                self.title = json["title"].stringValue
                self.first = json["first"].stringValue
                self.last = json["last"].stringValue
            }
        }
        
        class Picture {
            var medium: String
            var thumbnail: String
            var large: String
            
            init(json: JSON) {
                self.medium = json["medium"].stringValue
                self.thumbnail = json["thumbnail"].stringValue
                self.large = json["large"].stringValue
            }
        }
    }
}
