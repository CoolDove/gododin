package main

import gde "gdextension"
import "core:fmt"
import "core:reflect"
import "core:mem"
import "base:runtime"
import godot "godot"


God :: struct {
	library: gde.GDExtensionClassLibraryPtr,
	initialization: ^gde.GDExtensionInitialization,
}

god : God

@export
_entry :: proc "c" (proc_load: gde.GDExtensionInterfaceGetProcAddress, library: gde.GDExtensionClassLibraryPtr, initialization: ^gde.GDExtensionInitialization) -> gde.GDExtensionBool {
	context = runtime.default_context()
	gde.initialize_procs(proc_load)

	initialization.minimum_initialization_level = .GDEXTENSION_INITIALIZATION_SCENE
	initialization.initialize = _initialize
	initialization.deinitialize = _deinitialize

	god.library = library
	god.initialization = initialization

	godot.printfr("[color=green][b]Godin[/b][/color] extension loaded.")
	
	return gde.TRUE
}

_initialize :: proc "c" (u: rawptr, l: gde.GDExtensionInitializationLevel) {
	context = runtime.default_context()
	using godot
	if (l != .GDEXTENSION_INITIALIZATION_SCENE) do return
	gododin_initialize()

	registered_classes = make(map[string]^ExtensionClass)
	printfr("[color=yellow]Odin[/color] extension initialized")

	register_class(Dove)
}
_deinitialize :: proc "c" (u: rawptr, l: gde.GDExtensionInitializationLevel) {
	if (l != .GDEXTENSION_INITIALIZATION_SCENE) do return
	context = runtime.default_context()
	using godot
	delete(registered_classes)

	unregister_classes()

	gododin_uninitialize()
}

registered_classes : map[string]^ExtensionClass
register_class :: proc(T: typeid) {
	names := reflect.struct_field_names(T)
	assert(len(names)>0, fmt.tprintf("Cannot register class {}, because of 0 fields.\n", T))
	types := reflect.struct_field_types(T)
	tags := reflect.struct_field_tags(T)

	class := new(ExtensionClass)
	class.type = T
	class.class_name = fmt.aprintf("{}", T)
	class.inherit_class_name = fmt.aprintf("{}", types[0])
	class.strn_class = godot.string_name_make(fmt.ctprintf("{}", T))
	class.strn_inherit_class = godot.string_name_make(fmt.ctprintf("{}", types[0]))

	for i in 0..<len(names) {
		fname := names[i]
		ftype := types[i]
		ftag := tags[i]
		if gtag, ok := reflect.struct_tag_lookup(ftag, "godot"); ok {
			godot.printfr("[color=yellow]godot tag: {} ({})[/color]", gtag, fname)
		}
	}
	class.register = new(gde.GDExtensionClassCreationInfo2)
	class.register^ = _ClassRegister
	class.register.class_userdata = class

	gde.classdb_register_extension_class2(god.library, &class.strn_class, &class.strn_inherit_class, class.register)
	godot.printfr("[color=green]Register class {}:{}.[/color]", T, types[0])
}

unregister_classes :: proc() {
	for name, &class in registered_classes {
		gde.classdb_unregister_extension_class(god.library, &class.strn_class)
		delete(class.class_name)
		delete(class.inherit_class_name)
		godot.StringName_destruct(class.strn_class)
		godot.StringName_destruct(class.strn_inherit_class)
		free(class.register)
		free(class)
	}
	clear(&registered_classes)
}

ExtensionClass :: struct {
	type : typeid,
	table : rawptr,
	class_name, inherit_class_name : string,
	strn_class, strn_inherit_class : godot.StringName,
	register : ^gde.GDExtensionClassCreationInfo2,
}

@(private="file")
_ClassRegister := gde.GDExtensionClassCreationInfo2 {
	is_exposed = gde.TRUE,
	create_instance_func = proc "c" (uptr: rawptr) -> gde.GDExtensionObjectPtr {
		using godot
		context = runtime.default_context()
		class := cast(^ExtensionClass)uptr
		printfr(">to create {}", class.type)
		obj := gde.classdb_construct_object(&class.strn_inherit_class)
		printfr(">object constructed")
		instance_mem, _ := mem.alloc(type_info_of(class.type).size)
		instance := cast(^Object)instance_mem
		instance._obj = obj
		instance._table = godot.godot_classes[class.class_name].table

		gde.object_free_instance_binding(obj, god.library)
		gde.object_set_instance_binding(obj, god.library, instance, &_binding_callback)
		gde.object_set_instance(obj, &class.strn_class, instance)
		printfr("[color=green]{}[/color] instance created.", class.type)
		return obj
	},
	recreate_instance_func = proc "c" (uptr: rawptr, p_object: gde.GDExtensionObjectPtr) -> gde.GDExtensionClassInstancePtr {
		using godot
		context = runtime.default_context()
		class := cast(^ExtensionClass)uptr
		printfr("[color=yellow]{}[/color] recreate", class.type)
		instance_mem, _ := mem.alloc(type_info_of(class.type).size)
		instance := cast(^Object)instance_mem
		instance._obj = p_object
		instance._table = &godot.__Sprite2D_table
		gde.object_set_instance(p_object, &class.strn_class, instance)
		return instance
	},
	free_instance_func = proc "c" (uptr: rawptr, instance: gde.GDExtensionClassInstancePtr) {
		using godot
		context = runtime.default_context()
		class := cast(^ExtensionClass)uptr
		if instance == nil do return
		printfr("[color=red]{}[/color] instance freed.", class.type)
		free(instance)
	},
	// get_virtual_func = proc "c" (uptr: rawptr, p_name: gde.GDExtensionConstStringNamePtr) -> gde.GDExtensionClassCallVirtual {
	// 	context = runtime.default_context()
	// 	using godot
	// 	strn := p_name
	// 	str := String_construct((cast(^StringName)p_name)^); defer String_destruct(str)
	// 	virtual_func_name := string_to(&str, context.temp_allocator)
	// 	if virtual_func_name == "_process" {
	// 		return Dove_process_gcall
	// 	} else if virtual_func_name == "_input" {
	// 		return Dove_input_gcall
	// 	}
	// 	return nil
	// }
}

@(private="file")
_binding_callback := gde.GDExtensionInstanceBindingCallbacks {
	create_callback = proc "c" (p_token: rawptr, p_instance: rawptr) -> rawptr {
		context = runtime.default_context()
		godot.printfr("[color=red] class create binding callback [/color]")
		return nil
	},
	free_callback = proc "c" (p_token: rawptr, p_instance: rawptr, p_binding: rawptr) {
		context = runtime.default_context()
		godot.printfr("[color=red] class free binding callback [/color]")
	},
	reference_callback = proc "c" (p_token: rawptr, p_binding: rawptr, p_reference: gde.GDExtensionBool) -> gde.GDExtensionBool {
		context = runtime.default_context()
		godot.printfr("[color=red] class reference callback [/color]")
		return gde.TRUE
	}
}
