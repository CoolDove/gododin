package main

import "base:runtime"
import "core:math"
import "core:math/linalg"
import "core:fmt"
import "godot"
import gde "gdextension"

Dove :: struct {
	hp: int,
	time : f64,
}

DoveRegister := gde.GDExtensionClassCreationInfo2 {
	is_exposed = gde.TRUE,
	create_instance_func = proc "c" (uptr: rawptr) -> gde.GDExtensionObjectPtr {
		using godot
		context = runtime.default_context()
		strn_class, strn_parent : StringName
		gde.string_name_new_with_utf8_chars(&strn_class, "Dove")// ; defer variant_destroy(auto_cast &strn_class)
		gde.string_name_new_with_utf8_chars(&strn_parent, "Sprite2D")// ; defer variant_destroy(auto_cast &strn_parent)
		obj := gde.classdb_construct_object(&strn_parent)
		instance := new(Dove)
		gde.object_set_instance(obj, &strn_class, instance)

		d :float= 12.0
		v := variant_from_Vector2(Vector2{6,6}); defer variant_destroy(&v)
		fmt.printf("vector: {}\n", v)
		return obj
	},
	free_instance_func = proc "c" (uptr: rawptr, instance: gde.GDExtensionClassInstancePtr) {
		context = runtime.default_context()
		if instance == nil do return
		free(cast(^Dove)instance)
	},
	get_virtual_func = proc "c" (p_class_userdata: rawptr, p_name: gde.GDExtensionConstStringNamePtr) -> gde.GDExtensionClassCallVirtual {
		// context = runtime.default_context()
		// strn_process : godot.String
		// if string_name.to_string(auto_cast p_name) == "_process" {
		// 	return Dove_process_gcall
		// }
		return nil
	},
}

Dove_process_gcall :: proc "c" (p_instance: gde.GDExtensionClassInstancePtr, p_args: [^]gde.GDExtensionConstTypePtr, r_ret: gde.GDExtensionTypePtr) {
	context = runtime.default_context()
	delta :f64= (cast(^f64)p_args[0])^
	Dove_process(cast(^Dove)p_instance, delta)
}
Dove_process :: proc (self: ^Dove, delta: f64) {
	using godot
	d :float= 12.0
	v := variant_from_Vector2(Vector2{6,6}); defer variant_destroy(&v)

	// utl.print("process...")
	// self.time += delta
	// offset := vector2.constructor3(auto_cast math.sin(self.time), 0)
	// utl.print("cons offset")
	// sprite2d.set_offset(self, offset)
	// texture := sprite2d.get_texture(self); defer texture.unreference(auto_cast &texture)
	// utl.print("get texture")
	// width := texture->get_width()
	// utl.print("Texture width: ", width, ", reference count: ", texture.get_reference_count(auto_cast &texture))
}
