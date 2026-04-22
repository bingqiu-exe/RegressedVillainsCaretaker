extends Node

# CHARACTERS
const ANLU_CONCERNED = preload("res://assets/an lu sprites/anlu_concerned.png")
const ANLU_HAPPY = preload("res://assets/an lu sprites/anlu_happy.png")
const ANLU_SUPRISED = preload("res://assets/an lu sprites/anlu_surprised.png")
const ANLU_UNEASY = preload("res://assets/an lu sprites/anlu_uneasy.png")
const ANLU_WHIMSY = preload("res://assets/an lu sprites/anlu_whimsy.png")
const ANLU_MAD = preload("res://assets/an lu sprites/anlu_mad.png")
const ANLU_INJURED = preload("res://assets/an lu sprites/anlu_injured.png")
const ANLU_SUCCUMBED = preload("res://assets/an lu sprites/anlu_succumbed.png")

const KEVIN_SMILE = preload("res://assets/wu kaiwen sprites/kevin_smile.png")
const KEVIN_JEALOUS = preload("res://assets/wu kaiwen sprites/kevin_jealous.png")
const KEVIN_IMPATIENT = preload("res://assets/wu kaiwen sprites/kevin_impatient.png")
const KEVIN_REALIZATION = preload("res://assets/wu kaiwen sprites/kevin_realization.png")
const KEVIN_INSANE = preload("res://assets/wu kaiwen sprites/kevin_insane.png")

@onready var anlu_sprite = $AnLu
@onready var kevin_sprite = $WuKaiwen
@onready var dialogue_text = $Text
@onready var char_name_label = $CharaName
@onready var fade_overlay = $FadeOverlay
@onready var intro_label = $FadeOverlay/Text
var current_line = 0
var last_visible_chars = 0
var is_intro = true

# ACT 1 SCENE 1
var dialogue_data = [
	# GAME NARRATION
	{
		"name": "",
		"text": "※ This game is based off of me and my friend’s Where Winds Meet original characters with a twist of xianxia (chinese fantasy genre), viewer’s discretion is recommended ※",
		"expression": null,
		"side": "none",
		"is_black_screen": true
	},
	{
		"name": "",
		"text": "It was, so, very long time ago.",
		"expression": null,
		"side": "none",
		"is_black_screen": true
	},
	{
		"name": "",
		"text": "I, An Lu, was the suffering of hatred title bearer. A long time ago, I took in a young boy into my care.",
		"expression": null,
		"side": "none",
		"is_black_screen": true
	},
	{
		"name": "",
		"text": "That quiet child slowly grew into a fine young man under my influence. I teached him martial arts and all sorts of mystic skills, enough so that he could survive all by himself in the rough Jianghu.",
		"expression": null,
		"side": "none",
		"is_black_screen": true
	},
	{
		"name": "",
		"text": "But...",
		"expression": null,
		"side": "none",
		"is_black_screen": true
	},
	{
		"name": "",
		"text": "How did it end up like this...?",
		"expression": null,
		"side": "none",
		"is_black_screen": true
	},
	{
		"name": "",
		"text": "Our relationship went astray after I sent him to Well of Heaven, our relationship was pretty rough even from the start anyway.",
		"expression": null,
		"side": "none",
		"is_black_screen": true
	},
	{
		"name": "",
		"text": "I admit, this was my mistake for being too harsh on him.",
		"expression": null,
		"side": "none",
		"is_black_screen": true
	},
	# CHARACTER DIALOGUES
	{
		"name": "Wu Kaiwen",
		"text": "Yifu… all these years… I just want you to look at me… why couldn’t you do so? Why does everyone keep avoiding me? Am I a nuisance?.",
		"expression": KEVIN_SMILE,
		"side": "right"
	},
	{
		"name": "An Lu",
		"text": "Kaiwen... stay calm, you're not in the right mind right now. Let's just... talk? Ok...?",
		"expression": ANLU_UNEASY,
		"side": "left"
	},
	{
		"name": "Wu Kaiwen",
		"text": "Oh? So I’m the one who’s not in the right mind? After… after all these years…",
		"expression": KEVIN_JEALOUS,
		"side": "right"
	},
	{
		"name": "An Lu",
		"text": "Kaiwen… please…",
		"expression": ANLU_UNEASY,
		"side": "left"
	},
	{
		"name": "Wu Kaiwen",
		"text": "Don’t touch me! I… I was so happy when you picked me up when no one did. Why did you abandon me? Why take me in…? I don’t understand…",
		"expression": KEVIN_JEALOUS,
		"side": "right"
	},
	{
		"name": "An Lu",
		"text": "Kaiwen… you must understand that my sect has a strict rule. I cannot disobey.",
		"expression": ANLU_MAD,
		"side": "left"
	},
	{
		"name": "Wu Kaiwen",
		"text": "So why didn’t you take me into yours! I never wanted to join Well of Heaven, but when I saw 
		your relieved face I couldn’t help but to-",
		"expression": KEVIN_IMPATIENT,
		"side": "right"
	},
	{
		"name": "An Lu",
		"text": "Kaiwen...! This ignorant yifu is truly sorry... just- please... calm down for a bit... ok? 
		You’ll get hurt...!",
		"expression": ANLU_CONCERNED,
		"side": "left"
	},
	{
		"name": "Wu Kaiwen",
		"text": "Do you truly care for me all these years…? Will you stop me from hurting myself?",
		"expression": KEVIN_IMPATIENT,
		"side": "right"
	},
	{
		"name": "An Lu",
		"text": "What…? Kaiwen… what are you trying to do-",
		"expression": ANLU_SUPRISED,
		"side": "left"
	},
	{
		"name": "Wu Kaiwen",
		"text": "Let's see which one is faster, or the sleeping puppet poison I have planted inside.",
		"expression": KEVIN_IMPATIENT,
		"side": "right"
	},
	{
		"name": "An Lu",
		"text": "Kaiwen-!",
		"expression": ANLU_SUPRISED,
		"side": "left"
	},
	
]

func _ready():
	update_dialogue()

func _input(event):
	if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed):
		if dialogue_text.visible_ratio < 1.0:
			dialogue_text.visible_ratio = 1.0
		else:
			current_line += 1
			update_dialogue()

func update_dialogue():
	if current_line >= dialogue_data.size():
		return

	var data = dialogue_data[current_line]
	var is_black = data.get("is_black_screen", false)
	
	if is_black:
		# --- STILL IN INTRO ---
		fade_overlay.visible = true
		fade_overlay.modulate.a = 1.0 # Keep it fully black
		intro_label.visible = true
		dialogue_text.visible = false
		char_name_label.visible = false
		
		intro_label.text = data["text"]
		intro_label.visible_ratio = 0
		var t = create_tween()
		t.tween_property(intro_label, "visible_ratio", 1.0, 2.0)
	else:
		# --- TRANSITION TO ACT 1 ---
		# Check if the overlay is still visible. If it is, fade it out!
		if fade_overlay.visible == true:
			fade_out_black_screen()
		
		# Reveal the main UI
		dialogue_text.visible = true
		char_name_label.visible = true
		intro_label.visible = false
		
		char_name_label.text = data["name"]
		dialogue_text.text = data["text"]
		dialogue_text.visible_ratio = 0
		
		var t = create_tween()
		t.tween_property(dialogue_text, "visible_ratio", 1.0, 1.0)
		
		# Animate the characters
		if data["side"] == "left":
			apply_focus_animation(anlu_sprite, data["expression"])
			apply_dim_animation(kevin_sprite)
		elif data["side"] == "right":
			apply_focus_animation(kevin_sprite, data["expression"])
			apply_dim_animation(anlu_sprite)

func apply_focus_animation(sprite: Sprite2D, texture: Texture2D):
	sprite.texture = texture
	var tween = create_tween().set_parallel(true)

	var active_y = 140
	
	tween.tween_property(sprite, "position:y", active_y, 0.2).set_trans(Tween.TRANS_SINE) 
	tween.tween_property(sprite, "modulate", Color(1, 1, 1), 0.2)

func apply_dim_animation(sprite: Sprite2D):
	var tween = create_tween().set_parallel(true)
	
	var base_y = 160

	tween.tween_property(sprite, "position:y", base_y, 0.2).set_trans(Tween.TRANS_SINE)
	tween.tween_property(sprite, "modulate", Color(0.5, 0.5, 0.5), 0.2)

func fade_out_black_screen():
	var tween = create_tween().set_parallel(true)
	# Fade the black to transparent
	tween.tween_property(fade_overlay, "modulate:a", 0.0, 2.0)
	
	# After 2 seconds, fully hide the node so it doesn't block mouse clicks
	await get_tree().create_timer(2.0).timeout
	fade_overlay.visible = false
