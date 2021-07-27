extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var billing
var itemToken
const SKU = "remove_ads"


# Called when the node enters the scene tree for the first time.
func _ready():
	var _x = Saving.connect("saveDataUpdated", self, "removeButton")
	if Engine.has_singleton("GodotGooglePlayBilling"):
		billing = Engine.get_singleton("GodotGooglePlayBilling")
		billing.connect("connected", self, "connected")
		billing.connect("disconnected", self, "disconnected")
		billing.connect("connect_error", self, "connect_error")
		billing.connect("purchases_updated", self, "purchases_updated")
		billing.connect("purchase_error", self, "purchase_error")
		billing.connect("sku_details_query_completed", self, "sku_details_query_completed")
		billing.connect("sku_details_query_error", self, "sku_details_query_error")
		billing.connect("purchase_acknowledged", self, "purchase_acknowledged")
		billing.connect("purchase_acknowledgement_error", self, "purchase_acknowledgement_error")
		billing.connect("purchase_consumed", self, "purchase_consumed")
		billing.connect("purchase_consumption_error", self, "purchase_consumption_error")
		billing.startConnection()

func connected():
	billing.querySkuDetails([SKU], "inapp")
	
	var query = billing.queryPurchases("inapp") # Or "subs" for subscriptions
	if query.status == OK:
		for purchase in query.purchases:
			if purchase.sku == SKU:
				Saving.showAds = false # Entitle the user to the content they bought
				Saving.updateSaveData()
				if !purchase.is_acknowledged:
					billing.acknowledgePurchase(purchase.purchase_token)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func removeButton():
	if Saving.showAds == false:
		self.visible = false

func purchases_updated(items):
	for item in items:
		if !item.is_acknowledged:
			billing.acknowledgePurchase(item.purchase_token)
	if items.size() > 0:
		itemToken = items[items.size() - 1].purchase_token
	
	billing.consumePurchase(itemToken)
	
	Saving.showAds = false
	Saving.updateSaveData()

func purchase():
	var response = billing.purchase(SKU)


func _on_Remove_Ads_pressed():
	if billing != null:
		purchase()
