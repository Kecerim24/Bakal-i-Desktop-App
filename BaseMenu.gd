extends Control



func _ready():
	make_TimeTable_req()

func make_TimeTable_req():
	var url = "https://znamky.gymji.cz/api/3/timetable/actual?date="
	var date = Dictionary(OS.get_datetime(true))
	url += "{year}-{month}-{day}".format(date)
	var headers = ["Content-Type: application/x-www-form-urlencoded", "Authorization: Bearer " + Global.access_token]
	$TimeTable_req.request(url, headers)


func _on_TimeTable_request_completed(result, response_code, headers, body):
	Global.timetable = Dictionary(JSON.parse(body.get_string_from_utf8()).result)
	
