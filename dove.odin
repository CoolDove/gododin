package main

import "base:runtime"
import "core:math"
import "core:math/linalg"
import "core:fmt"
// import "godot"
import gde "gdextension"

Dove :: struct {
	hp: int,
	time : f64,
}

DoveRegister := gde.GDExtensionClassCreationInfo2 {
	is_exposed = gde.TRUE,
	create_instance_func = proc "c" (uptr: rawptr) -> gde.GDExtensionObjectPtr {
		context = runtime.default_context()
		return {}
		// strn_class, strn_parent : godot.StringName
		// gde.string_name_new_with_utf8_chars(&strn_class, "Dove"); defer string_name.destructor(&strn_class)
		// gde.string_name_new_with_utf8_chars(&strn_parent, "Sprite2D"); defer string_name.destructor(&strn_parent)
		// obj := gde.classdb_construct_object(&strn_parent)
		// instance := new(Dove)
		// instance._owner = obj
		// gde.object_set_instance(obj, &strn_class, instance)
		// return obj
	},
	free_instance_func = proc "c" (uptr: rawptr, instance: gde.GDExtensionClassInstancePtr) {
		context = runtime.default_context()
		// if instance == nil do return
		// free(cast(^Dove)instance)
	},
	get_virtual_func = proc "c" (p_class_userdata: rawptr, p_name: gde.GDExtensionConstStringNamePtr) -> gde.GDExtensionClassCallVirtual {
		context = runtime.default_context()
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
	spike : ObjSpike
	spike->do_foo(32)
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

Obj :: struct #raw_union {
	dove : ObjDove,
	spike : ObjSpike
}

ObjDove :: struct {
	ptr: rawptr,
	using _table : ^ObjDove_TABLE,
}
ObjDove_TABLE :: struct {
	do_foo : proc(rawptr, f64),
	do_bar : proc(rawptr, f64),
}
ObjSpike :: struct {
	ptr: rawptr,
	using _table : ^ObjSpike_TABLE,
}
ObjSpike_TABLE :: struct {
	using _ : ^ObjDove_TABLE,
	do_foos : proc(rawptr, i64),
	do_bars : proc(rawptr, i64),
}
