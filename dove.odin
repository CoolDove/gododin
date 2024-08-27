package main

import "base:runtime"
import "core:math"
import "core:math/linalg"
import "core:fmt"
import "godot"
import "godot/node"
import "godot/string_name"
import gstring "godot/string"
import "godot/vector2"
import "godot/sprite2d"
import utl "godot/utility_functions"
import gde "gdextension"

Dove :: struct {
	using _ : godot.Sprite2D,
	hp: int,
	time : f64,
}

DoveRegister := gde.GDExtensionClassCreationInfo2 {
	is_exposed = gde.TRUE,
	create_instance_func = proc "c" (uptr: rawptr) -> gde.GDExtensionObjectPtr {
		context = runtime.default_context()
		strn_class, strn_parent : godot.StringName
		gde.string_name_new_with_utf8_chars(&strn_class, "Dove"); defer string_name.destructor(&strn_class)
		gde.string_name_new_with_utf8_chars(&strn_parent, "Sprite2D"); defer string_name.destructor(&strn_parent)
		obj := gde.classdb_construct_object(&strn_parent)
		instance := new(Dove)
		instance._owner = obj
		gde.object_set_instance(obj, &strn_class, instance)
		return obj
	},
	free_instance_func = proc "c" (uptr: rawptr, instance: gde.GDExtensionClassInstancePtr) {
		context = runtime.default_context()
		if instance == nil do return
		free(cast(^Dove)instance)
	},
	get_virtual_func = proc "c" (p_class_userdata: rawptr, p_name: gde.GDExtensionConstStringNamePtr) -> gde.GDExtensionClassCallVirtual {
		context = runtime.default_context()
		strn_process : godot.String
		gde.string_new_with_utf8_chars(&strn_process, "_process"); defer gstring.destructor(&strn_process)
		if string_name.operator_OP_EQUAL1(auto_cast p_name, strn_process) {
			return Dove_process_gcall
		}
		return nil
	},
}

Dove_process_gcall :: proc "c" (p_instance: gde.GDExtensionClassInstancePtr, p_args: [^]gde.GDExtensionConstTypePtr, r_ret: gde.GDExtensionTypePtr) {
	context = runtime.default_context()
	delta :f64= (cast(^f64)p_args[0])^
	Dove_process(cast(^Dove)p_instance, delta)
}
Dove_process :: proc (self: ^Dove, delta: f64) {
	self.time += delta
	// offset :godot.Vector2= {x=auto_cast math.sin(self.time), y=0}
	offset := vector2.constructor3(auto_cast math.sin(self.time), 0)
	sprite2d.set_offset(self, offset)
	// parent := self->get_parent()
	// parent_strn := node.get_name(parent)
	// fmt.printf("parent name: {}\n", string_name_to_string(&parent_strn, context.temp_allocator))
}
