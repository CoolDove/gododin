package main

import "base:runtime"
import "core:math"
import "core:math/linalg"
import "core:fmt"
import "godot"
import gde "gdextension"


dove_instance : int

Dove :: struct {
	using gobj : godot.Object,
	id : int,
	hp: int,
	time : f64,
}

DoveRegister := gde.GDExtensionClassCreationInfo2 {
	is_exposed = gde.TRUE,
	create_instance_func = proc "c" (uptr: rawptr) -> gde.GDExtensionObjectPtr {
		using godot
		context = runtime.default_context()
		strn_class, strn_parent : StringName
		gde.string_name_new_with_utf8_chars(&strn_class, "Dove"); defer string_name_destroy(&strn_class)
		gde.string_name_new_with_utf8_chars(&strn_parent, "Sprite2D"); defer string_name_destroy(&strn_parent)
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
		gde.string_name_new_with_utf8_chars(&strn_class, "Dove"); defer string_name_destroy(&strn_class)
		instance := new(Dove)
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
		str := string_make_from_string_name(auto_cast p_name); defer string_destroy(&str)
		if string_to(&str, context.temp_allocator) == "_process" {
			return Dove_process_gcall
		}
		return nil
	},
	reference_func = proc "c" (p_instance: gde.GDExtensionClassInstancePtr) {
		context = runtime.default_context()
		godot.printfr("Dove got referenced.")
	},
	unreference_func = proc "c" (p_instance: gde.GDExtensionClassInstancePtr) {
		context = runtime.default_context()
		godot.printfr("Dove got unreferenced.")
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

Dove_process_gcall :: proc "c" (p_instance: gde.GDExtensionClassInstancePtr, p_args: [^]gde.GDExtensionConstTypePtr, r_ret: gde.GDExtensionTypePtr) {
	context = runtime.default_context()
	delta :f64= (cast(^f64)p_args[0])^
	Dove_process(cast(^Dove)p_instance, delta)
}
Dove_process :: proc (self: ^Dove, delta: f64) {
	using godot
	printfr("Hello, odin!")

	// self.time += delta
	// offset := vector2.constructor3(auto_cast math.sin(self.time), 0)
	// printfr("updating...")
	// sprite2d.set_offset(self, offset)
	// texture := sprite2d.get_texture(self); defer texture.unreference(auto_cast &texture)
	// utl.print("get texture")
	// width := texture->get_width()
	// utl.print("Texture width: ", width, ", reference count: ", texture.get_reference_count(auto_cast &texture))
}
