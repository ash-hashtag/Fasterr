extends Node

const names = ["mab", "dam", "fawaz"]
const PORT = 4000

var players : Dictionary

onready var peer := NetworkedMultiplayerENet.new()
var ip := "127.0.0.1"

func _ready():
	peer.connect("peer_connected", self, "peer_connected")
	peer.connect("peer_disconnected", self, "peer_disconnected")
	peer.connect("server_disconnected", self, "server_disconnected")
	peer.connect("connection_failed", self, "connection_failed")
	peer.connect("connection_succeeded", self, "connection_succeeded")


func start_server() -> void:
	peer.create_server(PORT, 8)
	get_tree().network_peer = peer
	print("server started")

func start_client() -> void:
	peer.create_client(ip, PORT)
	get_tree().network_peer = peer
	print("connecting to server...")

func server_disconnected() -> void:
	print("Server disconnected")

func peer_connected(_id: int) -> void:
	print(_id, " connected")
	var my_info = {name : names[randi() % names.size()]}
	rpc_id(_id, "register_player", my_info)

func peer_disconnected(_id: int) -> void:
	print(_id, " disconnected")

func connection_failed() -> void:
	print("failed to connect")

func connection_succeeded() -> void:
	print("connection successfull")

remote func register_player(info: Dictionary) -> void:
	var id = get_tree().get_rpc_sender_id()
	players[id] = info

remote func pre_configure_game() -> void:
	var myPeerID = get_tree().get_network_unique_id()
	
	var mainScene = preload("res://maps/test.tscn").instance()
	
	var player = preload("res://objects/car.tscn")
	
	var my_player = player.instance()
	my_player.name = str(myPeerID)
	my_player.set_network_master(myPeerID)
	mainScene.call_deferred("add_child", my_player)
	
	for p in players:
		var p_instance = player.instance()
		p_instance.name = str(p)
		p_instance.set_network_master(p)
		mainScene.call_deferred("add_child", p_instance)
	
	get_parent().call_deferred("add_child", mainScene)
	rpc_id(1, "done_preconfiguring")
