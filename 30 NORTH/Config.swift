//
//  config.swift
//  Restaurateur
//
//  Created by Panacea-soft on 11/23/15.
//  Copyright © 2015 Panacea-soft. All rights reserved.
//
//    https://30north.coffee/admin/api/menus/get/id/1
//    https://30north.coffee/admin/index.php/rest/menus/get/id/1

struct configs {

	static let GMAPIKey = "AIzaSyDgE_kW9ov2vReMML3f0Vjkqf6KC9HZ6hM"
//    static var mainUrl:String = "http://www.lvngs.com/index.php/rest"
//    static var imageUrl:String = "http://www.lvngs.com/uploads/"
//    static var pointsUrl:String = "http://lvngs.com/api/points?user_id="
//    static var newBaseURL : String = "http://lvngs.com/api"
    
//    static var mainUrl:String = "https://30north.coffee/admin/index.php/rest"
    
    //    https://30north.coffee/admin/api/menus/get/id/1
    static var mainUrl:String =  "https://30north.coffee/admin/api"
    static var mainPaymentURL:String = "https://accept.paymobsolutions.com/api"
    static var imageUrl:String = "https://30north.coffee/admin/uploads/"
    static var outletImageUrl:String = "https://30north.coffee/admin/uploads/outlet_images/outlet_"

    static var pointsUrl:String = "https://30north.coffee/admin/api/api_custom/points?user_id="
    static var redeemPointsURL:String = "https://30north.coffee/admin/api/do_points?user_id="
    static var newBaseURL : String = "https://30north.coffee/admin/api"
    
    
    static var decimalPlaces = "2" // "2" = 2 decimal, "1" = 1 decimal, "", 0 decimal
    static let getCoffeeFinderCases = "/cases/get"
    static let getShops           = "/menus/get"
    static let getOutlets         = "/outlets/get"
    static let getShopByID        = "/menus/get/id/%d"
    static let itemsBySubCategory = "/items/get/shop_id/%d/sub_cat_id/%d/item/all/count/%d/from/%d/field/%@/type/%@"
    static let allItemsBySubCategory = "/items/get/shop_id/%d/sub_cat_id/%d/item/all/"
    static let itemById              = "/items/get/id/%d/shop_id/%d"
    static let searchByGeo           = "/items/search_by_geo/miles/%f/userLat/%f/userLong/%f/shop_id/%d/sub_cat_id/%d"
    static let userLogin           = "/appusers/login"
    static let getFavouriteItems   = "/items/user_favourites/user_id/%d/count/%d/from/%d"
    static let addItemInquiry      = "/items/inquiry/id/%d"
    static let addItemReview       = "/items/review/id/%d"
    static let addAppUser          = "/appusers/add"
    static let resetPassword       = "/appusers/reset"
    static let updateAppUser       = "/appusers/update/id/%d"
	static let updateSubscription  = "/transactions/update_subscription"

    static let profilePhotoUpload  = "/images/upload"
    static let addItemLike         = "/items/like/id/%d"
    static let isLikedItem         = "/items/is_like/id/%d"
    static let isFavouritedItem    = "/items/is_favourite/id/%d"
    static let addItemFavourite    = "/items/favourite/id/%d"
    static let addItemTouch        = "/items/touch/id/%d"
    static let getNewsFeedByShopId = "/shops/feeds/shop_id/%d"
    static let getRewardsFeedByShopId = "/shops/get/id/%d"
    static let searchByID          = "/items/search/shop_id/%d"
    static let registerPushNoti    = "/gcm/register"
    static let addItemRating       = "/items/rating/id/%d"
    static let stripePayment       = "/stripe/submit"
    static let transactionSubmit   = "/transactions/add"
    static let userTransactionHistory     = "/transactions/user_transactions/user_id/%d"
    static let shopSearchByLocation = "/shops/search_by_geo/miles/%f/userLat/%f/userLong/%f"
    static let couponSearch         = "/coupons/search"
    static let searchByKeyword      = "/shops/search_by_keyword"
    static let reservationSubmit    = "/reservations/add"
    static let reservationHistory   = "/reservations/get_all_reservation_by_user/user_id/%d"
    static let getAbout             = "/abouts/index"
    static let getFeatured          =   "/featured/"
    static let getCoupon          =   "/coupons/get"
    static let getRewardFeedByShopId = "shops/rewardfeeds/shop_id/%d"
    static let getRequestType             = "/request_types/get_all"
    static let addNotification             = "/notifications/add"
    static let getAnnouncements             = "/announcements/get"
	static let getTickers					= "/tickers/get"
    static let getCuppings             = "/cuppings/get"
    static let getHeighlights             = "/highlights/get"
    static let getAuthenticationToken = "/auth/tokens"
    static let getOrderId = "/ecommerce/orders"
    static let getPaymentKeyPerOrder = "/acceptance/payment_keys"
    static let updateTransactionStatus = "/transactions/update_status"
	static let saveAccept = "/transactions/save_accept"
    static let getOrderIDFromOrderList = "/ecommerce/orders"
	static let getGrindTypes = "/grounds/get"


    static var pageSize:Int = 7
    //static var barColorCode = "#455A64"
    static var barColorCode = "#141414"
    static var btnColorCode = "#607D8B"
    
    // Connection timeout Interval seconds
    static var timeoutInterval = 25
    
    // iAds flag
    //static var showAdvs = true // true or false
    
    //Startup Mode
    static var startUpMode = "list" //list or map
    static var regionLat = "30.052330"
    static var regionLng = "31.235113"
}

struct language {
    static var LoginTitle              = "Login"
    static var blankInputLogin         = "Login"
    static var emailValidation         = "Please enter a valid email address"
    static var loginNotSuccessMessage  = "Please Check Your Login Credentials"
    static var profileUpdate           = "Profile Update"
    static var profileDistrictUpdate   = "District has been updated in your profile"
    static var doNotMatch              = "Passwords do not match"
    static var reviewTitle             = "Review"
    static var reviewEmpty             = "Please type your review"
    static var inquiryTitle            = "Inquiry"
    static var inquiryEmpty            = "Please enter something"
    static var typeInquiryMessage      = "Please type inquiry here"
    static var typeReviewMessage       = "Please type review here"
    static var inquirySentSuccess      = "Thanks for getting in touch"
    static var somethingWrong          = "An error has occured. Please try agian"
    static var currentLocation         = "Current Location"
    static var geocoderProblem         = "Oops! There was an error getting your location"
    static var searchTitle             = "Search"
    static var itemNotFount            = "No search results. Please try again."
    static var allowLocationService    = "Please enable Location services"
    static var homePageTitle           = "30 NORTH"
    static var searchPageTitle         = "Keyword Search"
    static var profilePageTitle        = "Profile"
    static var registerTitle           = "Register"
    static var userInputEmpty          = "Please provide necessary user information."
    static var registerSuccess         = "Welcome aboard! Now signing you in"
    static var resetTitle              = "Forgot Password"
    static var resetSuccess            = "Please check your email for a password reset link"
    static var userEmailEmpty          = "Please provide your registered email"
    static var tryAgainToConnect       = "A server error occurred. Please try again"
	static var selectDistrict          = "Please select district."

    static var networkError            = "An error occurred. Please check your Internet connection"
    static var imageIsNull             = "Error: Blank image"
    static var itemMapTitle            = "Map View"
    static var noLatLng                = "There are no location details for this item"
    static var shareMessage            = "30 NORTH | Beans, Brews and Tales"
    static var fbLogin                 = "Please login to Facebook to share"
    static var twLogin                 = "Please login to Twitter to share."
    static var btnOK                   = "OK"
    static var accountLogin            = "Account Login"
    static var categories              = "Categories : "
    static var subCategories           = " | Sub Categories : "
    static var selectedCityPageTitle   = "Selected Outlet"
    static var itemsPageTitle          = "Items From Outlet"
    static var itemDetailPageTitle     = "Item Details"
    static var shareOn                 = "Share"
    static var tweetOn                 = "Tweet"
    static var viewOnMap               = "View"
    static var inquiryPageTitle        = "Get in Touch"
    static var reviewListPageTitle     = "Reviews List"
    static var submit                  = "Submit"
    static var reviewEntryPageTitle    = "Submit Review"
    static var feedListPageTitle       = "News Feed From Shop"
    static var feedDetailPageTitle     = "News Feed Detail"
    static var mapExplorePageTitle     = "Explore On Map"
    static var itemMapPageTitle        = "Item Location"
    static var sliderPageTitle         = "Item Images"
    static var favouritePageTitle      = "My Favourite Items"
    static var homeMenu                = "Home"
    static var brewingMenu             = "Brewing Methods"
    static var coffeeGuide             = "Coffee Guide"
    static var northMusic              = "30 North Music"
    static var searchMenu              = "Search By Keyword"
    static var ProfileMenu             = "Profile"
    static var favouriteMenu           = "My Favourite Items"
    static var logoutMenu              = "Sign Out"
    static var forgotTitle             = "Request Forgot Password"
    static var loginRequireTitle       = "Please Sign In"
    static var loginRequireMesssage    = "Please login to create an order"
    static var noShops                 = "Error: No outlets found"
    static var noOutlets                 = "Currently no outlets are open"

    static var noItemsForOutlet                 = "No matching items at this outlet"
    static var currentLocationNotFound                 = "Please make sure location services are enabled for the app and try again."
    static var profilePhotoUploaded    = "Profile photo successfully updated."
    static var mileRange               = "Distance in KMs : "
    static var miles                   = " ml"
    static var shareURL                = "http://30north.coffee"
    static var price                   = "Price : "
    static var qty                     = "Qty : "
    static var rating                  = "Rating : "
    static var na                      = "N.A"
    static var availableDiscount       = "Available Discount : "
    static var availableDiferent       = "Options "
    static var selectedAttribute       = "Selected : "
    static var addtoCart               = "Add To Basket"
    static var fillQtyMessage          = "Please enter quantity"
    static var basketEmptyTitle        = "Basket Empty"
    static var basketEmptyMessage      = "Please add items to your basket"
    static var total                   = "Total : "
    static var paymentOptionsTitle     = "Payment Options"
    static var checkoutConfirmationTitle = "ORDER SUMMARY"
    static var rewardsTitle = "30 NORTH Rewards"
    static var rewardsWelcomMessage = "Welcome to 30 NORTH rewards. Here’s 200 points on us to get you started"
    static var paymentTitle            = "Payment"
    static var userInfoRequired        = "Please provide the missing contact information"
    static var userInfoRequiredFirstName        = "First name is required to complete online payments. Please update information in your profile."
    static var userInfoRequiredLastName        = "Last name is required to complete online payments. Please update information in your profile."
    static var userInfoRequiredEmail        = "Email is required to complete online payments. Please update information in your profile."
    static var userInfoRequiredPhoneNumber        = "Phone number is required to complete online payments. Please update information in your profile."
	static var invalidPickupDateTime		   = "Please select a valid pickup date time"
	static var phoneNotVerified		   = "Please verify your phone number so we can reach you"
	static var noDistrict 	   = "Please select your district"
	static var saveDistrictToProfileTitle 	   = "Save District to Profile?"
	static var saveDistrictToProfile 	   = "Tap Cancel to proceed without saving to profile or Tap Yes to save to profile and proceed"
	static var deliveryAddressNotVerified 	   = "Please enter your delivery address so we can deliver your order"
    static var orderSuccessMessage     = "Your order has been submitted."
    static var orderSuccessMessageForOnlinePayment     = "Your order has been submitted. Pay online now?"
    static var orderSuccessOnlinePayment     = "Transaction successful"
    static var orderSuccessTitle       = "Success"
    static var orderFailMessage        = "Your order could not be submitted."
    static var orderFailedOnline        = "Transaction failed. Please try again."
	static var paymentCancelledByUser 	= "You have cancelled your payment."
    static var orderFailTitle          = "Fail"
    static var shopProfile             = "Outlet Information"
    static var transactionHistory      = "Order History"
    static var transactionNo           = "Order No. : "
    static var transactionPayment       = "Payment Method: "
    static var transactionStatus       = "Status: "
    static var transactionTotal        = "Total Amount: "
    static var transactionHistoryDetail      = "Order Details"
    static var transactionPhone        = "Phone : "
    static var transactionEmail        = "Email : "
    static var transactionBilling      = "Billing Address : "
    static var transactionDelivery     = "Delivery Address : "
    static var transactionPickupLocation     = "Pickup Location : "
    static var transactionPickupDateTime     = "Pickup Date Time : "
	static var transactionItemName     = "Item Name : "
    static var shopNotFount            = "No outlets found. Please try again."
    static var couponDiscountTitle     = "Apply Coupon Discount"
    static var couponMessageLabel           = "If you have discount coupon, please apply it below. (Read our T&Cs)"
    static var couponEmpty             = "No coupon provided. Please enter a valid discount coupon."

    static var subscriptionNumber       = "Subscription No. : "
    static var subscriptionAmount       = "Subscription Amount: "
    static var subscriptionFrequency    = "Billed Every: "
    static var subscriptionBeans        = "Beans: "
    static var subscriptionQuantity     = "Quantity: "
    static var subscriptionEnded     	= "Ended: "

    static var couponInvalid           = "Invalid discount code. Please try again."
    static var subTotalLabel           = "Sub Total : "
    static var couponDiscountLabel     = "Coupon Discount : "
    static var shippingCostLabel       = "Delivery Charge : "
    static var orderTotalLabel         = "Order Total : "
    static var reservationPageTitle    = "Reservation"
    static var reservationHistory      = "Reservation History"
    static var reservationSuccess      = "Reservation has been submitted successfully."
    static var resvId                  = "Reservation ID : "
    static var resvDate                = "Reservation Date : "
    static var resvTime                = "Reservation Time : "
    static var resvStatus              = "Reservation Status : "
    static var contactName             = "Name : "
    static var contactEmail            = "Email : "
    static var contactPhone            = "Phone : "
    static var note                    = "Note : "
    static var aboutPageTitle          = "Our Story"
    static var offlineTitle            = "Device Offline"
    static var offlineMessage          = "Please check your Internet connection"
    static var alreadyRated            = "You have already rated this item"
    static var ratingTitle             = "Rating"
    static var ratingProblem           = "An error occured: Unable to submit rating"
    static var basketTitle             = "Basket"
    static var basketMessage           = "Qty must have at least one"
    static var northMusics             = "30 North Music"
    static var Outlets             = "Outlets"
    static var coffeeListPageTitle        = "Coffee List"
    static var coffeeDetailPageTitle      = "Coffee"
	static var pageNotFound			   	  = "Content is not avaiable at the moment"
    static var menuPage                     = "Menu"


}

struct notiKey {
    static var deviceIDKey = "DEVICE_ID"
    static var deviceTokenKey = "TOKEN"
    static var isRegister = "IS_REGISTER"
    static var notiMessageKey = "NOTI_MSG"
    static var devicePlatform = "IOS"
}

struct customFont{
    static var boldFontName                 = "NexaBold"
    static var boldFontSize                 = 18
    static var normalFontName               = "NexaLight"
    static var normalFontSize               = 18
    static var tableHeaderFontSize          = 15
    static var pickerFontSize               = 14
    static var totalPriceLabelFont = UIFont.systemFont(ofSize: 19, weight: .bold)
    static var totalPriceDiscountFont = UIFont.systemFont(ofSize: 19)

}

//struct admobConfig {
//    static var isEnabled = false
//    static var adUnitId = "ca-app-pub-6414469769989507/6549753073"
//}
//

