package main

import gde "gdextension"
import "core:fmt"
import "base:runtime"
import utl "godot/utility_functions"

@export
_entry :: proc "c" (proc_load: gde.GDExtensionInterfaceGetProcAddress, library: gde.GDExtensionClassLibraryPtr, initialization: ^gde.GDExtensionInitialization) -> gde.GDExtensionBool {
	context = runtime.default_context()
	gde.initialize_procs(proc_load)

	initialization.initialize = _initialize
	initialization.deinitialize = _deinitialize

	utl.print("Odin extension loaded.\n")

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
