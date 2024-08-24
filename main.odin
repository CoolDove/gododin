package main

import gde "gdextension"
import "core:fmt"
import "base:runtime"
import utl "godot/utility_functions"
import "godot/string_name"
import gstring "godot/string"
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

	utl.print_rich("[color=green][b]Godin[/b][/color] extension loaded.\n")

	strn_class : godot.StringName
	strn_parent : godot.StringName
	utl.print_rich("godot maxi: [u]", utl.maxi(10, -11), "[/u]\n")
	
	gde.string_name_new_with_utf8_chars(&strn_class, "Dove")
	gde.string_name_new_with_utf8_chars(&strn_class, "Node")
	fmt.printf("string name Dove created, strn_class: {}, strn_node: {}\n", strn_class.opaque, strn_parent.opaque)
	utl.print_rich("length of class name: [b]", string_name.length(&strn_class), "[/b].")

	return gde.TRUE
}

_initialize :: proc "c" (u: rawptr, l: gde.GDExtensionInitializationLevel) {
	context = runtime.default_context()
	utl.print("Odin extension initialized\n")
}
_deinitialize :: proc "c" (u: rawptr, l: gde.GDExtensionInitializationLevel) {
	context = runtime.default_context()
	utl.print("Odin extension uninitialized\n")
}
