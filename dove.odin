package main

import "base:runtime"
import "core:math"
import "core:math/linalg"
import "core:math/rand"
import "core:fmt"
import "godot"
import gde "gdextension"


dove_instance : int

Dove :: struct {
	using gobj : godot.Sprite2D,
	id : int,
	hp: int,
	time : f64,
	total_alive_time : f64,
}

DoveRegister := gde.GDExtensionClassCreationInfo2 {
	is_exposed = gde.TRUE,
	create_instance_func = proc "c" (uptr: rawptr) -> gde.GDExtensionObjectPtr {
		using godot
		context = runtime.default_context()
		strn_class, strn_parent : StringName
		gde.string_name_new_with_utf8_chars(&strn_class, "Dove"); defer StringName_destruct(strn_class)
		gde.string_name_new_with_utf8_chars(&strn_parent, "Sprite2D"); defer StringName_destruct(strn_parent)
		obj := gde.classdb_construct_object(&strn_parent)
		instance := new(Dove)
		instance._obj = obj
		instance._table = &godot.__Sprite2D_table

		instance.id = dove_instance
		dove_instance += 1
		gde.object_free_instance_binding(obj, god.library)
		gde.object_set_instance_binding(obj, god.library, instance, &Dove_binding_callback)
		gde.object_set_instance(obj, &strn_class, instance)
		printfr("[color=green]Dove[/color] {} instance created.", instance.id)
		return obj
	},
	recreate_instance_func = proc "c" (p_class_userdata: rawptr, p_object: gde.GDExtensionObjectPtr) -> gde.GDExtensionClassInstancePtr {
		using godot
		context = runtime.default_context()
		printfr("[color=yellow]Dove[/color] recreate")
		strn_class : StringName
		gde.string_name_new_with_utf8_chars(&strn_class, "Dove"); defer StringName_destruct(strn_class)
		instance := new(Dove)
		instance._obj = p_object
		instance._table = &godot.__Sprite2D_table
		gde.object_set_instance(p_object, &strn_class, instance)
		return instance
	},
	free_instance_func = proc "c" (uptr: rawptr, instance: gde.GDExtensionClassInstancePtr) {
		using godot
		context = runtime.default_context()
		instance := cast(^Dove)instance
		if instance == nil do return
		printfr("[color=red]Dove[/color] {} instance freed.", instance.id)
		free(instance)
	},
	get_virtual_func = proc "c" (p_class_userdata: rawptr, p_name: gde.GDExtensionConstStringNamePtr) -> gde.GDExtensionClassCallVirtual {
		context = runtime.default_context()
		using godot
		strn := p_name
		str := String_construct((cast(^StringName)p_name)^); defer String_destruct(str)
		virtual_func_name := string_to(&str, context.temp_allocator)
		if virtual_func_name == "_process" {
			return Dove_process_gcall
		} else if virtual_func_name == "_input" {
			return Dove_input_gcall
		}
		return nil
	}
}

Dove_binding_callback := gde.GDExtensionInstanceBindingCallbacks {
	create_callback = proc "c" (p_token: rawptr, p_instance: rawptr) -> rawptr {
		context = runtime.default_context()
		godot.printfr("[color=red] Dove create callback [/color]")
		return nil
	},
	free_callback = proc "c" (p_token: rawptr, p_instance: rawptr, p_binding: rawptr) {
		context = runtime.default_context()
		godot.printfr("[color=red] Dove free callback [/color]")
	},
	reference_callback = proc "c" (p_token: rawptr, p_binding: rawptr, p_reference: gde.GDExtensionBool) -> gde.GDExtensionBool {
		context = runtime.default_context()
		godot.printfr("[color=red] Dove reference callback [/color]")
		return gde.TRUE
	}
}

get_engine :: proc() -> godot.Engine {
	@static strn : godot.StringName
	if strn == {} do gde.string_name_new_with_utf8_chars(&strn, "Engine")
	obj := godot.Object{gde.global_get_singleton(&strn), nil}
	return godot.as_Engine(obj)
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
