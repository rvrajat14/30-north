//
//  CoffeGuidVC.swift
//  30 NORTH
//
//  Created by SOWJI on 02/04/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import UIKit
import WebKit
import Charts

class CoffeGuidVC: UIViewController, WKNavigationDelegate{

//    var guideData : ([String], [String])? = nil
//    var pageViewController : UIPageViewController?
//    var currentIndex : Int = 0

    @IBOutlet weak var level1Button: UIButton!
    @IBOutlet weak var level2Button: UIButton!
    @IBOutlet weak var level3Button: UIButton!
    
    @IBOutlet weak var vw2level1Button: UIButton!
    @IBOutlet weak var vw2Level2Button: UIButton!
    @IBOutlet weak var vw2Level3Button: UIButton!
    
    @IBOutlet weak var vw2ResetButton: UIButton!
    @IBOutlet weak var vw2GoButton: UIButton!
    
//    @IBOutlet weak var tastesButton: UIButton!
//    @IBOutlet weak var aromasButton: UIButton!
    @IBOutlet weak var goButton: UIButton!
    
    @IBOutlet weak var mainView1: UIView!
    @IBOutlet weak var mainView2: UIView!
        
    var levelIndex = 1
    var vw2levelIndex = 1

    var chartIndex = 1
    
    // View 1
    var level1SelectedIndex = -1
    var level2SelectedIndex = -1
    var level3SelectedIndex = -1
    
    var level1 = [[String: Any]]()
    var level2 = [[String: Any]]()
    var level3 = [[String: Any]]()

    var fruityLevel2 = [[String: Any]]()

    
    var percent1Array = [Double]()
    var percent2Array = [Double]()
    var percent3Array = [Double]()
    
    // View 2
    var vw2level1SelectedIndex = -1
    var vw2level2SelectedIndex = -1
    var vw2level3SelectedIndex = -1
    
    var vw2level1 = [[String: Any]]()
    var vw2level2 = [[String: Any]]()
    var vw2level3 = [[String: Any]]()

    var vw2percent1Array = [Double]()
    var vw2percent2Array = [Double]()
    var vw2percent3Array = [Double]()
    
    var itemArray = [[String: Any]]()
    var vw2itemArray = [[String: Any]]()

    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var pieChart2: PieChartView!
    
//	@IBOutlet weak var coffeeWebView: WKWebView!
//	@IBOutlet weak var menuButton: UIBarButtonItem!
    
	override func viewDidLoad() {
        super.viewDidLoad()
		//self.view.backgroundColor = UIColor.mainViewBackground

        mainView1.isHidden = false
        mainView2.isHidden = true
        
        loadChartData()
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.navigationController?.navigationBar.topItem?.titleView = setNavbarImage()
		self.showCartButton()
	}
    
    func createItemDictionary(level1Title: String, level2Title: String, level3Title: String, item: String, itemId: Int){
        var dict = [String: Any]()
        dict["level1"] = level1Title
        dict["level2"] = level2Title
        dict["level3"] = level3Title
        dict["item"] = item
        dict["item_id"] = itemId
        if chartIndex == 1{
            itemArray.append(dict)
        }else{
            vw2itemArray.append(dict)
        }
    }
    
    func loadCoffeItem(){
        
        if chartIndex == 1{
        itemArray.removeAll()
        
        createItemDictionary(level1Title: "Nutty / Cocoa", level2Title: "Cocoa", level3Title: "", item: "Colombia Supremo", itemId: 589)
        createItemDictionary(level1Title: "Fruity", level2Title: "Citrus Fruit", level3Title: "Citrus Fruit", item: "Ethiopia (Sidamo)", itemId: 590)
        createItemDictionary(level1Title: "Nutty / Cocoa", level2Title: "", level3Title: "", item: "Brazil (santos)", itemId: 582)
        createItemDictionary(level1Title: "Nutty / Cocoa", level2Title: "Nutty", level3Title: "Hazelnut", item: "Indonesia (flores)", itemId: 591)
        createItemDictionary(level1Title: "Nutty / Cocoa", level2Title: "Cocoa", level3Title: "Dark Chocolate", item: "costa rica (tarazzu SHP)", itemId: 592)
        createItemDictionary(level1Title: "Nutty / Cocoa", level2Title: "Cocoa", level3Title: "Nutty / Cocoa", item: "BraZIL GR1", itemId: 593)
        createItemDictionary(level1Title: "Nutty / Cocoa", level2Title: "Nutty", level3Title: "Almond", item: "Peru moyobamba (typica)", itemId: 594)
        createItemDictionary(level1Title: "Nutty / Cocoa", level2Title: "Cocoa", level3Title: "Chocolate", item: "Guatemala Tenango ( typica)", itemId: 595)
        createItemDictionary(level1Title: "Nutty / Cocoa", level2Title: "Cocoa", level3Title: "Milk Chocolate", item: "Colombia El rauel ( catura)", itemId: 596)
        createItemDictionary(level1Title: "Spices", level2Title: "Brown Spice", level3Title: "Cinnamon", item: "Brazil ( rose diamond)", itemId: 597)
        createItemDictionary(level1Title: "Spices", level2Title: "Pepper", level3Title: "", item: "Tanzania AA ( Bourbon)", itemId: 598)
        createItemDictionary(level1Title: "Fruity", level2Title: "Citrus Fruit", level3Title: "Orange", item: "Costa rica Tarazzu ( Catura)", itemId: 599)
        createItemDictionary(level1Title: "Fruity", level2Title: "Other Fruit", level3Title: "Apricot", item: "Colombia Palo Rosa ( decaf)", itemId: 600)
        createItemDictionary(level1Title: "Fruity", level2Title: "Berry", level3Title: "Blackberry", item: "Peru (Yellow Bourbon)", itemId: 601)
        createItemDictionary(level1Title: "Fruity", level2Title: "Other Fruit", level3Title: "Apple", item: "Colombia samaria", itemId: 602)
        createItemDictionary(level1Title: "Fruity", level2Title: "Other Fruit", level3Title: "", item: "Nicaragua super (maragogipe)", itemId: 603)
        createItemDictionary(level1Title: "Fruity", level2Title: "Berry", level3Title: "Blueberry", item: "Kenya AA (Bourbon) ", itemId: 604)
        createItemDictionary(level1Title: "Fruity", level2Title: "Other Fruit", level3Title: "Pomegranate", item: "Ethiopia (Yirgacheffe)", itemId: 605)
        createItemDictionary(level1Title: "Sweet", level2Title: "Brown Sugar", level3Title: "", item: "india AAA", itemId: 606)
        createItemDictionary(level1Title: "Sweet", level2Title: "Vanilla", level3Title: "", item: "Honduras", itemId: 607)
        createItemDictionary(level1Title: "Sweet", level2Title: "Brown Sugar", level3Title: "Honey", item: "Nicaragua Screen ( catura)", itemId: 608)
        createItemDictionary(level1Title: "Roasted", level2Title: "Burnt", level3Title: "Roast Brown", item: "Mexico (bourbon)", itemId: 609)
        createItemDictionary(level1Title: "Roasted", level2Title: "Pipe Tobacco", level3Title: "", item: "India Monsooned", itemId: 610)
        createItemDictionary(level1Title: "Green / Vegetative", level2Title: "Green / Vegetative", level3Title: "Fresh", item: "Brazil ( grain )", itemId: 611)
        createItemDictionary(level1Title: "Floral", level2Title: "", level3Title: "", item: "Papua New Guinea Sirgi ( typica)", itemId: 612)
        }else{
            vw2itemArray.removeAll()
            
            createItemDictionary(level1Title: "Nutty / Cocoa", level2Title: "Cocoa", level3Title: "", item: "Colombia Supremo", itemId: 589)
            createItemDictionary(level1Title: "Fruity", level2Title: "Citrus Fruit", level3Title: "Citrus Fruit", item: "Ethiopia (Sidamo)", itemId: 590)
            createItemDictionary(level1Title: "Nutty / Cocoa", level2Title: "", level3Title: "", item: "Brazil (santos)", itemId: 582)
            createItemDictionary(level1Title: "Nutty / Cocoa", level2Title: "Nutty", level3Title: "Hazelnut", item: "Indonesia (flores)", itemId: 591)
            createItemDictionary(level1Title: "Nutty / Cocoa", level2Title: "Cocoa", level3Title: "Dark Chocolate", item: "costa rica (tarazzu SHP)", itemId: 592)
            createItemDictionary(level1Title: "Nutty / Cocoa", level2Title: "Cocoa", level3Title: "Nutty / Cocoa", item: "BraZIL GR1", itemId: 593)
            createItemDictionary(level1Title: "Nutty / Cocoa", level2Title: "Nutty", level3Title: "Almond", item: "Peru moyobamba (typica)", itemId: 594)
            createItemDictionary(level1Title: "Nutty / Cocoa", level2Title: "Cocoa", level3Title: "Chocolate", item: "Guatemala Tenango ( typica)", itemId: 595)
            createItemDictionary(level1Title: "Nutty / Cocoa", level2Title: "Cocoa", level3Title: "Milk Chocolate", item: "Colombia El rauel ( catura)", itemId: 596)
            createItemDictionary(level1Title: "Spices", level2Title: "Brown Spice", level3Title: "Cinnamon", item: "Brazil ( rose diamond)", itemId: 597)
            createItemDictionary(level1Title: "Spices", level2Title: "Pepper", level3Title: "", item: "Tanzania AA ( Bourbon)", itemId: 598)
            createItemDictionary(level1Title: "Fruity", level2Title: "Citrus Fruit", level3Title: "Orange", item: "Costa rica Tarazzu ( Catura)", itemId: 599)
            createItemDictionary(level1Title: "Fruity", level2Title: "Other Fruit", level3Title: "Apricot", item: "Colombia Palo Rosa ( decaf)", itemId: 600)
            createItemDictionary(level1Title: "Fruity", level2Title: "Berry", level3Title: "Blackberry", item: "Peru (Yellow Bourbon)", itemId: 601)
            createItemDictionary(level1Title: "Fruity", level2Title: "Other Fruit", level3Title: "Apple", item: "Colombia samaria", itemId: 602)
            createItemDictionary(level1Title: "Fruity", level2Title: "Other Fruit", level3Title: "", item: "Nicaragua super (maragogipe)", itemId: 603)
            createItemDictionary(level1Title: "Fruity", level2Title: "Berry", level3Title: "Blueberry", item: "Kenya AA (Bourbon) ", itemId: 604)
            createItemDictionary(level1Title: "Fruity", level2Title: "Other Fruit", level3Title: "Pomegranate", item: "Ethiopia (Yirgacheffe)", itemId: 605)
            createItemDictionary(level1Title: "Sweet", level2Title: "Brown Sugar", level3Title: "", item: "india AAA", itemId: 606)
            createItemDictionary(level1Title: "Sweet", level2Title: "Vanilla", level3Title: "", item: "Honduras", itemId: 607)
            createItemDictionary(level1Title: "Sweet", level2Title: "Brown Sugar", level3Title: "Honey", item: "Nicaragua Screen ( catura)", itemId: 608)
            createItemDictionary(level1Title: "Roasted", level2Title: "Burnt", level3Title: "Roast Brown", item: "Mexico (bourbon)", itemId: 609)
            createItemDictionary(level1Title: "Roasted", level2Title: "Pipe Tobacco", level3Title: "", item: "India Monsooned", itemId: 610)
            createItemDictionary(level1Title: "Green / Vegetative", level2Title: "Green / Vegetative", level3Title: "Fresh", item: "Brazil ( grain )", itemId: 611)
            createItemDictionary(level1Title: "Floral", level2Title: "", level3Title: "", item: "Papua New Guinea Sirgi ( typica)", itemId: 612)
        }
    }
    
    func loadChartData(){
        setupInitialDataForTastesAndAromas()
        loadCoffeItem()
        setupChart()
    }
    
    func createDictionary(levelArray: inout [[String: Any]], title: String, color : UIColor){
        var dict = [String: Any]()
        dict["title"] = title
        dict["color"] = color
        levelArray.append(dict)
    }
    func createLevel2Dictionary(title: String, color : UIColor) -> [String: Any]{
         var dict = [String: Any]()
         dict["title"] = title
         dict["color"] = color
         return dict
     }
     
    func setupInitialDataForTastesAndAromas(){
        
        var mainArray: [[String: Any]]?
        if chartIndex == 1{
        if let path = Bundle.main.path(forResource: "Tastes", ofType: "plist") {
            mainArray = NSArray(contentsOfFile: path) as! [[String : Any]]
           //print("mainArray : ", mainArray)
        }
        
        level1 = mainArray!
        }else{
            if let path = Bundle.main.path(forResource: "Aromas", ofType: "plist") {
                mainArray = NSArray(contentsOfFile: path) as! [[String : Any]]
               //print("mainArray : ", mainArray)
            }
            
            vw2level1 = mainArray!

        }
    }
    
    func chart(pie : PieChartView){
        pie.delegate = self
        pie.drawHoleEnabled = true
        pie.rotationAngle = 0
        pie.rotationEnabled = true
        pie.highlightPerTapEnabled = true
        pie.backgroundColor = UIColor.mainViewBackground
        pie.usePercentValuesEnabled = false
    }
    
    func setupChart(){
        
        if chartIndex == 1{
            chart(pie: pieChart)
            updateChartData(contentArray: level1)
        }else{
            chart(pie: pieChart2)
            vw2updateChartData(contentArray: vw2level1)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func filterItems(l1Title: String, l2Title: String, l3Title: String) -> [[String: Any]]{
        
        var selectedItemArray = [[String: Any]]()
        
        for item in itemArray{
            let level1Title = item["level1"] as! String
            let level2Title = item["level2"] as! String
            let level3Title = item["level3"] as! String
            
            if levelIndex == 2{
            if level1Title == l1Title{
                selectedItemArray.append(item)
            }
            }else if levelIndex == 3{
                if level1Title == l1Title && level2Title == l2Title{
                    selectedItemArray.append(item)
                }
            }else if levelIndex == 4{
                if level1Title == l1Title && level2Title == l2Title && level3Title == l3Title{
                    selectedItemArray.append(item)
                }
            }
        }
        return selectedItemArray
    }
    func vw2filterItems(l1Title: String, l2Title: String, l3Title: String) -> [[String: Any]]{
        
        var selectedItemArray = [[String: Any]]()
        
        for item in vw2itemArray{
            let level1Title = item["level1"] as! String
            let level2Title = item["level2"] as! String
            let level3Title = item["level3"] as! String
            
            if vw2levelIndex == 2{
            if level1Title == l1Title{
                selectedItemArray.append(item)
            }
            }else if vw2levelIndex == 3{
                if level1Title == l1Title && level2Title == l2Title{
                    selectedItemArray.append(item)
                }
            }else if vw2levelIndex == 4{
                if level1Title == l1Title && level2Title == l2Title && level3Title == l3Title{
                    selectedItemArray.append(item)
                }
            }
        }
        return selectedItemArray
    }
    
    func getLevelTitles() -> (String, String, String){
        let dict1 = level1[level1SelectedIndex]
        let l1Title = dict1["title"] as! String

        var l2Title = ""
        var l3Title = ""

        if level2SelectedIndex >= 0{
            let dict2 = level2[level2SelectedIndex]
            l2Title = dict2["title"] as! String
        }

        if level3SelectedIndex >= 0{
            let dict3 = level3[level3SelectedIndex]
            l3Title = dict3["title"] as! String
        }
        return (l1Title, l2Title, l3Title)
    }
    func vw2getLevelTitles() -> (String, String, String){
        let dict1 = vw2level1[vw2level1SelectedIndex]
        let l1Title = dict1["title"] as! String

        var l2Title = ""
        var l3Title = ""

        if vw2level2SelectedIndex >= 0{
            let dict2 = vw2level2[vw2level2SelectedIndex]
            l2Title = dict2["title"] as! String
        }

        if vw2level3SelectedIndex >= 0{
            let dict3 = vw2level3[vw2level3SelectedIndex]
            l3Title = dict3["title"] as! String
        }
        return (l1Title, l2Title, l3Title)
    }
    @IBAction func onGo(_ sender: Any) {
        
        if chartIndex == 1{
            getFilterItemData()
        }
        else{
            vw2getFilterItemData()
        }
    }
    
    func getFilterItemData(){
        let (l1Title, l2Title, l3Title) = getLevelTitles()
       print("Selected:\n titles1: \(l1Title) titles2: \(l2Title) titles3: \(l3Title)")
        
        let selectedItems = filterItems(l1Title: l1Title, l2Title: l2Title, l3Title: l3Title)
       print("selectedItems : ",selectedItems)
		self.openCoffeeRecommendation(items: selectedItems)

		/*let itemVC = self.storyboard?.instantiateViewController(withIdentifier: "ItemsViewController") as! ItemsViewController
        itemVC.selectedItemsArray = selectedItems
        self.navigationController?.pushViewController(itemVC, animated: true)*/
    }

    func vw2getFilterItemData(){
	   let (l1Title, l2Title, l3Title) = vw2getLevelTitles()
	  print("Selected:\ntitles1: \(l1Title) titles2: \(l2Title) titles3: \(l3Title)")

	   let selectedItems = vw2filterItems(l1Title: l1Title, l2Title: l2Title, l3Title: l3Title)
	  print("selectedItems : ",selectedItems)

		self.openCoffeeRecommendation(items: selectedItems)
	   /*let itemVC = self.storyboard?.instantiateViewController(withIdentifier: "ItemsViewController") as! ItemsViewController
	   itemVC.selectedItemsArray = selectedItems
	   self.navigationController?.pushViewController(itemVC, animated: true)*/
   }

	func openCoffeeRecommendation(items:[[String:Any]]) {
		let coffeeRecommendationVC = self.storyboard?.instantiateViewController(identifier: "CoffeeRecommendationViewController") as? CoffeeRecommendationViewController
		coffeeRecommendationVC?.selectedItems = items
		self.navigationController?.pushViewController(coffeeRecommendationVC!, animated: true)
	}

    @IBAction func onLevel1Button(_ sender: Any) {
        
        if chartIndex == 1{
            level1SelectedIndex = -1
            level2SelectedIndex = -1
            level3SelectedIndex = -1
            
            levelIndex = 1
            level1Button.isHidden = true
            level2Button.isHidden = true
            updateChartData(contentArray: level1)
        }else{
            vw2level1SelectedIndex = -1
            vw2level2SelectedIndex = -1
            vw2level3SelectedIndex = -1
            
            vw2levelIndex = 1
            vw2level1Button.isHidden = true
            vw2Level2Button.isHidden = true
            vw2updateChartData(contentArray: vw2level1)
        }
    }
    @IBAction func onLevel2Button(_ sender: Any) {
        
        if chartIndex == 1{
            level2SelectedIndex = -1
            level3SelectedIndex = -1
            
            levelIndex = 2
            level1Button.isHidden = false
            level2Button.isHidden = true
            updateChartData(contentArray: level2)
        }else{
            vw2level2SelectedIndex = -1
            vw2level3SelectedIndex = -1
            
            vw2levelIndex = 2
            vw2level1Button.isHidden = false
            vw2Level2Button.isHidden = true
            vw2updateChartData(contentArray: vw2level2)
        }
    }
    @IBAction func onLevel3Button(_ sender: Any) {
        
    }
    
    @IBAction func onReset(_ sender: Any) {
        if chartIndex == 1{
            
            level1SelectedIndex = -1
            level2SelectedIndex = -1
            level3SelectedIndex = -1
            
            levelIndex = 1
            level1Button.isHidden = true
            level2Button.isHidden = true
            updateChartData(contentArray: level1)
        }else{
            vw2level1SelectedIndex = -1
            vw2level2SelectedIndex = -1
            vw2level3SelectedIndex = -1
            
            vw2levelIndex = 1
            vw2level1Button.isHidden = true
            vw2Level2Button.isHidden = true
            vw2updateChartData(contentArray: vw2level1)
            
        }
    }
    @IBAction func onAromas(_ sender: Any) {
//        
//        aromasButton.setTitleColor(.white, for: .normal)
//        aromasButton.backgroundColor = goldColor
//        tastesButton.setTitleColor(.darkGray, for: .normal)
//        tastesButton.backgroundColor = .lightGray
    }
    
    @IBAction func onTastes(_ sender: Any) {
//        
//        aromasButton.setTitleColor(.darkGray, for: .normal)
//        aromasButton.backgroundColor = .lightGray
//        tastesButton.setTitleColor(.white, for: .normal)
//        tastesButton.backgroundColor = goldColor
    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onSwitch(_ sender: UISwitch) {
       //print(sender.isOn)
        if sender.isOn{
            chartIndex = 2
            mainView1.isHidden = true
            mainView2.isHidden = false
        }else{
            chartIndex = 1
            mainView1.isHidden = false
            mainView2.isHidden = true
        }
        loadChartData()
    }

    
    func getColor(color: String) -> UIColor{
        
        switch color {
        case "red":
            return UIColor.red
        case "green":
            return UIColor.green
        case "orange":
            return UIColor.orange
        case "purple":
            return UIColor.purple
        case "blue":
            return UIColor.blue
        case "cyan":
            return UIColor.cyan
        case "gray":
            return UIColor.gray
            
        default:
            break
        }
        return UIColor.red
    }

    func updateChartData(contentArray: [[String: Any]])  {

        if levelIndex == 1{
            level1Button.isHidden = true
            level2Button.isHidden = true
            level3Button.isHidden = true
            goButton.isHidden = true
        }else{
            goButton.isHidden = false
        }
//        chart.frame = pieChart.frame
        pieChart.entryLabelColor = .white
        pieChart.entryLabelFont = .systemFont(ofSize: 12, weight: .bold)

        let track = contentArray

        var entries = [PieChartDataEntry]()
        for (index, value) in contentArray.enumerated() {
            let entry = PieChartDataEntry()
            entry.y = Double(100 / contentArray.count)
            let dict = track[index]
            let text = dict["title"] as! String
            entry.label = text
            entries.append( entry)
        }

        // 3. chart setup
        let set = PieChartDataSet(entries: entries, label: "Coffee Guide")
        // this is custom extension method. Download the code for more details.
        var colors: [UIColor] = []

        for i in 0..<contentArray.count {
            let dict = track[i]
            let color = dict["color"] as! String
            let uiColor = getColor(color: color)
            colors.append(uiColor)
        }
        set.colors = colors
        set.drawValuesEnabled = false

        let data = PieChartData(dataSet: set)
        set.sliceSpace = 0
        data.setValueTextColor(.white)
        let font = UIFont.systemFont(ofSize: 12, weight: .bold)
        data.setValueFont(font)
        pieChart.data = data
        pieChart.noDataText = "No data available"
        pieChart.isUserInteractionEnabled = true

        let d = Description()
        d.text = ""
        pieChart.chartDescription = d
        let centerTextfont = UIFont.systemFont(ofSize: 15, weight: .bold)
        let myAttribute = [ NSAttributedString.Key.font: centerTextfont]
        let myAttrString = NSAttributedString(string: "Coffee Guide", attributes: myAttribute)

        pieChart.centerAttributedText = myAttrString
        pieChart.transparentCircleRadiusPercent = 0.48
        pieChart.holeRadiusPercent = 0.45
        pieChart.drawSlicesUnderHoleEnabled = false
        pieChart.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
    }
    
    // View 2 Pie Chart
    func vw2updateChartData(contentArray: [[String: Any]])  {

            if vw2levelIndex == 1{
                vw2level1Button.isHidden = true
                vw2Level2Button.isHidden = true
                vw2Level3Button.isHidden = true
                vw2GoButton.isHidden = true
            }else{
                vw2GoButton.isHidden = false
            }

            pieChart2.entryLabelColor = .white
            pieChart2.entryLabelFont = .systemFont(ofSize: 12, weight: .bold)

            let track = contentArray

            var entries = [PieChartDataEntry]()
            for (index, value) in contentArray.enumerated() {
                let entry = PieChartDataEntry()
                entry.y = Double(100 / contentArray.count)
                let dict = track[index]
                let text = dict["title"] as! String
                entry.label = text
                entries.append( entry)
            }

            // 3. chart setup
            let set = PieChartDataSet(entries: entries, label: "Coffee Guide")
            // this is custom extension method. Download the code for more details.
            var colors: [UIColor] = []

            for i in 0..<contentArray.count {
                let dict = track[i]
                let color = dict["color"] as! String
                let uiColor = getColor(color: color)
                colors.append(uiColor)
            }
            set.colors = colors
            set.drawValuesEnabled = false

            let data = PieChartData(dataSet: set)
            set.sliceSpace = 0
            data.setValueTextColor(.white)
            let font = UIFont.systemFont(ofSize: 12, weight: .bold)
            data.setValueFont(font)
            pieChart2.data = data
            pieChart2.noDataText = "No data available"
            pieChart2.isUserInteractionEnabled = true

            let d = Description()
            d.text = ""
            pieChart2.chartDescription = d
            let centerTextfont = UIFont.systemFont(ofSize: 15, weight: .bold)
            let myAttribute = [ NSAttributedString.Key.font: centerTextfont]
            let myAttrString = NSAttributedString(string: "Coffee Guide", attributes: myAttribute)

            pieChart2.centerAttributedText = myAttrString
            pieChart2.transparentCircleRadiusPercent = 0.48
            pieChart2.holeRadiusPercent = 0.45
            pieChart2.drawSlicesUnderHoleEnabled = false
            pieChart2.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        }
}

extension CoffeGuidVC: ChartViewDelegate {
  func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
   //print("chartValueSelected", entry.x, entry.y, highlight.x);
    let index = Int(highlight.x)
    
    if chartIndex == 1{
        if levelIndex == 1{
            level1SelectedIndex = index
            levelIndex = 2
            level1Button.isHidden = false
            level2Button.isHidden = true
            level3Button.isHidden = true
            
            let dict = level1[index]
            let text = dict["title"] as! String
            level1Button.setTitle(text, for: .normal)
            
            level2 = dict["level2"] as? [[String: Any]] ?? []
            
            if level2.count > 0{
                updateChartData(contentArray: level2)
            }else{
                getFilterItemData()
            }
            
        }else if levelIndex == 2{
            level2SelectedIndex = index
            levelIndex = 3
            level1Button.isHidden = false
            level2Button.isHidden = false
            level3Button.isHidden = true
            
            let dict = level2[index]
            let text = dict["title"] as! String
            level2Button.setTitle(text, for: .normal)
            
            level3 = dict["level3"] as? [[String: Any]] ?? []
            if level3.count > 0{
                updateChartData(contentArray: level3)
            }else{
                getFilterItemData()
            }

        }else if levelIndex == 3{
            levelIndex = 4
            level3SelectedIndex = index
            level1Button.isHidden = false
            level2Button.isHidden = false
            level3Button.isHidden = false
            let dict = level3[index]
            let text = dict["title"] as! String
            level3Button.setTitle(text, for: .normal)
            
            getFilterItemData()
        }
    }else{
        if vw2levelIndex == 1{
            vw2level1SelectedIndex = index
            vw2levelIndex = 2
            vw2level1Button.isHidden = false
            vw2Level2Button.isHidden = true
            vw2Level3Button.isHidden = true
            
            let dict = vw2level1[index]
            let text = dict["title"] as! String
            vw2level1Button.setTitle(text, for: .normal)
            
            vw2level2 = dict["level2"] as? [[String: Any]] ?? []
            
            if vw2level2.count > 0{
                vw2updateChartData(contentArray: vw2level2)
            }else{
                vw2getFilterItemData()
            }


        }else if vw2levelIndex == 2{
            vw2level2SelectedIndex = index
            vw2levelIndex = 3
            vw2level1Button.isHidden = false
            vw2Level2Button.isHidden = false
            vw2Level3Button.isHidden = true

            let dict = vw2level2[index]
            let text = dict["title"] as! String
            vw2Level2Button.setTitle(text, for: .normal)
            
            vw2level3 = dict["level3"] as? [[String: Any]] ?? []
            
            if vw2level3.count > 0{
                vw2updateChartData(contentArray: vw2level3)
            }else{
                vw2getFilterItemData()
            }

        }else if vw2levelIndex == 3{
            vw2levelIndex = 4
            vw2level3SelectedIndex = index
            vw2level1Button.isHidden = false
            vw2Level2Button.isHidden = false
            vw2Level3Button.isHidden = false
            let dict = vw2level3[index]
            let text = dict["title"] as! String
            vw2Level3Button.setTitle(text, for: .normal)

            vw2getFilterItemData()
        }
    }

    
}
  
  func chartValueNothingSelected(_ chartView: ChartViewBase) {
      NSLog("chartValueNothingSelected");
  }
  
  func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
      
  }
  
  func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
      
  }
}
