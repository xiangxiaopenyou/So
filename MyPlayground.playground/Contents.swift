//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var view = UIView(frame: CGRectMake(0, 0, 100, 100))
view.backgroundColor = UIColor.whiteColor()
var borderLayer = CAShapeLayer()
borderLayer.frame = CGRectMake(0, 0, 100, 100)
borderLayer.lineWidth = 2.0
borderLayer.strokeColor = UIColor.redColor().CGColor
borderLayer.fillColor = UIColor.clearColor().CGColor
borderLayer.lineDashPattern = [4, 4];
borderLayer.path = UIBezierPath(rect: view.bounds).CGPath
view.layer.addSublayer(borderLayer)
view


class GroupSort: NSObject {
    init(sortDictionary: NSDictionary) {
        self.sortDictionary = sortDictionary
    }
    
    private var sortDictionary: NSDictionary!
    
    subscript(key: String) -> AnyObject? {
        get {
            return sortDictionary[key]
        }
        set(newValue) {
            sortDictionary.setValue(newValue, forKey: key)
        }
    }
}

var sort = GroupSort(sortDictionary: ["sort_id" : "1", "sort_name" : "fdafda"])
let id   = sort["sort_id"] as! String
let name = sort["sort_name"] as! String


class DailyMeal
{
    enum GroupSortKey: String {
        case SortId = "sort_id"
        case SortName = "sort_name"
    }
    
    var meals: [GroupSortKey : String] = [:]
}

//var s = GroupSortKey.SortName

var monday = DailyMeal()

monday.meals[.SortName] = "Toast"

if let someMeal = monday.meals[.SortName]
{
    print(someMeal)
}