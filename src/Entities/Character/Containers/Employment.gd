extends DataContainer



func _init() -> void:
	add_value("work_status", "party_leader")
	add_value("pay_rate", -1)
	add_value("pay_frequency", 7)
	add_value("medical_deposit", -1)
	add_value("contract_length_current", -1)
	add_value("contract_length_total", -1)



func get_pay_frequency_as_text() -> String:
	var pay_frequency : int = get("pay_frequency")
	
	if pay_frequency % 7 == 0:
		return "weekly"
	
	if pay_frequency % 14 == 0:
		return "bi-weekly"
	
	if pay_frequency % 30 == 0:
		return "monthly"
	
	if pay_frequency % 60 == 0:
		return "bi-monthly"
	
	if pay_frequency % 365 == 0:
		return "annually"
	
	if pay_frequency % 730 == 0:
		return "bi-annually"
	
	return str("every ", pay_frequency, " days")
