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
	return godot.as_Engine({gde.global_get_singleton(&strn), nil})
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
	self->set_position(Vector2{rand.float32_range(0, 20), rand.float32_range(0, 20)})

	self.time += delta
	self.total_alive_time += delta
	if self.time > 3.0 {
		spr := create_Sprite2D()
		self->add_child(transmute(Node)spr, true, .INTERNAL_MODE_DISABLED)
		tex := godot.as_Texture2D(transmute(Object)self->get_texture()); defer tex->unreference()
		spr->set_texture(tex)
		spr->set_position(Vector2_construct(rand.float64_range(0, 100), rand.float64_range(0, 100)))
		self.time = 0
	}
}

Dove_input_gcall :: proc "c" (p_instance: gde.GDExtensionClassInstancePtr, p_args: [^]gde.GDExtensionConstTypePtr, r_ret: gde.GDExtensionTypePtr) {
	context = runtime.default_context()
	event := godot.Object {p_args[0], nil}
	Dove_input(cast(^Dove)p_instance, godot.as_InputEvent(event))
}
Dove_input :: proc(self: ^Dove, event: godot.InputEvent) {
	event:=event
	// event_string := event->as_text()
	godot.printfr(" got event from device: {}", event->get_device())
	
	if event->is_pressed() {
		godot.printfr("you pressed something")
	}
}
