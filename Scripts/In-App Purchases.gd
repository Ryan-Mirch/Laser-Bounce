extends Control

const TEST_FULL_SKU = "full_version_test"
const TEST_LASER1_SKU = "laser_1_test"
const TEST_LASER2_SKU = "laser_2_test"

var payment

onready var alert_dialog = $"AcceptDialog"
onready var alert_dialog_text = $"AcceptDialog/Label2"

var test_item_purchase_token = null

func _ready():
	if Engine.has_singleton("GodotGooglePlayBilling"):
		payment = Engine.get_singleton("GodotGooglePlayBilling")

		# These are all signals supported by the API
		# You can drop some of these based on your needs
		payment.connect("connected", self, "_on_connected") # No params
		payment.connect("disconnected", self, "_on_disconnected") # No params
		payment.connect("connect_error", self, "_on_connect_error") # Response ID (int), Debug message (string)
		payment.connect("purchases_updated", self, "_on_purchases_updated") # Purchases (Dictionary[])
		payment.connect("purchase_error", self, "_on_purchase_error") # Response ID (int), Debug message (string)
		payment.connect("sku_details_query_completed", self, "_on_sku_details_query_completed") # SKUs (Dictionary[])
		payment.connect("sku_details_query_error", self, "_on_sku_details_query_error") # Response ID (int), Debug message (string), Queried SKUs (string[])
		payment.connect("purchase_acknowledged", self, "_on_purchase_acknowledged") # Purchase token (string)
		payment.connect("purchase_acknowledgement_error", self, "_on_purchase_acknowledgement_error") # Response ID (int), Debug message (string), Purchase token (string)
		payment.connect("purchase_consumed", self, "_on_purchase_consumed") # Purchase token (string)
		payment.connect("purchase_consumption_error", self, "_on_purchase_consumption_error") # Response ID (int), Debug message (string), Purchase token (string)

		payment.startConnection()
	else:
		print("Android IAP support is not enabled. Make sure you have enabled 'Custom Build' and the GodotGooglePlayBilling plugin in your Android export settings! IAP will not work.")
	Global.iap = self
	
	
func _on_connected():
	print("PurchaseManager connected")

	# We must acknowledge all puchases.
	# See https://developer.android.com/google/play/billing/integrate#process for more information
	var query = payment.queryPurchases("inapp") # Use "subs" for subscriptions.
	if query.status == OK:
		for purchase in query.purchases:
			if !purchase.is_acknowledged:
				print("Purchase " + str(purchase.sku) + " has not been acknowledged. Acknowledging...")
				payment.acknowledgePurchase(purchase.purchase_token)
	else:
		print("Purchase query failed: %d" % query.status)
		
	payment.querySkuDetails([TEST_FULL_SKU], "inapp")


func show_alert(_text):
	pass
	#alert_dialog_text.text = text
	#alert_dialog.popup()

func _on_sku_details_query_completed(sku_details):
	
	for available_sku in sku_details:
		show_alert(to_json(available_sku))


func _on_purchases_updated(purchases):
	print("Purchases updated: %s" % to_json(purchases))

	# See _on_connected
	for purchase in purchases:
		if !purchase.is_acknowledged:
			print("Purchase " + str(purchase.sku) + " has not been acknowledged. Acknowledging...")
			payment.acknowledgePurchase(purchase.purchase_token)

	if purchases.size() > 0:
		test_item_purchase_token = purchases[purchases.size() - 1].purchase_token


func _on_purchase_acknowledged(purchase_token):
	print("Purchase acknowledged: %s" % purchase_token)


func _on_purchase_consumed(purchase_token):
	show_alert("Purchase consumed successfully: %s" % purchase_token)


func _on_purchase_error(code, message):
	show_alert("Purchase error %d: %s" % [code, message])


func _on_purchase_acknowledgement_error(code, message):
	show_alert("Purchase acknowledgement error %d: %s" % [code, message])


func _on_purchase_consumption_error(code, message, purchase_token):
	show_alert("Purchase consumption error %d: %s, purchase token: %s" % [code, message, purchase_token])


func _on_sku_details_query_error(code, message):
	show_alert("SKU details query error %d: %s" % [code, message])


func _on_disconnected():
	show_alert("GodotGooglePlayBilling disconnected. Will try to reconnect in 10s...")
	yield(get_tree().create_timer(10), "timeout")
	payment.startConnection()


func purchaseFullApp():
	if payment:
		var response = payment.purchase(TEST_FULL_SKU)
		if response.status != OK:
			show_alert("Purchase error %s: %s" % [response.response_code, response.debug_message])

