extends Control

const url = "https://sluzby.bakalari.cz/api/v1/municipality/"
var school_urls = {}


func _ready():
	var headers = ["Accept: application/json"]
	$city_list_req.request(url, headers)


func _on_Button_pressed():
	if Global.selected_school == "": 
		$status.text = "Select school before login"
		return
	var body = "client_id=ANDR&grant_type=password&username=" + $username.text + "&password=" + $password.text
	var header = ["Content-Type: application/x-www-form-urlencoded"]
	$status.text = "Loging in"
	$access_req.request(Global.selected_school + "/api/login", header, true, HTTPClient.METHOD_POST, body)


func _on_access_req_request_completed(result, response_code, headers, body):
	Global.access_token = Dictionary(JSON.parse(body.get_string_from_utf8()).result).get("access_token")

	if Global.access_token != null:
		get_tree().change_scene("res://BaseMenu.tscn")
	else:
		$status.text = "Wrong username or password"


func _on_city_list_request_completed(result, response_code, headers, body):
	var cities = JSON.parse(body.get_string_from_utf8()).result
	if response_code != 200: 
		print("error on cities request")
		$status.text = "Press Refresh"
		return
	$city_list.add_item("City")
	for city in cities:
		if city.name == "": continue
		$city_list.add_item(city.name)


func _on_school_list_req_request_completed(result, response_code, headers, body):
	var schools = JSON.parse(body.get_string_from_utf8()).result
	if response_code != 200: 
		print("error on schools request")
		$status.text = "Press Refresh"
		return
		
	$school_list.show()
	$school_list.clear()
	$school_list.add_item("School")
	for school in schools.schools:
		if school.name == "": continue
		school_urls[school.name] = school.schoolUrl
		$school_list.add_item(school.name)


func _on_school_list_item_selected(index):
	var school = $school_list.get_item_text(index)
	Global.selected_school = school_urls.get(school)


func _on_city_list_item_selected(index):
	var selected = $city_list.get_item_text(index).substr(0, $city_list.get_item_text(index).find("."))
	var headers = ["Accept: application/json"]
	$school_list_req.request(url + selected.percent_encode(), headers)
	


func _on_refresh_pressed():
	$school_list.hide()
	$status.text = ""
	Global.selected_school = ""
	$school_list.clear()
	$city_list.clear()
	_ready()
