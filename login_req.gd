extends Control

func _ready():
	pass


func _on_Button_pressed():
	var body = "client_id=ANDR&grant_type=password&username=" + $username.text + "&password=" + $password.text
	var header = ["Content-Type: application/x-www-form-urlencoded"]
	$HTTPRequest.request("https://znamky.gymji.cz/api/login", header, true, HTTPClient.METHOD_POST, body)


func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body):
	var access_token = Dictionary(JSON.parse(body.get_string_from_utf8()).result).get("access_token")
	
	if access_token != null:
		$center/status.text = access_token
	else:
		$center/status.text = "Wrong username or password"
