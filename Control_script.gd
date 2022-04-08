extends Control

const url = "https://sluzby.bakalari.cz/api/v1/municipality/"
var school_urls = {}

func _on_Button_pressed():
	var addr = $schooladdress.text
	if addr == "": 
		$status.text = "Enter or search for a school address before logging in"
		return
	Global.selected_school = addr
	var body = "client_id=ANDR&grant_type=password&username=" + $username.text + "&password=" + $password.text
	var header = ["Content-Type: application/x-www-form-urlencoded"]
	$status.text = "Logging in"
	$access_req.request(Global.selected_school + "/api/login", header, true, HTTPClient.METHOD_POST, body)


func _on_access_req_request_completed(result, response_code, headers, body):
	Global.access_token = Dictionary(JSON.parse(body.get_string_from_utf8()).result).get("access_token")
	if Global.access_token != null:
		get_tree().change_scene("res://BaseMenu.tscn")
	else:
		$status.text = "Wrong username or password"


func got_city_list(result, response_code, headers, body):
	var cities = JSON.parse(body.get_string_from_utf8()).result
	if response_code != 200: 
		print("error on cities request")
		$status.text = "Press Refresh"
		return
	for city in cities:
		if city.name == "": continue
		$CitySelector.add_item(city.name)
	
	$CitySelector.show()

func got_school_list(result, response_code, headers, body):
	var schools = JSON.parse(body.get_string_from_utf8()).result
	if response_code != 200: 
		print("error on schools request")
		$status.text = "Press Refresh"
		return
		
	$SchoolSelector.clear()
	yield(get_tree(),"idle_frame")
	$SchoolSelector.show()
	$CitySelector.hide()
	for school in schools.schools:
		if school.name == "": continue
		school_urls[school.name] = school.schoolUrl
		$SchoolSelector.add_item(school.name)

func school_selected(index):
	var school = $SchoolSelector.get_at(index)
	$schooladdress.text = school_urls.get(school)
	$SchoolSelector.hide()

func city_selected(index):
	var city = $CitySelector.get_at(index)
	var selected = city.substr(0, city.find("."))
	var headers = ["Accept: application/json"]
	$school_list_req.request(url + selected.percent_encode(), headers)

func find_schools():
	var vis = $CitySelector.visible or $SchoolSelector.visible
	if vis:
		$CitySelector.hide()
		$SchoolSelector.hide()
	else:
		if $CitySelector.has_items():
			$CitySelector.show()
		else:
			var headers = ["Accept: application/json"]
			$city_list_req.request(url, headers)
