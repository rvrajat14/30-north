//
//  BrewingPagesVC.swift
//  30 NORTH
//
//  Created by SOWJI on 24/03/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import UIKit

class BrewingPagesVC: UIViewController {
   
    var methodIndex = 0
    var pageData : ([String],[String],[String],[(Bool,Int,Int,Int,String,Int,Int, Int)],[(Bool,Int,String, String)], [String])? = nil
    var pageViewController : UIPageViewController?
    var currentIndex : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

		self.view.backgroundColor = UIColor.mainViewBackground
        self.pageData = self.getPagesData()

        pageData = self.getPagesData()

        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController!.dataSource = self
        let startingViewController: BrewingPage = viewControllerAtIndex(index: 0)!
        let viewControllers = [startingViewController]
        pageViewController!.setViewControllers(viewControllers , direction: .forward, animated: false, completion: nil)
        pageViewController!.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height);
        let appearance = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
        appearance.pageIndicatorTintColor = UIColor.white
        appearance.currentPageIndicatorTintColor = UIColor.red
        appearance.backgroundColor = UIColor.clear
        addChild(pageViewController!)
        view.addSubview(pageViewController!.view)
        pageViewController!.didMove(toParent: self)
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.showCartButton()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

	deinit {
		self.pageViewController = nil
	}

    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
	func getPagesData() -> ([String],[String],[String],[(Bool,Int,Int,Int,String,Int,Int, Int)],[(Bool,Int,String, String)], [String]) {
        let pages : ([String],[String],[String],[(Bool,Int,Int,Int,String,Int,Int, Int)],[(Bool,Int,String, String)], [String])
        switch self.methodIndex {
        case 0:
            //print("YIELD : ",YIELD)
            pages = createPages1()
        case 1:
            pages = createPages2()
        case 2:
            pages = createPages3()
        case 3:
            pages = createPages4()
        case 4:
            pages = createPages5()
        case 5:
            pages = createPages6()
        case 6:
            pages = createPages7()
        case 7:
            pages = createPages8()
        case 8:
            pages = createPages9()
        case 9:
            pages = createPages10()
        case 10:
            pages = createPages11()
        default:
            pages = createPages12()
        }
        return pages
    }
    
   /*  returns Array of page titles, descriptions , images , isConvertShouldBeShown , (isTimerShouldBeShown,with time in seconds)
     Here we are passing 5 parameteres
     1 - array of page titles
     2 - array of page Description
     3 - array of page Images
     4 - array of Converter related Data which are
          isConverterShown - whether to show converter or not
          ConverterType - 1 (Grams to ML conversion)
          minimumvalue - Slider Minimumvalue
          maximumValue - Slider Maximumvalue
          text - Data displayed after widget

     5 - array of Timer related Data which are
          isTimerShown - whether to show converter or not
          TimerValue - How many Seconds timer should run
          text - Data displayed after widget
     */

    func createPages1() -> ([String],[String],[String],[(Bool,Int,Int,Int,String,Int,Int, Int)],[(Bool,Int,String, String)], [String]) {
        
        YIELD = 240 // Default values if user does not alter slider and when page loads
        YIELD12P5 = Int(Float(YIELD)*12.5)/100
        YIELDRM1 = YIELD-((YIELD*Int(12.5))/100)
        
        let pageTitles = ["PREPARE","Bloom","POUR & BREW","PRESS"]
        let pageImages = ["Cover-Image","Cover-Image","Cover-Image","Cover-Image"]
        let page1String = """
        Heat water to around 80\u{2103}
        \n
        Weigh 12 to 16 grams of coffee, then grind to medium/fine coarseness. Then record the weight below
        \n
        """
        let timerText = """
        This step allows the grounds to saturate with water, forcing out gases and priming the coffee for the brewing process.
        """
        let converterText = """
        Insert the plunger about 1cm into the brew chamber and set on the scale in the inverted/upside-down position. Add the ground coffee to the Aeropress and shake it to level the grounds. Then zero the scale
        """
        let page2String = """
        Start the timer below, then pour __(YIELD12P5)__ grams of water over the coffee in the Aeropress. Stir the grounds to saturate the coffee
        """
        let page3String = """
        Start the timer below, then quickly pour up to __(YIELDRM1)__ grams of water over the grounds.
        """
        let timer2Text = """
        While the coffee is brewing, insert the AeroPress disc paper filter into the cap and pour a few ounces of hot water through it to rinse the filter. After rinsing, twist and lock the cap into place on the brewer.
        """
        let page4String = """
        Carefully flip the entire brew onto a carafe or mug. Firmly, but gently press down for 30 seconds, until all of the coffee has been pressed out of the Aeropress.

        Remove the cap and pop the used grounds into the trash.

        Swirl the coffee in the carafe and smell the delicious aroma. Grab your favourite mug and enjoy your AeroPress!
        """
        
        let pageDesc = [page1String,page2String,page3String,page4String]
		let step = 15
        let converterData = [(true,1,15,120,converterText,240,16,step),(false,0,0,0,"",0,0, 0),(false,0,0,0,"",0,0, 0),(false,0,0,0,"",0,0, 0)]
        let timerData = [(false,0,"", ""),(true,45,timerText, "Notification Text"),(true,120,timer2Text, "Notification Text"),(false,0,"", "")]

		let videos = ["https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4"]
        
        //let videos = [""]
        
        return (pageTitles,pageDesc,pageImages,converterData,timerData, videos)
    }
    func createPages2() -> ([String],[String],[String],[(Bool,Int,Int,Int,String,Int,Int, Int)],[(Bool,Int,String, String)], [String]) {
        
        YIELD = 340 // Default values if user does not alter slider and when page loads
        YIELD12P5 = ((YIELD*15)/100)
        YIELDRM1 = YIELD-(YIELD*15)/100
        
        let pageTitles = ["PREPARE & PREHEAT","WEIGH & GRIND","BLOOM","BREW","ENJOY"]
        let pageImages = ["Cover-Image","Cover-Image","Cover-Image","Cover-Image","Cover-Image"]
        let page1String = """
        Rinse the filter with hot water to get an even seal all the way around to wash and preheat the filter and brewer. Dump the rinse water
        \n
        """
        let timerText = """
        Once the drips stall to every couple of seconds, your brew is finished
        \n
        """
        let converterText = """
        Grind beans to a medium coarseness
        """
        let page2String = """
        Place a filter in the Chemex with multiple folds lined up against the spout then place the Chemex on the scale
        \nPour the ground coffee in the Chemex and tare the scale
        """
        let page3String = """
        Pour __(YIELD12P5)__ grams of boiling water over the grounds. Then start the timer and let the coffee bloom
        """
        let timer2Text = """
        While the coffee is brewing, insert the AeroPress disc paper filter into the cap and pour a few ounces of hot water through it to rinse the filter. After rinsing, twist and lock the cap into place on the brewer.
        """
        let page4String = """
        Pour the remaining __(YIELDRM1)__ grams of water over the grounds in a slow, steady circular motion and start the timer to brew the coffee
        """
        let page5String = """
        Pour the coffee from your Chemex and enjoy!
        """

		let videos = ["https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4"]
        
        //let videos = [""]

        let pageDesc = [page1String,page2String,page3String,page4String,page5String]
		let step = 25
        let converterData = [(false,0,0,0,"",0,0, 0),(true,1,25,200,converterText,340,15, step),(false,0,0,0,"",0,0, 0),(false,0,0,0,"",0,0, 0),(false,0,0,0,"",0,0, 0)]
        let timerData = [(false,45,"", ""),(false,0,"", ""),(true,45,"","YOUR COFFEE HAS BLOOMED"),(true,270,timerText, "YOUR COFFEE HAS BREWED"),(false,0,"", "")]
        //        let bgColors = [ UIColor.black, UIColor.black, UIColor.black, UIColor.black]
        
        return (pageTitles,pageDesc,pageImages,converterData,timerData, videos)
    }
    func createPages3() -> ([String],[String],[String],[(Bool,Int,Int,Int,String,Int,Int, Int)],[(Bool,Int,String, String)], [String]) {
            
            YIELD = 245 // Default values if user does not alter slider and when page loads
            YIELD12P5 = ((YIELD*20)/100)
            YIELDRM1 = YIELD-(YIELD*20)/100
            
            let pageTitles = ["WEIGH & GRIND","ADD WATER","BREW","ENJOY"]
            let pageImages = ["Cover-Image","Cover-Image","Cover-Image","Cover-Image"]
            let page1String = """
            Pour coarsely ground coffee into the jar. Use the slider below to calculate the amount of water you need based on the number of cups you're going to brew
            """
            let page2String = """
            Add the water and stir. Cover the jar
            \n
            """
            let page3String = """
            Let it rest for 12-18 hours in the fridge
            \n
            """
            let page4String = """
            Filter the cold brew using filter paper and pour the filtered coffee
            \n
            Enjoy your cold refreshing brew!
            """


            let videos = ["https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4"]
        
            let pageDesc = [page1String,page2String,page3String,page4String]
            let step = 35
            let converterData = [(true,1,35,304,"",245,7, step),(false,1,2,13,"",0,0, step),(false,1,2,13,"",0,0, step),(false,1,2,13,"",0,0, step)]
            let timerData = [(false,45,"", ""),(false,0,"", ""),(false,0,"", ""),(false,0,"", "")]
            //        let bgColors = [ UIColor.black, UIColor.black, UIColor.black, UIColor.black]
            
            //let videos = [""]

            return (pageTitles,pageDesc,pageImages,converterData,timerData, videos)
        }
    func createPages4() -> ([String],[String],[String],[(Bool,Int,Int,Int,String,Int,Int, Int)],[(Bool,Int,String, String)], [String]) {
        
        YIELD = 350 // Default values if user does not alter slider and when page loads
        YIELD12P5 = ((YIELD*17)/100)
        YIELDRM1 = YIELD-(YIELD*17)/100

        let pageTitles = ["WEIGH & GRIND","BLOOM","BREW","PRESS & ENJOY"]
        let pageImages = ["Cover-Image","Cover-Image","Cover-Image","Cover-Image","Cover-Image"]
        let page1String = """
        Weigh out your coffee and use the slider below to calculate the amount of water based on the number of cups you will be brewing
        """
        let timerText = """
        While the coffee sits, it will form a crust on top of the water. Stir the coffee to equally extract the coffee from the grounds
        \n
        """
        let converterText = """
        Pour the beans in your grinder, and grind to the coarsest consistency
        \n
        """
        let page2String = """
        Pour __(YIELD12P5)__ grams of water over the grounds. Then start the timer to let the coffe bloom
        """
        let page3String = """
        Pour the remaining __(YIELDRM1)__ grams of water over the grounds and cover the French Press with the plunger up. Use the timer to monitor brewing
        """
        let page4String = """
        Plunge the French Press filter through the coffee slowly and pour the coffee into cups while holding the filter down. For best results, don't let the coffee sit in the French Press longer than 5 minutes
        """
        
        let pageDesc = [page1String,page2String,page3String,page4String]
		let step = 30
        let converterData = [(true,1,30,240,converterText,350,12, step),(false,0,0,0,"",0,0, 0),(false,0,0,0,"",0,0, 0),(false,0,0,0,"",0,0,0),(false,0,0,0,"",0,0,0)]
        let timerData = [(false,45,timerText, "Notification Text"),(true,45,timerText, "YOUR COFFEE HAS BLOOMED"),(true,300,"","YOUR COFFFEE HAS BREWED"),(false,0,"", ""),(false,0,"", "")]
        //        let bgColors = [ UIColor.black, UIColor.black, UIColor.black, UIColor.black]

        let videos = ["https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4"]
        
        //let videos = [""]

        return (pageTitles,pageDesc,pageImages,converterData,timerData, videos)
    }
    func createPages5() -> ([String],[String],[String],[(Bool,Int,Int,Int,String,Int,Int, Int)],[(Bool,Int,String, String)], [String]) {
        
        YIELD = 245 // Default values if user does not alter slider and when page loads
        YIELD12P5 = ((YIELD*20)/100)
        YIELDRM1 = YIELD-(YIELD*20)/100
        
        let pageTitles = ["WEIGH & GRIND","ADD WATER","BREW","FILTER","BLAST IT"]
        let pageImages = ["Cover-Image","Cover-Image","Cover-Image","Cover-Image","Cover-Image"]
        let page1String = """
        Pour your coarsely ground coffee into the jar
        \n
        Use the slider below to calculate the amount of water you need based on the number of cups you're going to brew
        """
        let page2String = """
        \n
        Add the water and stir. Cover the jar
        \n
        """
        let page3String = """
        Let it rest for 12-18 hours in the fridge
        \n
        """
        let page4String = """
        Filter the cold brew using filter paper and pour the filtered coffee into the chamber of your nitro maker & close the lid
        """
        let page5String = """
        Attach the N2O cartridge & shake it
        \n
        Angle the nitro maker sideways or completely down to make sure the coffee gets charged. Pull the trigger and enjoy!
        \n
        """
        
        let pageDesc = [page1String,page2String,page3String,page4String,page5String]
		let step = 35
        let converterData = [(true,1,35,304,"",245,7, step),(false,1,2,13,"",0,0, step),(false,1,2,13,"",0,0, step),(false,1,2,13,"",0,0, step),(false,1,2,13,"",0,0, step)]
        let timerData = [(false,45,"", ""),(false,0,"", ""),(false,0,"", ""),(false,0,"", ""),(false,0,"", "")]
        //        let bgColors = [ UIColor.black, UIColor.black, UIColor.black, UIColor.black]

        let videos = ["https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4"]
        
        //let videos = [""]

        return (pageTitles,pageDesc,pageImages,converterData,timerData, videos)
    }
    func createPages6() -> ([String],[String],[String],[(Bool,Int,Int,Int,String,Int,Int, Int)],[(Bool,Int,String, String)], [String]) {
        
        YIELD = 255 // Default values if user does not alter slider and when page loads
        YIELD12P5 = ((YIELD*20)/100)
        YIELDRM1 = YIELD-(YIELD*20)/100
        
        let pageTitles = ["WEIGH & GRIND","ADD GROUNDS","BLOOM","POUR OVER"]
        let pageImages = ["Cover-Image","Cover-Image","Cover-Image","Cover-Image"]
        let page1String = """
        Weigh out your coffee based on the number of cups you will brew using the slider below, then set the ground coffee aside
        \n
        """
        let page2String = """
        Place the filter in the brewer, add the beans and saturate them with __(YIELD12P5)__ grams of water
        """
        let page3String = """
        Pour __(YIELDRM1)__ grams of nearly boiling water over the grounds. Then start the timer while the coffee blooms
        \n
        """
        let page4String = """
        Start the timer, then pour the remaining __(YIELDRM1)__ of water over the coffee
        \n
        """
        
        let pageDesc = [page1String,page2String,page3String,page4String]
		let step = 15
        let converterData = [(true,1,15,120,"",255,17, step),(false,1,2,13,"",0,0, 0),(false,0,0,0,"",0,0, 0),(false,0,0,0,"",0,0,0)]
        let timerData = [(false,0,"", ""),(false,0,"", ""),(true,45,"", "YOUR COFFEE HAS BLOOMED"),(true,300,"", "YOUR COFFEE HAS BREWED")]
        //        let bgColors = [ UIColor.black, UIColor.black, UIColor.black, UIColor.black]

        let videos = ["https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4"]
        
        //let videos = [""]

        return (pageTitles,pageDesc,pageImages,converterData,timerData, videos)
    }
	func createPages7() -> ([String],[String],[String],[(Bool,Int,Int,Int,String,Int,Int, Int)],[(Bool,Int,String, String)], [String]) {
        
        YIELD = 300
        
        let pageTitles = ["PREPARE","ADD WATER","ASSEMBLE","GRIND","BOIL","HEAT CONTROL","SUBMERGE","BREW","SHAKE","ENJOY"]
        let pageImages = ["Cover-Image","Cover-Image","Cover-Image","Cover-Image","Cover-Image","Cover-Image","Cover-Image","Cover-Image","Cover-Image","Cover-Image"]
        let page1String = """
        Soak your filter in a warm water bath for at least 5 minutes then drop it into the bottom of your Syphon’s hopper and hook to the bottom of the hopper’s glass tubing. Use the timer below to time the soaking process
        \n
        """
        let page2String = """
        Fill the Syphon’s bulb with 300 grams of hot water for every cup. Use the converter below to get the proportions right
        \n
        """
        let page3String = """
        Insert the hopper, with filter, into the bulb. You don't have to press too hard; just make sure it's securely and evenly in place. Position the entire assembly above your heat source
        \n
        """
        let page4String = """
        While the water heats, grind your coffee to a consistency that's just a bit finer than you would for drip coffee
        \n
        """
        let page5String = """
        The water in the bulb will begin to boil and rise up into the hopper. Some water will stay in the bottom. Don’t worry about those remnants
        \n
        """
        let page6String = """
        Once the water has moved into the hopper, turn your heat source down so that the water is between 85-90 \u{2103}
        \n
        """
        let page7String = """
        Add your coffee, and gently (but thoroughly) submerge it with a bamboo paddle or butter knife
        \n
        """
        let page8String = """
        Let the coffee brew, undisturbed, for one minute and 10 seconds
        \n
        """
        let page9String = """
        In one brisk motion, remove your siphon from its heat source and give it ten stirs with a bamboo paddle.
        \n
        """
        let page10String = """
        Your coffee should take another minute or so to draw downward and finally rest in the bulb. You'll know it's ready when a dome of grounds has formed at the top of the filter, and when the coffee at the bottom has begun to bubble
        \n
        Remove the hopper and serve. In order to guarantee the most complex cup, give the coffee a few minutes to cool.
        \n
        """
        
        let timerText = """
        \u{2022} Coffee is a brewed drink prepared from roasted coffee beans, the seeds of berries from certain Coffea species.
        \u{2022}  The genus Coffea is native to tropical Africa and Madagascar, the Comoros, Mauritius, and Réunion in the Indian Ocean.
        """
        let converterText = """
        \u{2022} Your answer was predictable.Today with all the new and progressive coffee brewing methods available, you may have a tough time deciding .
        \u{2022} A coffee bean is a seed of the coffee plant and the source for coffee..
        """
        let pageDesc = [page1String,page2String,page3String,page4String,page5String,page6String,page7String,page8String,page9String,page10String]
		let step = 25
        let converterData = [(false,0,0,0,"",0,0, 0),(true,1,25,100,"",300,12, step),(false,0,0,0,"",0,0, 0),(false,1,20,30,"",0,0, step),(false,0,0,0,"",0,0,0),(false,0,0,0,"",0,0, 0),(false,0,0,0,"",0,0, 0),(false,0,0,0,"",0,0, 0),(false,0,0,0,"",0,0, 0),(false,0,0,0,"",0,0, 0)]
        let timerData = [(true,300,"", "FILTER SOAKING IS COMPLETE"),(false,0,"", ""),(false,120,"", ""),(false,0,"", ""),(false,0,"", ""),(false,0,"", ""),(false,0,"", ""),(true,70,"", "YOUR COFFEE HAS BREWED"),(false,0,"", ""),(false,0,"", "")]
        //        let bgColors = [ UIColor.black, UIColor.black, UIColor.black, UIColor.black]

        let videos = ["https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4"]
        
        //let videos = [""]

        return (pageTitles,pageDesc,pageImages,converterData,timerData, videos)
    }
    func createPages8() -> ([String],[String],[String],[(Bool,Int,Int,Int,String,Int,Int, Int)],[(Bool,Int,String, String)], [String]) {
        
        YIELD = 340 // Default values if user does not alter slider and when page loads
        YIELD12P5 = ((YIELD*15)/100)
        YIELDRM1 = YIELD-((YIELD*15)/100)
        
        let pageTitles = ["PREPARE","WEIGH & GRIND","BLOOM","POUR"]
        let pageImages = ["Cover-Image","Cover-Image","Cover-Image","Cover-Image"]
        let page1String = """
        Place the filter in the V60 on top of the coffee cup
        \n
        Pour hot water into the V60 to wet the filter. Discard the water that drips into the cup
        \n
        """
        let page2String = """
        Weigh out your coffee and record the weight below based on the number of cups you need to brew
        \n
        Grind the beans to a medium-fine coarseness
        """
        let converterText = """
        Place the V60 and coffee cup on the scale, pour the ground coffee in the V60, then tare the scale
        """
        let page3String = """
        Pour __(YIELD12P5)__ grams of nearly boiling water over the grounds. Then start the timer while the coffee blooms
        \n
        """
        let page4String = """
        \u{2022} Start the timer, then continue to pour up the remaining __(YIELDRM1)__ grams over the coffee
        \n
        """
        
        let pageDesc = [page1String,page2String,page3String,page4String]
		let step = 25
        let converterData = [(false,0,0,0,"",0,0, 0),(true,1,25,200,converterText,340,14, step),(false,0,0,0,"",0,0, 0),(false,0,0,0,"",0,0, 0)]
        let timerData = [(false,45,"", ""),(false,0,"", ""),(true,45,"", "Your coffee has bloomed"),(true,300,"", "Notification Text")]
        //        let bgColors = [ UIColor.black, UIColor.black, UIColor.black, UIColor.black]

        let videos = ["https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4"]
        
        //let videos = [""]

        return (pageTitles,pageDesc,pageImages,converterData,timerData, videos)
    }
    
    func createPages9() -> ([String],[String],[String],[(Bool,Int,Int,Int,String,Int,Int,Int)],[(Bool,Int,String, String)], [String]) {
        let pageTitles = ["ADD MILK","GRIND","POUR","BREW","ENJOY"]
        let pageImages = ["Cover-Image","Cover-Image","Cover-Image","Cover-Image","Cover-Image"]
        let page1String = """
        Add 2 tablespoons of sweetened condensed milk to a glass.
        \n
        """
        let page2String = """
        Add 2 tablespoons of ground coffee to the base of the coffee press. Wet the grounds just a little bit with some hot water.
        """
        let page3String = """
        Screw on the press tight. The coffee should be packed well. Pour boiled hot water into the coffee press and cover securely with the Vietnamese press cover.
        \n
        """
        let page4String = """
        Brewing takes 3-5 minutes to complete. If coffee is dripping too fast, use a small spoon or tip of a knife to turn the press screw once clockwise. If it’s dripping too slow, unscrew 1 turn counterclockwise. The longer it takes, the stronger the coffee
        \n
        """
        let page5String = """
        Pour over a tall glass filled with ice and enjoy!
        \n
        """
        
        let pageDesc = [page1String,page2String,page3String,page4String,page5String]
        let step = 5
        let converterData = [(false,0,0,0,"",0,0,0),(false,1,2,13,"",0,0,0),(false,0,0,0,"",0,0,0),(false,0,0,0,"",0,0,0),(false,0,0,0,"",0,0,0)]
        let timerData = [(false,45,"", ""),(false,0,"", ""),(false,120,"", ""),(false,0,"", ""),(false,0,"", "")]
        //        let bgColors = [ UIColor.black, UIColor.black, UIColor.black, UIColor.black]

        let videos = ["https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4"]
        
        //let videos = [""]

        return (pageTitles,pageDesc,pageImages,converterData,timerData, videos)

    }
    
    func createPages10() -> ([String],[String],[String],[(Bool,Int,Int,Int,String,Int,Int, Int)],[(Bool,Int,String, String)], [String]) {
        let pageTitles = ["GRIND","FILL","WATER","SEAL","BREW","ENJOY"]
        let pageImages = ["Cover-Image","Cover-Image","Cover-Image","Cover-Image","Cover-Image","Cover-Image"]
        let page1String = """
        Grind your coffee to a slightly coarse consistency. You want them just coarser than an Espresso grind
        \n
        """
        let page2String = """
        Fill the filter funnel with grounds so that it's full but not packed. There's no need to tamp it down
        \n
        """
        let page3String = """
        Fill the base of the mocha pot base with hot water straight from a kettle until the water level is just below the safety valve & slip the filter funnel onto the base
        """
        let page4String = """
        Use a towel to hold the mocha pot while screwing the top onto the base. The base will be hot from the water so you'll need that towel! Screw it on tightly to secure
        """
        let page5String = """
        Place the mocha pot onto a stove on medium heat. You can open the lid to watch the coffee brew. It will soon start to flow out into the top part and you'll smell that awesome aroma
        """
        let page6String = """
        Once you hear a gurgling sound, take it off the heat and hold the based under cold running water to stop the brewing process. Serve and enjoy!
        \n
        You'll also want to make sure you don't overtighten the top onto the base when you store your mocha pot because this will lead to the rubber gasket wearing out eventually
        """
        let pageDesc = [page1String,page2String,page3String,page4String,page5String,page6String]
		let converterData = [(false,0,0,0,"",0,0, 0),(false,1,2,13,"",0,0, 0),(false,0,0,0,"",0,0, 0),(false,0,0,0,"",0,0, 0),(false,0,0,0,"",0,0, 0),(false,0,0,0,"",0,0, 0)]
        let timerData = [(false,45,"", ""),(false,0,"", ""),(false,120,"", ""),(false,0,"", ""),(false,0,"", ""),(false,0,"", "")]
        //        let bgColors = [ UIColor.black, UIColor.black, UIColor.black, UIColor.black]

        let videos = ["https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4"]
        
        //let videos = [""]

        return (pageTitles,pageDesc,pageImages,converterData,timerData, videos)
    }

    func createPages11() -> ([String],[String],[String],[(Bool,Int,Int,Int,String,Int,Int, Int)],[(Bool,Int,String, String)], [String]) {
            let pageTitles = ["GRIND","BOIL","BREW","FOAM","SERVE"]
            let pageImages = ["Cover-Image","Cover-Image","Cover-Image","Cover-Image","Cover-Image"]
            let page1String = """
            Grind your coffee to the finest consistency possible. You'll need around 1 tablespoon of super-fine ground coffee
            \n
            """
            let page2String = """
            Add 1 cup of cold water and 1/8 teaspoon sugar (optional) into your kanaka. Sugar is added during the brewing process and not after. Bring them to a boil on the stove
            \n
            """
            let page3String = """
            Remove from heat. Add the coffee & 1/8 tsp cardamom (ground or a pod - optional). Return kanaka to the stove & let it boil. Remove from heat when coffee foams
            """
            let page4String = """
            Again, return to heat, allowing to foam and remove from heat.
            \n
            """
            let page5String = """
            Pour into 2 demitasse cups, and allow to sit for a few minutes for the grounds to settle to the bottom of the cups. If using a cardamom pod, it can be served with the coffee for added flavor
            """
            let pageDesc = [page1String,page2String,page3String,page4String,page5String]
            let converterData = [(false,0,0,0,"",0,0, 0),(false,1,2,13,"",0,0, 0),(false,0,0,0,"",0,0, 0),(false,0,0,0,"",0,0, 0),(false,0,0,0,"",0,0, 0)]
            let timerData = [(false,45,"", ""),(false,0,"", ""),(false,120,"", ""),(false,0,"", ""),(false,0,"", "")]
            //        let bgColors = [ UIColor.black, UIColor.black, UIColor.black, UIColor.black]

            let videos = ["https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4"]
            
            //let videos = [""]

            return (pageTitles,pageDesc,pageImages,converterData,timerData, videos)
        }
    
    func createPages12() -> ([String],[String],[String],[(Bool,Int,Int,Int,String,Int,Int, Int)],[(Bool,Int,String, String)], [String]) {
        let pageTitles = ["RINSE","GRIND","BLOOM","REST","BREW"]
        let pageImages = ["Cover-Image","Cover-Image","Cover-Image","Cover-Image","Cover-Image"]
        let page1String = """
        Place filter in the brewer and rinse with hot water
        \nDrain rinse water by placing the brewer on top of the decanter. Be sure to dump your rinse water from the decanter as well
        \n
        """
        let page2String = """
        Weigh out 25g of whole bean coffee. Grind medium-coarse and pour into filter
        \nPlace everything on your scale and tare it to zero
        """
        let page3String = """
        Start timer and pour 50g of water over the coffee, making sure to saturate all the grounds thoroughly. Allow the coffee to bloom for 30 seconds
        """
        let page4String = """
        Begin pouring water and stop when you’ve reached 450g of water. Technique is not as important here as it would be with a pour over, just be sure to fully saturate the grounds. Start the timer and let the coffee sit for 2 minutes
        \n
        """
        let page5String = """
        Gently lift the brewer and place it on top of the decanter. The coffee will take around 5 minutes to drain.
        \nGive the decanter a swirl to aerate the coffee, pour yourself a cup, and enjoy!
        """
        let pageDesc = [page1String,page2String,page3String,page4String,page5String]
        let converterData = [(false,0,0,0,"",0,0, 0),(false,1,2,13,"",0,0, 0),(false,0,0,0,"",0,0, 0),(false,0,0,0,"",0,0, 0),(false,0,0,0,"",0,0, 0)]
        let timerData = [(false,45,"", ""),(false,0,"", ""),(true,30,"","YOUR COFFEE HAS BLOOMED"),(true,120,"", "YOUR COFFEE IS READY TO BREW"),(true,300,"", "YOUR COFFEE HAS BREWED")]
        //        let bgColors = [ UIColor.black, UIColor.black, UIColor.black, UIColor.black]

        let videos = ["https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4","https://30north.coffee/admin/uploads/brewing/brewing.mp4"]
        
        //let videos = [""]

        return (pageTitles,pageDesc,pageImages,converterData,timerData, videos)
    }
    
    func updateNavigationStuff() {
        //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedString.Key.foregroundColor:UIColor.white]
    }
}

extension BrewingPagesVC : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! BrewingPage).pageIndex
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        index -= 1
        return viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		var index = (viewController as! BrewingPage).pageIndex
        
        if index == NSNotFound {
            return nil
        }
        index += 1
        
        if (index == self.pageData!.0.count) {
            return nil
        }
        return viewControllerAtIndex(index: index)
    }
    
    func viewControllerAtIndex(index: Int) -> BrewingPage? {
        if self.pageData!.0.count == 0 || index >= self.pageData!.0.count {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        let pageContentViewController = storyboard?.instantiateViewController(withIdentifier: "BrewingPage") as! BrewingPage
        pageContentViewController.pageData = pageData
        pageContentViewController.pageIndex = index
        currentIndex = index
        
        return pageContentViewController
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pageData!.0.count
    }
}
