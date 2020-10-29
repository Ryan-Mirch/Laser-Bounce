extends Node

var hintCount = 0

var admob = null
var real_ads = false
var banner_top = true
var ad_banner_id = "ca-app-pub-8392398739941139/5564438865"
var ad_intersitial_id = "ca-app-pub-8392398739941139/6741789162"
var ad_rewarded_id = "ca-app-pub-8392398739941139/7488852480"
var enable_ads = true

var previousViewportWidth = 0

signal orientationChanged

# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.has_singleton("AdMob"):
		admob = Engine.get_singleton("AdMob")
		admob.init(real_ads,get_instance_id())
		admob.loadBanner(ad_banner_id, banner_top)
		admob.loadInterstitial(ad_intersitial_id)
		admob.loadRewardedVideo(ad_rewarded_id)

		
func show_ad_banner():
	if admob and enable_ads:
		admob.showBanner()

func hide_ad_banner():
	if admob:
		admob.hideBanner()

func show_ad_intersitial():
	if admob and enable_ads:
		admob.showInterstitial()
		
func _on_interstitial_closed():
	if admob and enable_ads:
		show_ad_banner()
		
func _on_rewarded_video_ad_failed_to_load(errorCode):
	pass
	#TODO: Show some sort of error saying they 
	#only get the hint if they watch the ad
	
func _on_rewarded_video_ad_left_application():
	pass
	
func _on_rewarded_video_ad_closed():
	admob.loadRewardedVideo(ad_rewarded_id)
	
func  _on_rewarded_video_ad_opened():
	pass
	#TODO: stops all game sounds and puts you into edit mode
		
func _on_rewarded(currency, amount):
	if currency == "Hint":
		hintCount += amount
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var w = get_viewport().get_visible_rect().size.x
	print(w)
	if w != previousViewportWidth && admob:
		previousViewportWidth = w
		admob.resize()
		emit_signal("orientationChanged")
	
