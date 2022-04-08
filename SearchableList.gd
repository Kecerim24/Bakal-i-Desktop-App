extends VBoxContainer

signal selected(what)

func clear():
	for item in $ScrollList/List.get_children(): item.queue_free()

func add_item(t):
	var b = Button.new()
	b.text = t
	b.align = ALIGN_BEGIN
	b.clip_text = true
	b.connect("pressed",self,"emit_signal",["selected",$ScrollList/List.get_child_count()])
	$ScrollList/List.add_child(b)

func get_at(idx):
	return $ScrollList/List.get_child(idx).text

func has_items():
	return $ScrollList/List.get_child_count() != 0

func search_for(text):
	for item in $ScrollList/List.get_children():
		if text == "":
			item.show()
			continue
			
		if not (text.to_lower() in item.text.to_lower()): 
			item.hide()
		else: 
			item.show()
