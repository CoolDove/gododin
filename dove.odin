package main

import "base:runtime"
import "godot"
import "godot/string_name"
import gde "gdextension"

Dove :: struct {
	obj : gde.GDExtensionObjectPtr,
	hp: int,
}

DoveRegister := gde.GDExtensionClassCreationInfo2 {
	is_exposed = 1,
	create_instance_func = proc "c" (uptr: rawptr) -> gde.GDExtensionObjectPtr {
		context = runtime.default_context()
		strn_class, strn_parent : godot.StringName
		gde.string_name_new_with_utf8_chars(&strn_class, "Dove"); defer string_name.destructor(&strn_class)
		gde.string_name_new_with_utf8_chars(&strn_parent, "Node2D"); defer string_name.destructor(&strn_parent)
		obj := gde.classdb_construct_object(&strn_parent)
		instance := new(Dove)
		instance.obj = obj
		gde.object_set_instance(obj, &strn_class, instance)
		return obj
	},
	free_instance_func = proc "c" (uptr: rawptr, instance: gde.GDExtensionClassInstancePtr) {
		context = runtime.default_context()
		if instance == nil do return
		free(cast(^Dove)instance)
	},
}
