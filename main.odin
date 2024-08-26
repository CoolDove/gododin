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
	
	return gde.TRUE
}

_initialize :: proc "c" (u: rawptr, l: gde.GDExtensionInitializationLevel) {
	context = runtime.default_context()
	if (l != .GDEXTENSION_INITIALIZATION_SCENE) do return
	utl.print("Odin extension initialized\n")

	strn_class, strn_parent : godot.StringName

	gde.string_name_new_with_utf8_chars(&strn_class, "Dove"); defer string_name.destructor(&strn_class)
	gde.string_name_new_with_utf8_chars(&strn_parent, "Node2D"); defer string_name.destructor(&strn_parent)

	gde.classdb_register_extension_class2(god.library, &strn_class, &strn_parent, &DoveRegister)

}
_deinitialize :: proc "c" (u: rawptr, l: gde.GDExtensionInitializationLevel) {
	if (l != .GDEXTENSION_INITIALIZATION_SCENE) do return
	context = runtime.default_context()
	utl.print("Odin extension uninitialized\n")
}
