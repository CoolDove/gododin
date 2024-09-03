package main

import "base:runtime"
import "core:math"
import "core:math/linalg"
import "core:math/rand"
import "core:fmt"
import "godot"
import gde "gdextension"


Spike :: struct {
	using gobj : godot.RigidBody2D,
}

Dove :: struct {
	using gobj : godot.Sprite2D,
	id : int,
	hp: int,
	time : f64,
	moving : [2]i32,
	total_alive_time : f64,

	_process : proc(self: ^Dove, delta: f64) `godot:"override"`,
	_input : proc(self: ^Dove, event: godot.InputEvent) `godot:"override"`,
}

Dove_process_gcall :: proc "c" (p_instance: gde.GDExtensionClassInstancePtr, p_args: [^]gde.GDExtensionConstTypePtr, r_ret: gde.GDExtensionTypePtr) {
	context = runtime.default_context()
	delta :f64= (cast(^f64)p_args[0])^
	Dove_process(cast(^Dove)p_instance, delta)
}
Dove_process :: proc (self: ^Dove, delta: f64) {
	using godot
	engine := get_engine()
	is_in_editor := engine->is_editor_hint()
	if is_in_editor do return

	// @Test
	// self->set_position(Vector2{rand.float32_range(0, 20), rand.float32_range(0, 20)})

	self.time += delta
	self.total_alive_time += delta
	if self.time > 1 {
		gen_pos := Vector2_construct(rand.float64_range(0, 100), rand.float64_range(0, 100))
		generate_child_sprite(as_Node2Df(self), self->get_texture(), gen_pos)
		self.time = 0
	}
}

Dove_input_gcall :: proc "c" (p_instance: gde.GDExtensionClassInstancePtr, p_args: [^]gde.GDExtensionConstTypePtr, r_ret: gde.GDExtensionTypePtr) {
	using godot
	context = runtime.default_context()
	object_classname : StringName
	arg0 := (cast(^rawptr)p_args[0])^
	event := godot.Object {arg0, nil}
	Dove_input(cast(^Dove)p_instance, godot.as_InputEvent(event))
}
Dove_input :: proc(self: ^Dove, event: godot.InputEvent) {
	using godot
	if emouse, ok := is_InputEventMouseButton(event); ok {
		if emouse->get_button_index() == .MOUSE_BUTTON_LEFT {
			generate_child_sprite(as_Node2Df(self), self->get_texture(), emouse->get_position())
		}
	} else if ekey, ok := is_InputEventKey(event); ok {
		if ekey->is_pressed() {
			key := ekey->get_keycode()
			position := self->get_global_position()
			speed :f32= 20
			if key == .KEY_A {
				position.x += -speed
			} else if key == .KEY_D {
				position.x += speed
			}
			if key == .KEY_W {
				position.y += -speed
			} else if key == .KEY_S {
				position.y += speed
			}
			self->set_global_position(position)
		}
	}
}

generate_child_sprite :: proc(parent: godot.Node2D, texture: godot.Texture2D, position: godot.Vector2) -> godot.Sprite2D {
	using godot
	parent := parent
	spr := create_Sprite2D()
	parent->add_child(as_Node(spr), true, .INTERNAL_MODE_DISABLED)
	spr->set_texture(texture)
	spr->set_position(position)
	return spr
}
