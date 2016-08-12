# AccordionTableViewController

Swift version of https://github.com/klevison/KMAccordionTableViewController

<p align="center">
  <img align="center" src="juLug4JLzx.gif" alt="...">
</p>

## Current Version

Version: 0.0.2

## Under the Hood

* Supports UIViews as sections (UIViews, UIViewController's view, UITableViews, UIWebView, MKMapView, etc...)
* Update content and size of a section
* Custom animation

## How to install it?

[CocoaPods](http://cocoapods.org) is the easiest(iOS8+) way to install AccordionTableViewController. Run ```pod search AccordionTableViewController``` to search for the latest version. Then, copy and paste the ```pod``` line to your ```Podfile```. Your podfile should look like:

```
platform :ios, '8.0'
pod 'AccordionTableViewController'
```

Finally, install it by running ```pod install```.

If you don't use CocoaPods, import the all files from "Classes" directory to your project(iOS7+).

## How to use it?

### Extends from AccordionTableViewController

```swift
import UIKit

class ViewController: AccordionTableViewController {

}
```

### Set `sections` and `delegate` variables

```swift
    override func viewDidLoad() {
        super.viewDidLoad()

        let viewOfSection = UIView(frame: CGRectMake(0, 0, view.frame.size.width, 300))
        viewOfSection.backgroundColor = UIColor.blueColor()
        let section = Section()
        section.view = viewOfSection
        section.title = "Section"

        oneSectionAlwaysOpen = true
        sections =  [section] //how many sections you want
        delegate = self
    }
```

### Customization

Each section has an `appearence` var and it can be customized

```swift
var open = false
var view: UIView?
var overlayView: UIView?
var headerView: SectionHeaderView?
var title: String?
var backgroundColor: UIColor?
var sectionIndex: Int?
var appearence = Appearence()
```

## Contact

If you have any questions comments or suggestions, send me a message. If you find a bug, or want to submit a pull request, let me know.

* klevison@gmail.com
* http://twitter.com/klevison

## Copyright and license

Copyright (c) 2015 Klevison Matias (http://twitter.com/klevison). Code released under [the MIT license](LICENSE).
