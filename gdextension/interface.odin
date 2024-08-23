package gdextension

/**
 * @name mem_alloc
 * @since 4.1
 *
 * Allocates memory.
 *
 * @param p_bytes The amount of memory to allocate in bytes.
 *
 * @return A pointer to the allocated memory, or NULL if unsuccessful.
 */
mem_alloc: GDExtensionInterfaceMemAlloc

/**
 * @name mem_realloc
 * @since 4.1
 *
 * Reallocates memory.
 *
 * @param p_ptr A pointer to the previously allocated memory.
 * @param p_bytes The number of bytes to resize the memory block to.
 *
 * @return A pointer to the allocated memory, or NULL if unsuccessful.
 */
mem_realloc: GDExtensionInterfaceMemRealloc

/**
 * @name mem_free
 * @since 4.1
 *
 * Frees memory.
 *
 * @param p_ptr A pointer to the previously allocated memory.
 */
mem_free: GDExtensionInterfaceMemFree

/**
 * @name print_error
 * @since 4.1
 *
 * Logs an error to Godot's built-in debugger and to the OS terminal.
 *
 * @param p_description The code trigging the error.
 * @param p_function The function name where the error occurred.
 * @param p_file The file where the error occurred.
 * @param p_line The line where the error occurred.
 * @param p_editor_notify Whether or not to notify the editor.
 */
print_error: GDExtensionInterfacePrintError

/**
 * @name print_error_with_message
 * @since 4.1
 *
 * Logs an error with a message to Godot's built-in debugger and to the OS terminal.
 *
 * @param p_description The code trigging the error.
 * @param p_message The message to show along with the error.
 * @param p_function The function name where the error occurred.
 * @param p_file The file where the error occurred.
 * @param p_line The line where the error occurred.
 * @param p_editor_notify Whether or not to notify the editor.
 */
print_error_with_message: GDExtensionInterfacePrintErrorWithMessage

/**
 * @name print_warning
 * @since 4.1
 *
 * Logs a warning to Godot's built-in debugger and to the OS terminal.
 *
 * @param p_description The code trigging the warning.
 * @param p_function The function name where the warning occurred.
 * @param p_file The file where the warning occurred.
 * @param p_line The line where the warning occurred.
 * @param p_editor_notify Whether or not to notify the editor.
 */
print_warning: GDExtensionInterfacePrintWarning

/**
 * @name print_warning_with_message
 * @since 4.1
 *
 * Logs a warning with a message to Godot's built-in debugger and to the OS terminal.
 *
 * @param p_description The code trigging the warning.
 * @param p_message The message to show along with the warning.
 * @param p_function The function name where the warning occurred.
 * @param p_file The file where the warning occurred.
 * @param p_line The line where the warning occurred.
 * @param p_editor_notify Whether or not to notify the editor.
 */
print_warning_with_message: GDExtensionInterfacePrintWarningWithMessage

/**
 * @name print_script_error
 * @since 4.1
 *
 * Logs a script error to Godot's built-in debugger and to the OS terminal.
 *
 * @param p_description The code trigging the error.
 * @param p_function The function name where the error occurred.
 * @param p_file The file where the error occurred.
 * @param p_line The line where the error occurred.
 * @param p_editor_notify Whether or not to notify the editor.
 */
print_script_error: GDExtensionInterfacePrintScriptError

/**
 * @name print_script_error_with_message
 * @since 4.1
 *
 * Logs a script error with a message to Godot's built-in debugger and to the OS terminal.
 *
 * @param p_description The code trigging the error.
 * @param p_message The message to show along with the error.
 * @param p_function The function name where the error occurred.
 * @param p_file The file where the error occurred.
 * @param p_line The line where the error occurred.
 * @param p_editor_notify Whether or not to notify the editor.
 */
print_script_error_with_message: GDExtensionInterfacePrintScriptErrorWithMessage

/**
 * @name get_native_struct_size
 * @since 4.1
 *
 * Gets the size of a native struct (ex. ObjectID) in bytes.
 *
 * @param p_name A pointer to a StringName identifying the struct name.
 *
 * @return The size in bytes.
 */
get_native_struct_size: GDExtensionInterfaceGetNativeStructSize

/**
 * @name variant_new_copy
 * @since 4.1
 *
 * Copies one Variant into a another.
 *
 * @param r_dest A pointer to the destination Variant.
 * @param p_src A pointer to the source Variant.
 */
variant_new_copy: GDExtensionInterfaceVariantNewCopy

/**
 * @name variant_new_nil
 * @since 4.1
 *
 * Creates a new Variant containing nil.
 *
 * @param r_dest A pointer to the destination Variant.
 */
variant_new_nil: GDExtensionInterfaceVariantNewNil

/**
 * @name variant_destroy
 * @since 4.1
 *
 * Destroys a Variant.
 *
 * @param p_self A pointer to the Variant to destroy.
 */
variant_destroy: GDExtensionInterfaceVariantDestroy

/**
 * @name variant_call
 * @since 4.1
 *
 * Calls a method on a Variant.
 *
 * @param p_self A pointer to the Variant.
 * @param p_method A pointer to a StringName identifying the method.
 * @param p_args A pointer to a C array of Variant.
 * @param p_argument_count The number of arguments.
 * @param r_return A pointer a Variant which will be assigned the return value.
 * @param r_error A pointer the structure which will hold error information.
 *
 * @see Variant::callp()
 */
variant_call: GDExtensionInterfaceVariantCall

/**
 * @name variant_call_static
 * @since 4.1
 *
 * Calls a static method on a Variant.
 *
 * @param p_self A pointer to the Variant.
 * @param p_method A pointer to a StringName identifying the method.
 * @param p_args A pointer to a C array of Variant.
 * @param p_argument_count The number of arguments.
 * @param r_return A pointer a Variant which will be assigned the return value.
 * @param r_error A pointer the structure which will be updated with error information.
 *
 * @see Variant::call_static()
 */
variant_call_static: GDExtensionInterfaceVariantCallStatic

/**
 * @name variant_evaluate
 * @since 4.1
 *
 * Evaluate an operator on two Variants.
 *
 * @param p_op The operator to evaluate.
 * @param p_a The first Variant.
 * @param p_b The second Variant.
 * @param r_return A pointer a Variant which will be assigned the return value.
 * @param r_valid A pointer to a boolean which will be set to false if the operation is invalid.
 *
 * @see Variant::evaluate()
 */
variant_evaluate: GDExtensionInterfaceVariantEvaluate

/**
 * @name variant_set
 * @since 4.1
 *
 * Sets a key on a Variant to a value.
 *
 * @param p_self A pointer to the Variant.
 * @param p_key A pointer to a Variant representing the key.
 * @param p_value A pointer to a Variant representing the value.
 * @param r_valid A pointer to a boolean which will be set to false if the operation is invalid.
 *
 * @see Variant::set()
 */
variant_set: GDExtensionInterfaceVariantSet

/**
 * @name variant_set_named
 * @since 4.1
 *
 * Sets a named key on a Variant to a value.
 *
 * @param p_self A pointer to the Variant.
 * @param p_key A pointer to a StringName representing the key.
 * @param p_value A pointer to a Variant representing the value.
 * @param r_valid A pointer to a boolean which will be set to false if the operation is invalid.
 *
 * @see Variant::set_named()
 */
variant_set_named: GDExtensionInterfaceVariantSetNamed

/**
 * @name variant_set_keyed
 * @since 4.1
 *
 * Sets a keyed property on a Variant to a value.
 *
 * @param p_self A pointer to the Variant.
 * @param p_key A pointer to a Variant representing the key.
 * @param p_value A pointer to a Variant representing the value.
 * @param r_valid A pointer to a boolean which will be set to false if the operation is invalid.
 *
 * @see Variant::set_keyed()
 */
variant_set_keyed: GDExtensionInterfaceVariantSetKeyed

/**
 * @name variant_set_indexed
 * @since 4.1
 *
 * Sets an index on a Variant to a value.
 *
 * @param p_self A pointer to the Variant.
 * @param p_index The index.
 * @param p_value A pointer to a Variant representing the value.
 * @param r_valid A pointer to a boolean which will be set to false if the operation is invalid.
 * @param r_oob A pointer to a boolean which will be set to true if the index is out of bounds.
 */
variant_set_indexed: GDExtensionInterfaceVariantSetIndexed

/**
 * @name variant_get
 * @since 4.1
 *
 * Gets the value of a key from a Variant.
 *
 * @param p_self A pointer to the Variant.
 * @param p_key A pointer to a Variant representing the key.
 * @param r_ret A pointer to a Variant which will be assigned the value.
 * @param r_valid A pointer to a boolean which will be set to false if the operation is invalid.
 */
variant_get: GDExtensionInterfaceVariantGet

/**
 * @name variant_get_named
 * @since 4.1
 *
 * Gets the value of a named key from a Variant.
 *
 * @param p_self A pointer to the Variant.
 * @param p_key A pointer to a StringName representing the key.
 * @param r_ret A pointer to a Variant which will be assigned the value.
 * @param r_valid A pointer to a boolean which will be set to false if the operation is invalid.
 */
variant_get_named: GDExtensionInterfaceVariantGetNamed

/**
 * @name variant_get_keyed
 * @since 4.1
 *
 * Gets the value of a keyed property from a Variant.
 *
 * @param p_self A pointer to the Variant.
 * @param p_key A pointer to a Variant representing the key.
 * @param r_ret A pointer to a Variant which will be assigned the value.
 * @param r_valid A pointer to a boolean which will be set to false if the operation is invalid.
 */
variant_get_keyed: GDExtensionInterfaceVariantGetKeyed

/**
 * @name variant_get_indexed
 * @since 4.1
 *
 * Gets the value of an index from a Variant.
 *
 * @param p_self A pointer to the Variant.
 * @param p_index The index.
 * @param r_ret A pointer to a Variant which will be assigned the value.
 * @param r_valid A pointer to a boolean which will be set to false if the operation is invalid.
 * @param r_oob A pointer to a boolean which will be set to true if the index is out of bounds.
 */
variant_get_indexed: GDExtensionInterfaceVariantGetIndexed

/**
 * @name variant_iter_init
 * @since 4.1
 *
 * Initializes an iterator over a Variant.
 *
 * @param p_self A pointer to the Variant.
 * @param r_iter A pointer to a Variant which will be assigned the iterator.
 * @param r_valid A pointer to a boolean which will be set to false if the operation is invalid.
 *
 * @return true if the operation is valid; otherwise false.
 *
 * @see Variant::iter_init()
 */
variant_iter_init: GDExtensionInterfaceVariantIterInit

/**
 * @name variant_iter_next
 * @since 4.1
 *
 * Gets the next value for an iterator over a Variant.
 *
 * @param p_self A pointer to the Variant.
 * @param r_iter A pointer to a Variant which will be assigned the iterator.
 * @param r_valid A pointer to a boolean which will be set to false if the operation is invalid.
 *
 * @return true if the operation is valid; otherwise false.
 *
 * @see Variant::iter_next()
 */
variant_iter_next: GDExtensionInterfaceVariantIterNext

/**
 * @name variant_iter_get
 * @since 4.1
 *
 * Gets the next value for an iterator over a Variant.
 *
 * @param p_self A pointer to the Variant.
 * @param r_iter A pointer to a Variant which will be assigned the iterator.
 * @param r_ret A pointer to a Variant which will be assigned false if the operation is invalid.
 * @param r_valid A pointer to a boolean which will be set to false if the operation is invalid.
 *
 * @see Variant::iter_get()
 */
variant_iter_get: GDExtensionInterfaceVariantIterGet

/**
 * @name variant_hash
 * @since 4.1
 *
 * Gets the hash of a Variant.
 *
 * @param p_self A pointer to the Variant.
 *
 * @return The hash value.
 *
 * @see Variant::hash()
 */
variant_hash: GDExtensionInterfaceVariantHash

/**
 * @name variant_recursive_hash
 * @since 4.1
 *
 * Gets the recursive hash of a Variant.
 *
 * @param p_self A pointer to the Variant.
 * @param p_recursion_count The number of recursive loops so far.
 *
 * @return The hash value.
 *
 * @see Variant::recursive_hash()
 */
variant_recursive_hash: GDExtensionInterfaceVariantRecursiveHash

/**
 * @name variant_hash_compare
 * @since 4.1
 *
 * Compares two Variants by their hash.
 *
 * @param p_self A pointer to the Variant.
 * @param p_other A pointer to the other Variant to compare it to.
 *
 * @return The hash value.
 *
 * @see Variant::hash_compare()
 */
variant_hash_compare: GDExtensionInterfaceVariantHashCompare

/**
 * @name variant_booleanize
 * @since 4.1
 *
 * Converts a Variant to a boolean.
 *
 * @param p_self A pointer to the Variant.
 *
 * @return The boolean value of the Variant.
 */
variant_booleanize: GDExtensionInterfaceVariantBooleanize

/**
 * @name variant_duplicate
 * @since 4.1
 *
 * Duplicates a Variant.
 *
 * @param p_self A pointer to the Variant.
 * @param r_ret A pointer to a Variant to store the duplicated value.
 * @param p_deep Whether or not to duplicate deeply (when supported by the Variant type).
 */
variant_duplicate: GDExtensionInterfaceVariantDuplicate

/**
 * @name variant_stringify
 * @since 4.1
 *
 * Converts a Variant to a string.
 *
 * @param p_self A pointer to the Variant.
 * @param r_ret A pointer to a String to store the resulting value.
 */
variant_stringify: GDExtensionInterfaceVariantStringify

/**
 * @name variant_get_type
 * @since 4.1
 *
 * Gets the type of a Variant.
 *
 * @param p_self A pointer to the Variant.
 *
 * @return The variant type.
 */
variant_get_type: GDExtensionInterfaceVariantGetType

/**
 * @name variant_has_method
 * @since 4.1
 *
 * Checks if a Variant has the given method.
 *
 * @param p_self A pointer to the Variant.
 * @param p_method A pointer to a StringName with the method name.
 *
 * @return
 */
variant_has_method: GDExtensionInterfaceVariantHasMethod

/**
 * @name variant_has_member
 * @since 4.1
 *
 * Checks if a type of Variant has the given member.
 *
 * @param p_type The Variant type.
 * @param p_member A pointer to a StringName with the member name.
 *
 * @return
 */
variant_has_member: GDExtensionInterfaceVariantHasMember

/**
 * @name variant_has_key
 * @since 4.1
 *
 * Checks if a Variant has a key.
 *
 * @param p_self A pointer to the Variant.
 * @param p_key A pointer to a Variant representing the key.
 * @param r_valid A pointer to a boolean which will be set to false if the key doesn't exist.
 *
 * @return true if the key exists; otherwise false.
 */
variant_has_key: GDExtensionInterfaceVariantHasKey

/**
 * @name variant_get_type_name
 * @since 4.1
 *
 * Gets the name of a Variant type.
 *
 * @param p_type The Variant type.
 * @param r_name A pointer to a String to store the Variant type name.
 */
variant_get_type_name: GDExtensionInterfaceVariantGetTypeName

/**
 * @name variant_can_convert
 * @since 4.1
 *
 * Checks if Variants can be converted from one type to another.
 *
 * @param p_from The Variant type to convert from.
 * @param p_to The Variant type to convert to.
 *
 * @return true if the conversion is possible; otherwise false.
 */
variant_can_convert: GDExtensionInterfaceVariantCanConvert

/**
 * @name variant_can_convert_strict
 * @since 4.1
 *
 * Checks if Variant can be converted from one type to another using stricter rules.
 *
 * @param p_from The Variant type to convert from.
 * @param p_to The Variant type to convert to.
 *
 * @return true if the conversion is possible; otherwise false.
 */
variant_can_convert_strict: GDExtensionInterfaceVariantCanConvertStrict

/**
 * @name get_variant_from_type_constructor
 * @since 4.1
 *
 * Gets a pointer to a function that can create a Variant of the given type from a raw value.
 *
 * @param p_type The Variant type.
 *
 * @return A pointer to a function that can create a Variant of the given type from a raw value.
 */
get_variant_from_type_constructor: GDExtensionInterfaceGetVariantFromTypeConstructor

/**
 * @name get_variant_to_type_constructor
 * @since 4.1
 *
 * Gets a pointer to a function that can get the raw value from a Variant of the given type.
 *
 * @param p_type The Variant type.
 *
 * @return A pointer to a function that can get the raw value from a Variant of the given type.
 */
get_variant_to_type_constructor: GDExtensionInterfaceGetVariantToTypeConstructor

/**
 * @name variant_get_ptr_operator_evaluator
 * @since 4.1
 *
 * Gets a pointer to a function that can evaluate the given Variant operator on the given Variant types.
 *
 * @param p_operator The variant operator.
 * @param p_type_a The type of the first Variant.
 * @param p_type_b The type of the second Variant.
 *
 * @return A pointer to a function that can evaluate the given Variant operator on the given Variant types.
 */
variant_get_ptr_operator_evaluator: GDExtensionInterfaceVariantGetPtrOperatorEvaluator

/**
 * @name variant_get_ptr_builtin_method
 * @since 4.1
 *
 * Gets a pointer to a function that can call a builtin method on a type of Variant.
 *
 * @param p_type The Variant type.
 * @param p_method A pointer to a StringName with the method name.
 * @param p_hash A hash representing the method signature.
 *
 * @return A pointer to a function that can call a builtin method on a type of Variant.
 */
variant_get_ptr_builtin_method: GDExtensionInterfaceVariantGetPtrBuiltinMethod

/**
 * @name variant_get_ptr_constructor
 * @since 4.1
 *
 * Gets a pointer to a function that can call one of the constructors for a type of Variant.
 *
 * @param p_type The Variant type.
 * @param p_constructor The index of the constructor.
 *
 * @return A pointer to a function that can call one of the constructors for a type of Variant.
 */
variant_get_ptr_constructor: GDExtensionInterfaceVariantGetPtrConstructor

/**
 * @name variant_get_ptr_destructor
 * @since 4.1
 *
 * Gets a pointer to a function than can call the destructor for a type of Variant.
 *
 * @param p_type The Variant type.
 *
 * @return A pointer to a function than can call the destructor for a type of Variant.
 */
variant_get_ptr_destructor: GDExtensionInterfaceVariantGetPtrDestructor

/**
 * @name variant_construct
 * @since 4.1
 *
 * Constructs a Variant of the given type, using the first constructor that matches the given arguments.
 *
 * @param p_type The Variant type.
 * @param p_base A pointer to a Variant to store the constructed value.
 * @param p_args A pointer to a C array of Variant pointers representing the arguments for the constructor.
 * @param p_argument_count The number of arguments to pass to the constructor.
 * @param r_error A pointer the structure which will be updated with error information.
 */
variant_construct: GDExtensionInterfaceVariantConstruct

/**
 * @name variant_get_ptr_setter
 * @since 4.1
 *
 * Gets a pointer to a function that can call a member's setter on the given Variant type.
 *
 * @param p_type The Variant type.
 * @param p_member A pointer to a StringName with the member name.
 *
 * @return A pointer to a function that can call a member's setter on the given Variant type.
 */
variant_get_ptr_setter: GDExtensionInterfaceVariantGetPtrSetter

/**
 * @name variant_get_ptr_getter
 * @since 4.1
 *
 * Gets a pointer to a function that can call a member's getter on the given Variant type.
 *
 * @param p_type The Variant type.
 * @param p_member A pointer to a StringName with the member name.
 *
 * @return A pointer to a function that can call a member's getter on the given Variant type.
 */
variant_get_ptr_getter: GDExtensionInterfaceVariantGetPtrGetter

/**
 * @name variant_get_ptr_indexed_setter
 * @since 4.1
 *
 * Gets a pointer to a function that can set an index on the given Variant type.
 *
 * @param p_type The Variant type.
 *
 * @return A pointer to a function that can set an index on the given Variant type.
 */
variant_get_ptr_indexed_setter: GDExtensionInterfaceVariantGetPtrIndexedSetter

/**
 * @name variant_get_ptr_indexed_getter
 * @since 4.1
 *
 * Gets a pointer to a function that can get an index on the given Variant type.
 *
 * @param p_type The Variant type.
 *
 * @return A pointer to a function that can get an index on the given Variant type.
 */
variant_get_ptr_indexed_getter: GDExtensionInterfaceVariantGetPtrIndexedGetter

/**
 * @name variant_get_ptr_keyed_setter
 * @since 4.1
 *
 * Gets a pointer to a function that can set a key on the given Variant type.
 *
 * @param p_type The Variant type.
 *
 * @return A pointer to a function that can set a key on the given Variant type.
 */
variant_get_ptr_keyed_setter: GDExtensionInterfaceVariantGetPtrKeyedSetter

/**
 * @name variant_get_ptr_keyed_getter
 * @since 4.1
 *
 * Gets a pointer to a function that can get a key on the given Variant type.
 *
 * @param p_type The Variant type.
 *
 * @return A pointer to a function that can get a key on the given Variant type.
 */
variant_get_ptr_keyed_getter: GDExtensionInterfaceVariantGetPtrKeyedGetter

/**
 * @name variant_get_ptr_keyed_checker
 * @since 4.1
 *
 * Gets a pointer to a function that can check a key on the given Variant type.
 *
 * @param p_type The Variant type.
 *
 * @return A pointer to a function that can check a key on the given Variant type.
 */
variant_get_ptr_keyed_checker: GDExtensionInterfaceVariantGetPtrKeyedChecker

/**
 * @name variant_get_constant_value
 * @since 4.1
 *
 * Gets the value of a constant from the given Variant type.
 *
 * @param p_type The Variant type.
 * @param p_constant A pointer to a StringName with the constant name.
 * @param r_ret A pointer to a Variant to store the value.
 */
variant_get_constant_value: GDExtensionInterfaceVariantGetConstantValue

/**
 * @name variant_get_ptr_utility_function
 * @since 4.1
 *
 * Gets a pointer to a function that can call a Variant utility function.
 *
 * @param p_function A pointer to a StringName with the function name.
 * @param p_hash A hash representing the function signature.
 *
 * @return A pointer to a function that can call a Variant utility function.
 */
variant_get_ptr_utility_function: GDExtensionInterfaceVariantGetPtrUtilityFunction

/**
 * @name string_new_with_latin1_chars
 * @since 4.1
 *
 * Creates a String from a Latin-1 encoded C string.
 *
 * @param r_dest A pointer to a Variant to hold the newly created String.
 * @param p_contents A pointer to a Latin-1 encoded C string (null terminated).
 */
string_new_with_latin1_chars: GDExtensionInterfaceStringNewWithLatin1Chars

/**
 * @name string_new_with_utf8_chars
 * @since 4.1
 *
 * Creates a String from a UTF-8 encoded C string.
 *
 * @param r_dest A pointer to a Variant to hold the newly created String.
 * @param p_contents A pointer to a UTF-8 encoded C string (null terminated).
 */
string_new_with_utf8_chars: GDExtensionInterfaceStringNewWithUtf8Chars

/**
 * @name string_new_with_utf16_chars
 * @since 4.1
 *
 * Creates a String from a UTF-16 encoded C string.
 *
 * @param r_dest A pointer to a Variant to hold the newly created String.
 * @param p_contents A pointer to a UTF-16 encoded C string (null terminated).
 */
string_new_with_utf16_chars: GDExtensionInterfaceStringNewWithUtf16Chars

/**
 * @name string_new_with_utf32_chars
 * @since 4.1
 *
 * Creates a String from a UTF-32 encoded C string.
 *
 * @param r_dest A pointer to a Variant to hold the newly created String.
 * @param p_contents A pointer to a UTF-32 encoded C string (null terminated).
 */
string_new_with_utf32_chars: GDExtensionInterfaceStringNewWithUtf32Chars

/**
 * @name string_new_with_wide_chars
 * @since 4.1
 *
 * Creates a String from a wide C string.
 *
 * @param r_dest A pointer to a Variant to hold the newly created String.
 * @param p_contents A pointer to a wide C string (null terminated).
 */
string_new_with_wide_chars: GDExtensionInterfaceStringNewWithWideChars

/**
 * @name string_new_with_latin1_chars_and_len
 * @since 4.1
 *
 * Creates a String from a Latin-1 encoded C string with the given length.
 *
 * @param r_dest A pointer to a Variant to hold the newly created String.
 * @param p_contents A pointer to a Latin-1 encoded C string.
 * @param p_size The number of characters (= number of bytes).
 */
string_new_with_latin1_chars_and_len: GDExtensionInterfaceStringNewWithLatin1CharsAndLen

/**
 * @name string_new_with_utf8_chars_and_len
 * @since 4.1
 *
 * Creates a String from a UTF-8 encoded C string with the given length.
 *
 * @param r_dest A pointer to a Variant to hold the newly created String.
 * @param p_contents A pointer to a UTF-8 encoded C string.
 * @param p_size The number of bytes (not code units).
 */
string_new_with_utf8_chars_and_len: GDExtensionInterfaceStringNewWithUtf8CharsAndLen

/**
 * @name string_new_with_utf16_chars_and_len
 * @since 4.1
 *
 * Creates a String from a UTF-16 encoded C string with the given length.
 *
 * @param r_dest A pointer to a Variant to hold the newly created String.
 * @param p_contents A pointer to a UTF-16 encoded C string.
 * @param p_size The number of characters (not bytes).
 */
string_new_with_utf16_chars_and_len: GDExtensionInterfaceStringNewWithUtf16CharsAndLen

/**
 * @name string_new_with_utf32_chars_and_len
 * @since 4.1
 *
 * Creates a String from a UTF-32 encoded C string with the given length.
 *
 * @param r_dest A pointer to a Variant to hold the newly created String.
 * @param p_contents A pointer to a UTF-32 encoded C string.
 * @param p_size The number of characters (not bytes).
 */
string_new_with_utf32_chars_and_len: GDExtensionInterfaceStringNewWithUtf32CharsAndLen

/**
 * @name string_new_with_wide_chars_and_len
 * @since 4.1
 *
 * Creates a String from a wide C string with the given length.
 *
 * @param r_dest A pointer to a Variant to hold the newly created String.
 * @param p_contents A pointer to a wide C string.
 * @param p_size The number of characters (not bytes).
 */
string_new_with_wide_chars_and_len: GDExtensionInterfaceStringNewWithWideCharsAndLen

/**
 * @name string_to_latin1_chars
 * @since 4.1
 *
 * Converts a String to a Latin-1 encoded C string.
 *
 * It doesn't write a null terminator.
 *
 * @param p_self A pointer to the String.
 * @param r_text A pointer to the buffer to hold the resulting data. If NULL is passed in, only the length will be computed.
 * @param p_max_write_length The maximum number of characters that can be written to r_text. It has no affect on the return value.
 *
 * @return The resulting encoded string length in characters (not bytes), not including a null terminator.
 */
string_to_latin1_chars: GDExtensionInterfaceStringToLatin1Chars

/**
 * @name string_to_utf8_chars
 * @since 4.1
 *
 * Converts a String to a UTF-8 encoded C string.
 *
 * It doesn't write a null terminator.
 *
 * @param p_self A pointer to the String.
 * @param r_text A pointer to the buffer to hold the resulting data. If NULL is passed in, only the length will be computed.
 * @param p_max_write_length The maximum number of characters that can be written to r_text. It has no affect on the return value.
 *
 * @return The resulting encoded string length in characters (not bytes), not including a null terminator.
 */
string_to_utf8_chars: GDExtensionInterfaceStringToUtf8Chars

/**
 * @name string_to_utf16_chars
 * @since 4.1
 *
 * Converts a String to a UTF-16 encoded C string.
 *
 * It doesn't write a null terminator.
 *
 * @param p_self A pointer to the String.
 * @param r_text A pointer to the buffer to hold the resulting data. If NULL is passed in, only the length will be computed.
 * @param p_max_write_length The maximum number of characters that can be written to r_text. It has no affect on the return value.
 *
 * @return The resulting encoded string length in characters (not bytes), not including a null terminator.
 */
string_to_utf16_chars: GDExtensionInterfaceStringToUtf16Chars

/**
 * @name string_to_utf32_chars
 * @since 4.1
 *
 * Converts a String to a UTF-32 encoded C string.
 *
 * It doesn't write a null terminator.
 *
 * @param p_self A pointer to the String.
 * @param r_text A pointer to the buffer to hold the resulting data. If NULL is passed in, only the length will be computed.
 * @param p_max_write_length The maximum number of characters that can be written to r_text. It has no affect on the return value.
 *
 * @return The resulting encoded string length in characters (not bytes), not including a null terminator.
 */
string_to_utf32_chars: GDExtensionInterfaceStringToUtf32Chars

/**
 * @name string_to_wide_chars
 * @since 4.1
 *
 * Converts a String to a wide C string.
 *
 * It doesn't write a null terminator.
 *
 * @param p_self A pointer to the String.
 * @param r_text A pointer to the buffer to hold the resulting data. If NULL is passed in, only the length will be computed.
 * @param p_max_write_length The maximum number of characters that can be written to r_text. It has no affect on the return value.
 *
 * @return The resulting encoded string length in characters (not bytes), not including a null terminator.
 */
string_to_wide_chars: GDExtensionInterfaceStringToWideChars

/**
 * @name string_operator_index
 * @since 4.1
 *
 * Gets a pointer to the character at the given index from a String.
 *
 * @param p_self A pointer to the String.
 * @param p_index The index.
 *
 * @return A pointer to the requested character.
 */
string_operator_index: GDExtensionInterfaceStringOperatorIndex

/**
 * @name string_operator_index_const
 * @since 4.1
 *
 * Gets a const pointer to the character at the given index from a String.
 *
 * @param p_self A pointer to the String.
 * @param p_index The index.
 *
 * @return A const pointer to the requested character.
 */
string_operator_index_const: GDExtensionInterfaceStringOperatorIndexConst

/**
 * @name string_operator_plus_eq_string
 * @since 4.1
 *
 * Appends another String to a String.
 *
 * @param p_self A pointer to the String.
 * @param p_b A pointer to the other String to append.
 */
string_operator_plus_eq_string: GDExtensionInterfaceStringOperatorPlusEqString

/**
 * @name string_operator_plus_eq_char
 * @since 4.1
 *
 * Appends a character to a String.
 *
 * @param p_self A pointer to the String.
 * @param p_b A pointer to the character to append.
 */
string_operator_plus_eq_char: GDExtensionInterfaceStringOperatorPlusEqChar

/**
 * @name string_operator_plus_eq_cstr
 * @since 4.1
 *
 * Appends a Latin-1 encoded C string to a String.
 *
 * @param p_self A pointer to the String.
 * @param p_b A pointer to a Latin-1 encoded C string (null terminated).
 */
string_operator_plus_eq_cstr: GDExtensionInterfaceStringOperatorPlusEqCstr

/**
 * @name string_operator_plus_eq_wcstr
 * @since 4.1
 *
 * Appends a wide C string to a String.
 *
 * @param p_self A pointer to the String.
 * @param p_b A pointer to a wide C string (null terminated).
 */
string_operator_plus_eq_wcstr: GDExtensionInterfaceStringOperatorPlusEqWcstr

/**
 * @name string_operator_plus_eq_c32str
 * @since 4.1
 *
 * Appends a UTF-32 encoded C string to a String.
 *
 * @param p_self A pointer to the String.
 * @param p_b A pointer to a UTF-32 encoded C string (null terminated).
 */
string_operator_plus_eq_c32str: GDExtensionInterfaceStringOperatorPlusEqC32str

/**
 * @name string_resize
 * @since 4.2
 *
 * Resizes the underlying string data to the given number of characters.
 *
 * Space needs to be allocated for the null terminating character ('\0') which
 * also must be added manually, in order for all string functions to work correctly.
 *
 * Warning: This is an error-prone operation - only use it if there's no other
 * efficient way to accomplish your goal.
 *
 * @param p_self A pointer to the String.
 * @param p_resize The new length for the String.
 *
 * @return Error code signifying if the operation successful.
 */
string_resize: GDExtensionInterfaceStringResize

/**
 * @name string_name_new_with_latin1_chars
 * @since 4.2
 *
 * Creates a StringName from a Latin-1 encoded C string.
 *
 * If `p_is_static` is true, then:
 * - The StringName will reuse the `p_contents` buffer instead of copying it.
 *   You must guarantee that the buffer remains valid for the duration of the application (e.g. string literal).
 * - You must not call a destructor for this StringName. Incrementing the initial reference once should achieve this.
 *
 * `p_is_static` is purely an optimization and can easily introduce undefined behavior if used wrong. In case of doubt, set it to false.
 *
 * @param r_dest A pointer to uninitialized storage, into which the newly created StringName is constructed.
 * @param p_contents A pointer to a C string (null terminated and Latin-1 or ASCII encoded).
 * @param p_is_static Whether the StringName reuses the buffer directly (see above).
 */
string_name_new_with_latin1_chars: GDExtensionInterfaceStringNameNewWithLatin1Chars

/**
 * @name string_name_new_with_utf8_chars
 * @since 4.2
 *
 * Creates a StringName from a UTF-8 encoded C string.
 *
 * @param r_dest A pointer to uninitialized storage, into which the newly created StringName is constructed.
 * @param p_contents A pointer to a C string (null terminated and UTF-8 encoded).
 */
string_name_new_with_utf8_chars: GDExtensionInterfaceStringNameNewWithUtf8Chars

/**
 * @name string_name_new_with_utf8_chars_and_len
 * @since 4.2
 *
 * Creates a StringName from a UTF-8 encoded string with a given number of characters.
 *
 * @param r_dest A pointer to uninitialized storage, into which the newly created StringName is constructed.
 * @param p_contents A pointer to a C string (null terminated and UTF-8 encoded).
 * @param p_size The number of bytes (not UTF-8 code points).
 */
string_name_new_with_utf8_chars_and_len: GDExtensionInterfaceStringNameNewWithUtf8CharsAndLen

/**
 * @name xml_parser_open_buffer
 * @since 4.1
 *
 * Opens a raw XML buffer on an XMLParser instance.
 *
 * @param p_instance A pointer to an XMLParser object.
 * @param p_buffer A pointer to the buffer.
 * @param p_size The size of the buffer.
 *
 * @return A Godot error code (ex. OK, ERR_INVALID_DATA, etc).
 *
 * @see XMLParser::open_buffer()
 */
xml_parser_open_buffer: GDExtensionInterfaceXmlParserOpenBuffer

/**
 * @name file_access_store_buffer
 * @since 4.1
 *
 * Stores the given buffer using an instance of FileAccess.
 *
 * @param p_instance A pointer to a FileAccess object.
 * @param p_src A pointer to the buffer.
 * @param p_length The size of the buffer.
 *
 * @see FileAccess::store_buffer()
 */
file_access_store_buffer: GDExtensionInterfaceFileAccessStoreBuffer

/**
 * @name file_access_get_buffer
 * @since 4.1
 *
 * Reads the next p_length bytes into the given buffer using an instance of FileAccess.
 *
 * @param p_instance A pointer to a FileAccess object.
 * @param p_dst A pointer to the buffer to store the data.
 * @param p_length The requested number of bytes to read.
 *
 * @return The actual number of bytes read (may be less than requested).
 */
file_access_get_buffer: GDExtensionInterfaceFileAccessGetBuffer

/**
 * @name worker_thread_pool_add_native_group_task
 * @since 4.1
 *
 * Adds a group task to an instance of WorkerThreadPool.
 *
 * @param p_instance A pointer to a WorkerThreadPool object.
 * @param p_func A pointer to a function to run in the thread pool.
 * @param p_userdata A pointer to arbitrary data which will be passed to p_func.
 * @param p_tasks The number of tasks needed in the group.
 * @param p_high_priority Whether or not this is a high priority task.
 * @param p_description A pointer to a String with the task description.
 *
 * @return The task group ID.
 *
 * @see WorkerThreadPool::add_group_task()
 */
worker_thread_pool_add_native_group_task: GDExtensionInterfaceWorkerThreadPoolAddNativeGroupTask

/**
 * @name worker_thread_pool_add_native_task
 * @since 4.1
 *
 * Adds a task to an instance of WorkerThreadPool.
 *
 * @param p_instance A pointer to a WorkerThreadPool object.
 * @param p_func A pointer to a function to run in the thread pool.
 * @param p_userdata A pointer to arbitrary data which will be passed to p_func.
 * @param p_high_priority Whether or not this is a high priority task.
 * @param p_description A pointer to a String with the task description.
 *
 * @return The task ID.
 */
worker_thread_pool_add_native_task: GDExtensionInterfaceWorkerThreadPoolAddNativeTask

/**
 * @name packed_byte_array_operator_index
 * @since 4.1
 *
 * Gets a pointer to a byte in a PackedByteArray.
 *
 * @param p_self A pointer to a PackedByteArray object.
 * @param p_index The index of the byte to get.
 *
 * @return A pointer to the requested byte.
 */
packed_byte_array_operator_index: GDExtensionInterfacePackedByteArrayOperatorIndex

/**
 * @name packed_byte_array_operator_index_const
 * @since 4.1
 *
 * Gets a const pointer to a byte in a PackedByteArray.
 *
 * @param p_self A const pointer to a PackedByteArray object.
 * @param p_index The index of the byte to get.
 *
 * @return A const pointer to the requested byte.
 */
packed_byte_array_operator_index_const: GDExtensionInterfacePackedByteArrayOperatorIndexConst

/**
 * @name packed_color_array_operator_index
 * @since 4.1
 *
 * Gets a pointer to a color in a PackedColorArray.
 *
 * @param p_self A pointer to a PackedColorArray object.
 * @param p_index The index of the Color to get.
 *
 * @return A pointer to the requested Color.
 */
packed_color_array_operator_index: GDExtensionInterfacePackedColorArrayOperatorIndex

/**
 * @name packed_color_array_operator_index_const
 * @since 4.1
 *
 * Gets a const pointer to a color in a PackedColorArray.
 *
 * @param p_self A const pointer to a const PackedColorArray object.
 * @param p_index The index of the Color to get.
 *
 * @return A const pointer to the requested Color.
 */
packed_color_array_operator_index_const: GDExtensionInterfacePackedColorArrayOperatorIndexConst

/**
 * @name packed_float32_array_operator_index
 * @since 4.1
 *
 * Gets a pointer to a 32-bit float in a PackedFloat32Array.
 *
 * @param p_self A pointer to a PackedFloat32Array object.
 * @param p_index The index of the float to get.
 *
 * @return A pointer to the requested 32-bit float.
 */
packed_float32_array_operator_index: GDExtensionInterfacePackedFloat32ArrayOperatorIndex

/**
 * @name packed_float32_array_operator_index_const
 * @since 4.1
 *
 * Gets a const pointer to a 32-bit float in a PackedFloat32Array.
 *
 * @param p_self A const pointer to a PackedFloat32Array object.
 * @param p_index The index of the float to get.
 *
 * @return A const pointer to the requested 32-bit float.
 */
packed_float32_array_operator_index_const: GDExtensionInterfacePackedFloat32ArrayOperatorIndexConst

/**
 * @name packed_float64_array_operator_index
 * @since 4.1
 *
 * Gets a pointer to a 64-bit float in a PackedFloat64Array.
 *
 * @param p_self A pointer to a PackedFloat64Array object.
 * @param p_index The index of the float to get.
 *
 * @return A pointer to the requested 64-bit float.
 */
packed_float64_array_operator_index: GDExtensionInterfacePackedFloat64ArrayOperatorIndex

/**
 * @name packed_float64_array_operator_index_const
 * @since 4.1
 *
 * Gets a const pointer to a 64-bit float in a PackedFloat64Array.
 *
 * @param p_self A const pointer to a PackedFloat64Array object.
 * @param p_index The index of the float to get.
 *
 * @return A const pointer to the requested 64-bit float.
 */
packed_float64_array_operator_index_const: GDExtensionInterfacePackedFloat64ArrayOperatorIndexConst

/**
 * @name packed_int32_array_operator_index
 * @since 4.1
 *
 * Gets a pointer to a 32-bit integer in a PackedInt32Array.
 *
 * @param p_self A pointer to a PackedInt32Array object.
 * @param p_index The index of the integer to get.
 *
 * @return A pointer to the requested 32-bit integer.
 */
packed_int32_array_operator_index: GDExtensionInterfacePackedInt32ArrayOperatorIndex

/**
 * @name packed_int32_array_operator_index_const
 * @since 4.1
 *
 * Gets a const pointer to a 32-bit integer in a PackedInt32Array.
 *
 * @param p_self A const pointer to a PackedInt32Array object.
 * @param p_index The index of the integer to get.
 *
 * @return A const pointer to the requested 32-bit integer.
 */
packed_int32_array_operator_index_const: GDExtensionInterfacePackedInt32ArrayOperatorIndexConst

/**
 * @name packed_int64_array_operator_index
 * @since 4.1
 *
 * Gets a pointer to a 64-bit integer in a PackedInt64Array.
 *
 * @param p_self A pointer to a PackedInt64Array object.
 * @param p_index The index of the integer to get.
 *
 * @return A pointer to the requested 64-bit integer.
 */
packed_int64_array_operator_index: GDExtensionInterfacePackedInt64ArrayOperatorIndex

/**
 * @name packed_int64_array_operator_index_const
 * @since 4.1
 *
 * Gets a const pointer to a 64-bit integer in a PackedInt64Array.
 *
 * @param p_self A const pointer to a PackedInt64Array object.
 * @param p_index The index of the integer to get.
 *
 * @return A const pointer to the requested 64-bit integer.
 */
packed_int64_array_operator_index_const: GDExtensionInterfacePackedInt64ArrayOperatorIndexConst

/**
 * @name packed_string_array_operator_index
 * @since 4.1
 *
 * Gets a pointer to a string in a PackedStringArray.
 *
 * @param p_self A pointer to a PackedStringArray object.
 * @param p_index The index of the String to get.
 *
 * @return A pointer to the requested String.
 */
packed_string_array_operator_index: GDExtensionInterfacePackedStringArrayOperatorIndex

/**
 * @name packed_string_array_operator_index_const
 * @since 4.1
 *
 * Gets a const pointer to a string in a PackedStringArray.
 *
 * @param p_self A const pointer to a PackedStringArray object.
 * @param p_index The index of the String to get.
 *
 * @return A const pointer to the requested String.
 */
packed_string_array_operator_index_const: GDExtensionInterfacePackedStringArrayOperatorIndexConst

/**
 * @name packed_vector2_array_operator_index
 * @since 4.1
 *
 * Gets a pointer to a Vector2 in a PackedVector2Array.
 *
 * @param p_self A pointer to a PackedVector2Array object.
 * @param p_index The index of the Vector2 to get.
 *
 * @return A pointer to the requested Vector2.
 */
packed_vector2_array_operator_index: GDExtensionInterfacePackedVector2ArrayOperatorIndex

/**
 * @name packed_vector2_array_operator_index_const
 * @since 4.1
 *
 * Gets a const pointer to a Vector2 in a PackedVector2Array.
 *
 * @param p_self A const pointer to a PackedVector2Array object.
 * @param p_index The index of the Vector2 to get.
 *
 * @return A const pointer to the requested Vector2.
 */
packed_vector2_array_operator_index_const: GDExtensionInterfacePackedVector2ArrayOperatorIndexConst

/**
 * @name packed_vector3_array_operator_index
 * @since 4.1
 *
 * Gets a pointer to a Vector3 in a PackedVector3Array.
 *
 * @param p_self A pointer to a PackedVector3Array object.
 * @param p_index The index of the Vector3 to get.
 *
 * @return A pointer to the requested Vector3.
 */
packed_vector3_array_operator_index: GDExtensionInterfacePackedVector3ArrayOperatorIndex

/**
 * @name packed_vector3_array_operator_index_const
 * @since 4.1
 *
 * Gets a const pointer to a Vector3 in a PackedVector3Array.
 *
 * @param p_self A const pointer to a PackedVector3Array object.
 * @param p_index The index of the Vector3 to get.
 *
 * @return A const pointer to the requested Vector3.
 */
packed_vector3_array_operator_index_const: GDExtensionInterfacePackedVector3ArrayOperatorIndexConst

/**
 * @name array_operator_index
 * @since 4.1
 *
 * Gets a pointer to a Variant in an Array.
 *
 * @param p_self A pointer to an Array object.
 * @param p_index The index of the Variant to get.
 *
 * @return A pointer to the requested Variant.
 */
array_operator_index: GDExtensionInterfaceArrayOperatorIndex

/**
 * @name array_operator_index_const
 * @since 4.1
 *
 * Gets a const pointer to a Variant in an Array.
 *
 * @param p_self A const pointer to an Array object.
 * @param p_index The index of the Variant to get.
 *
 * @return A const pointer to the requested Variant.
 */
array_operator_index_const: GDExtensionInterfaceArrayOperatorIndexConst

/**
 * @name array_ref
 * @since 4.1
 *
 * Sets an Array to be a reference to another Array object.
 *
 * @param p_self A pointer to the Array object to update.
 * @param p_from A pointer to the Array object to reference.
 */
array_ref: GDExtensionInterfaceArrayRef

/**
 * @name array_set_typed
 * @since 4.1
 *
 * Makes an Array into a typed Array.
 *
 * @param p_self A pointer to the Array.
 * @param p_type The type of Variant the Array will store.
 * @param p_class_name A pointer to a StringName with the name of the object (if p_type is GDEXTENSION_VARIANT_TYPE_OBJECT).
 * @param p_script A pointer to a Script object (if p_type is GDEXTENSION_VARIANT_TYPE_OBJECT and the base class is extended by a script).
 */
array_set_typed: GDExtensionInterfaceArraySetTyped

/**
 * @name dictionary_operator_index
 * @since 4.1
 *
 * Gets a pointer to a Variant in a Dictionary with the given key.
 *
 * @param p_self A pointer to a Dictionary object.
 * @param p_key A pointer to a Variant representing the key.
 *
 * @return A pointer to a Variant representing the value at the given key.
 */
dictionary_operator_index: GDExtensionInterfaceDictionaryOperatorIndex

/**
 * @name dictionary_operator_index_const
 * @since 4.1
 *
 * Gets a const pointer to a Variant in a Dictionary with the given key.
 *
 * @param p_self A const pointer to a Dictionary object.
 * @param p_key A pointer to a Variant representing the key.
 *
 * @return A const pointer to a Variant representing the value at the given key.
 */
dictionary_operator_index_const: GDExtensionInterfaceDictionaryOperatorIndexConst

/**
 * @name object_method_bind_call
 * @since 4.1
 *
 * Calls a method on an Object.
 *
 * @param p_method_bind A pointer to the MethodBind representing the method on the Object's class.
 * @param p_instance A pointer to the Object.
 * @param p_args A pointer to a C array of Variants representing the arguments.
 * @param p_arg_count The number of arguments.
 * @param r_ret A pointer to Variant which will receive the return value.
 * @param r_error A pointer to a GDExtensionCallError struct that will receive error information.
 */
object_method_bind_call: GDExtensionInterfaceObjectMethodBindCall

/**
 * @name object_method_bind_ptrcall
 * @since 4.1
 *
 * Calls a method on an Object (using a "ptrcall").
 *
 * @param p_method_bind A pointer to the MethodBind representing the method on the Object's class.
 * @param p_instance A pointer to the Object.
 * @param p_args A pointer to a C array representing the arguments.
 * @param r_ret A pointer to the Object that will receive the return value.
 */
object_method_bind_ptrcall: GDExtensionInterfaceObjectMethodBindPtrcall

/**
 * @name object_destroy
 * @since 4.1
 *
 * Destroys an Object.
 *
 * @param p_o A pointer to the Object.
 */
object_destroy: GDExtensionInterfaceObjectDestroy

/**
 * @name global_get_singleton
 * @since 4.1
 *
 * Gets a global singleton by name.
 *
 * @param p_name A pointer to a StringName with the singleton name.
 *
 * @return A pointer to the singleton Object.
 */
global_get_singleton: GDExtensionInterfaceGlobalGetSingleton

/**
 * @name object_get_instance_binding
 * @since 4.1
 *
 * Gets a pointer representing an Object's instance binding.
 *
 * @param p_o A pointer to the Object.
 * @param p_library A token the library received by the GDExtension's entry point function.
 * @param p_callbacks A pointer to a GDExtensionInstanceBindingCallbacks struct.
 *
 * @return
 */
object_get_instance_binding: GDExtensionInterfaceObjectGetInstanceBinding

/**
 * @name object_set_instance_binding
 * @since 4.1
 *
 * Sets an Object's instance binding.
 *
 * @param p_o A pointer to the Object.
 * @param p_library A token the library received by the GDExtension's entry point function.
 * @param p_binding A pointer to the instance binding.
 * @param p_callbacks A pointer to a GDExtensionInstanceBindingCallbacks struct.
 */
object_set_instance_binding: GDExtensionInterfaceObjectSetInstanceBinding

/**
 * @name object_free_instance_binding
 * @since 4.2
 *
 * Free an Object's instance binding.
 *
 * @param p_o A pointer to the Object.
 * @param p_library A token the library received by the GDExtension's entry point function.
 */
object_free_instance_binding: GDExtensionInterfaceObjectFreeInstanceBinding

/**
 * @name object_set_instance
 * @since 4.1
 *
 * Sets an extension class instance on a Object.
 *
 * @param p_o A pointer to the Object.
 * @param p_classname A pointer to a StringName with the registered extension class's name.
 * @param p_instance A pointer to the extension class instance.
 */
object_set_instance: GDExtensionInterfaceObjectSetInstance

/**
 * @name object_get_class_name
 * @since 4.1
 *
 * Gets the class name of an Object.
 *
 * @param p_object A pointer to the Object.
 * @param p_library A pointer the library received by the GDExtension's entry point function.
 * @param r_class_name A pointer to a String to receive the class name.
 *
 * @return true if successful in getting the class name; otherwise false.
 */
object_get_class_name: GDExtensionInterfaceObjectGetClassName

/**
 * @name object_cast_to
 * @since 4.1
 *
 * Casts an Object to a different type.
 *
 * @param p_object A pointer to the Object.
 * @param p_class_tag A pointer uniquely identifying a built-in class in the ClassDB.
 *
 * @return Returns a pointer to the Object, or NULL if it can't be cast to the requested type.
 */
object_cast_to: GDExtensionInterfaceObjectCastTo

/**
 * @name object_get_instance_from_id
 * @since 4.1
 *
 * Gets an Object by its instance ID.
 *
 * @param p_instance_id The instance ID.
 *
 * @return A pointer to the Object.
 */
object_get_instance_from_id: GDExtensionInterfaceObjectGetInstanceFromId

/**
 * @name object_get_instance_id
 * @since 4.1
 *
 * Gets the instance ID from an Object.
 *
 * @param p_object A pointer to the Object.
 *
 * @return The instance ID.
 */
object_get_instance_id: GDExtensionInterfaceObjectGetInstanceId

/**
 * @name ref_get_object
 * @since 4.1
 *
 * Gets the Object from a reference.
 *
 * @param p_ref A pointer to the reference.
 *
 * @return A pointer to the Object from the reference or NULL.
 */
ref_get_object: GDExtensionInterfaceRefGetObject

/**
 * @name ref_set_object
 * @since 4.1
 *
 * Sets the Object referred to by a reference.
 *
 * @param p_ref A pointer to the reference.
 * @param p_object A pointer to the Object to refer to.
 */
ref_set_object: GDExtensionInterfaceRefSetObject

/**
 * @name script_instance_create
 * @since 4.1
 * @deprecated in Godot 4.2. Use `script_instance_create2` instead.
 *
 * Creates a script instance that contains the given info and instance data.
 *
 * @param p_info A pointer to a GDExtensionScriptInstanceInfo struct.
 * @param p_instance_data A pointer to a data representing the script instance in the GDExtension. This will be passed to all the function pointers on p_info.
 *
 * @return A pointer to a ScriptInstanceExtension object.
 */
script_instance_create: GDExtensionInterfaceScriptInstanceCreate

/**
 * @name script_instance_create2
 * @since 4.2
 *
 * Creates a script instance that contains the given info and instance data.
 *
 * @param p_info A pointer to a GDExtensionScriptInstanceInfo2 struct.
 * @param p_instance_data A pointer to a data representing the script instance in the GDExtension. This will be passed to all the function pointers on p_info.
 *
 * @return A pointer to a ScriptInstanceExtension object.
 */
script_instance_create2: GDExtensionInterfaceScriptInstanceCreate2

/**
 * @name placeholder_script_instance_create
 * @since 4.2
 *
 * Creates a placeholder script instance for a given script and instance.
 *
 * This interface is optional as a custom placeholder could also be created with script_instance_create().
 *
 * @param p_language A pointer to a ScriptLanguage.
 * @param p_script A pointer to a Script.
 * @param p_owner A pointer to an Object.
 *
 * @return A pointer to a PlaceHolderScriptInstance object.
 */
placeholder_script_instance_create: GDExtensionInterfacePlaceHolderScriptInstanceCreate

/**
 * @name placeholder_script_instance_update
 * @since 4.2
 *
 * Updates a placeholder script instance with the given properties and values.
 *
 * The passed in placeholder must be an instance of PlaceHolderScriptInstance
 * such as the one returned by placeholder_script_instance_create().
 *
 * @param p_placeholder A pointer to a PlaceHolderScriptInstance.
 * @param p_properties A pointer to an Array of Dictionary representing PropertyInfo.
 * @param p_values A pointer to a Dictionary mapping StringName to Variant values.
 */
placeholder_script_instance_update: GDExtensionInterfacePlaceHolderScriptInstanceUpdate

/**
 * @name object_get_script_instance
 * @since 4.2
 *
 * Get the script instance data attached to this object.
 *
 * @param p_object A pointer to the Object.
 * @param p_language A pointer to the language expected for this script instance.
 *
 * @return A GDExtensionScriptInstanceDataPtr that was attached to this object as part of script_instance_create.
 */
object_get_script_instance: GDExtensionInterfaceObjectGetScriptInstance

/**
 * @name callable_custom_create
 * @since 4.2
 *
 * Creates a custom Callable object from a function pointer.
 *
 * Provided struct can be safely freed once the function returns.
 *
 * @param r_callable A pointer that will receive the new Callable.
 * @param p_callable_custom_info The info required to construct a Callable.
 */
callable_custom_create: GDExtensionInterfaceCallableCustomCreate

/**
 * @name callable_custom_get_userdata
 * @since 4.2
 *
 * Retrieves the userdata pointer from a custom Callable.
 *
 * If the Callable is not a custom Callable or the token does not match the one provided to callable_custom_create() via GDExtensionCallableCustomInfo then NULL will be returned.
 *
 * @param p_callable A pointer to a Callable.
 * @param p_token A pointer to an address that uniquely identifies the GDExtension.
 */
callable_custom_get_userdata: GDExtensionInterfaceCallableCustomGetUserData

/**
 * @name classdb_construct_object
 * @since 4.1
 *
 * Constructs an Object of the requested class.
 *
 * The passed class must be a built-in godot class, or an already-registered extension class. In both cases, object_set_instance() should be called to fully initialize the object.
 *
 * @param p_classname A pointer to a StringName with the class name.
 *
 * @return A pointer to the newly created Object.
 */
classdb_construct_object: GDExtensionInterfaceClassdbConstructObject

/**
 * @name classdb_get_method_bind
 * @since 4.1
 *
 * Gets a pointer to the MethodBind in ClassDB for the given class, method and hash.
 *
 * @param p_classname A pointer to a StringName with the class name.
 * @param p_methodname A pointer to a StringName with the method name.
 * @param p_hash A hash representing the function signature.
 *
 * @return A pointer to the MethodBind from ClassDB.
 */
classdb_get_method_bind: GDExtensionInterfaceClassdbGetMethodBind

/**
 * @name classdb_get_class_tag
 * @since 4.1
 *
 * Gets a pointer uniquely identifying the given built-in class in the ClassDB.
 *
 * @param p_classname A pointer to a StringName with the class name.
 *
 * @return A pointer uniquely identifying the built-in class in the ClassDB.
 */
classdb_get_class_tag: GDExtensionInterfaceClassdbGetClassTag

/**
 * @name classdb_register_extension_class
 * @since 4.1
 * @deprecated in Godot 4.2. Use `classdb_register_extension_class2` instead.
 *
 * Registers an extension class in the ClassDB.
 *
 * Provided struct can be safely freed once the function returns.
 *
 * @param p_library A pointer the library received by the GDExtension's entry point function.
 * @param p_class_name A pointer to a StringName with the class name.
 * @param p_parent_class_name A pointer to a StringName with the parent class name.
 * @param p_extension_funcs A pointer to a GDExtensionClassCreationInfo struct.
 */
classdb_register_extension_class: GDExtensionInterfaceClassdbRegisterExtensionClass

/**
 * @name classdb_register_extension_class2
 * @since 4.2
 *
 * Registers an extension class in the ClassDB.
 *
 * Provided struct can be safely freed once the function returns.
 *
 * @param p_library A pointer the library received by the GDExtension's entry point function.
 * @param p_class_name A pointer to a StringName with the class name.
 * @param p_parent_class_name A pointer to a StringName with the parent class name.
 * @param p_extension_funcs A pointer to a GDExtensionClassCreationInfo2 struct.
 */
classdb_register_extension_class2: GDExtensionInterfaceClassdbRegisterExtensionClass2

/**
 * @name classdb_register_extension_class_method
 * @since 4.1
 *
 * Registers a method on an extension class in the ClassDB.
 *
 * Provided struct can be safely freed once the function returns.
 *
 * @param p_library A pointer the library received by the GDExtension's entry point function.
 * @param p_class_name A pointer to a StringName with the class name.
 * @param p_method_info A pointer to a GDExtensionClassMethodInfo struct.
 */
classdb_register_extension_class_method: GDExtensionInterfaceClassdbRegisterExtensionClassMethod

/**
 * @name classdb_register_extension_class_integer_constant
 * @since 4.1
 *
 * Registers an integer constant on an extension class in the ClassDB.
 *
 * @param p_library A pointer the library received by the GDExtension's entry point function.
 * @param p_class_name A pointer to a StringName with the class name.
 * @param p_enum_name A pointer to a StringName with the enum name.
 * @param p_constant_name A pointer to a StringName with the constant name.
 * @param p_constant_value The constant value.
 * @param p_is_bitfield Whether or not this is a bit field.
 */
classdb_register_extension_class_integer_constant: GDExtensionInterfaceClassdbRegisterExtensionClassIntegerConstant

/**
 * @name classdb_register_extension_class_property
 * @since 4.1
 *
 * Registers a property on an extension class in the ClassDB.
 *
 * Provided struct can be safely freed once the function returns.
 *
 * @param p_library A pointer the library received by the GDExtension's entry point function.
 * @param p_class_name A pointer to a StringName with the class name.
 * @param p_info A pointer to a GDExtensionPropertyInfo struct.
 * @param p_setter A pointer to a StringName with the name of the setter method.
 * @param p_getter A pointer to a StringName with the name of the getter method.
 */
classdb_register_extension_class_property: GDExtensionInterfaceClassdbRegisterExtensionClassProperty

/**
 * @name classdb_register_extension_class_property_indexed
 * @since 4.2
 *
 * Registers an indexed property on an extension class in the ClassDB.
 *
 * Provided struct can be safely freed once the function returns.
 *
 * @param p_library A pointer the library received by the GDExtension's entry point function.
 * @param p_class_name A pointer to a StringName with the class name.
 * @param p_info A pointer to a GDExtensionPropertyInfo struct.
 * @param p_setter A pointer to a StringName with the name of the setter method.
 * @param p_getter A pointer to a StringName with the name of the getter method.
 * @param p_index The index to pass as the first argument to the getter and setter methods.
 */
classdb_register_extension_class_property_indexed: GDExtensionInterfaceClassdbRegisterExtensionClassPropertyIndexed

/**
 * @name classdb_register_extension_class_property_group
 * @since 4.1
 *
 * Registers a property group on an extension class in the ClassDB.
 *
 * @param p_library A pointer the library received by the GDExtension's entry point function.
 * @param p_class_name A pointer to a StringName with the class name.
 * @param p_group_name A pointer to a String with the group name.
 * @param p_prefix A pointer to a String with the prefix used by properties in this group.
 */
classdb_register_extension_class_property_group: GDExtensionInterfaceClassdbRegisterExtensionClassPropertyGroup

/**
 * @name classdb_register_extension_class_property_subgroup
 * @since 4.1
 *
 * Registers a property subgroup on an extension class in the ClassDB.
 *
 * @param p_library A pointer the library received by the GDExtension's entry point function.
 * @param p_class_name A pointer to a StringName with the class name.
 * @param p_subgroup_name A pointer to a String with the subgroup name.
 * @param p_prefix A pointer to a String with the prefix used by properties in this subgroup.
 */
classdb_register_extension_class_property_subgroup: GDExtensionInterfaceClassdbRegisterExtensionClassPropertySubgroup

/**
 * @name classdb_register_extension_class_signal
 * @since 4.1
 *
 * Registers a signal on an extension class in the ClassDB.
 *
 * Provided structs can be safely freed once the function returns.
 *
 * @param p_library A pointer the library received by the GDExtension's entry point function.
 * @param p_class_name A pointer to a StringName with the class name.
 * @param p_signal_name A pointer to a StringName with the signal name.
 * @param p_argument_info A pointer to a GDExtensionPropertyInfo struct.
 * @param p_argument_count The number of arguments the signal receives.
 */
classdb_register_extension_class_signal: GDExtensionInterfaceClassdbRegisterExtensionClassSignal

/**
 * @name classdb_unregister_extension_class
 * @since 4.1
 *
 * Unregisters an extension class in the ClassDB.
 *
 * @param p_library A pointer the library received by the GDExtension's entry point function.
 * @param p_class_name A pointer to a StringName with the class name.
 */
classdb_unregister_extension_class: GDExtensionInterfaceClassdbUnregisterExtensionClass

/**
 * @name get_library_path
 * @since 4.1
 *
 * Gets the path to the current GDExtension library.
 *
 * @param p_library A pointer the library received by the GDExtension's entry point function.
 * @param r_path A pointer to a String which will receive the path.
 */
get_library_path: GDExtensionInterfaceGetLibraryPath

/**
 * @name editor_add_plugin
 * @since 4.1
 *
 * Adds an editor plugin.
 *
 * It's safe to call during initialization.
 *
 * @param p_class_name A pointer to a StringName with the name of a class (descending from EditorPlugin) which is already registered with ClassDB.
 */
editor_add_plugin: GDExtensionInterfaceEditorAddPlugin

/**
 * @name editor_remove_plugin
 * @since 4.1
 *
 * Removes an editor plugin.
 *
 * @param p_class_name A pointer to a StringName with the name of a class that was previously added as an editor plugin.
 */
editor_remove_plugin: GDExtensionInterfaceEditorRemovePlugin


initialize_procs :: proc(get_proc_address: GDExtensionInterfaceGetProcAddress) {
    mem_alloc = cast(GDExtensionInterfaceMemAlloc)get_proc_address("mem_alloc")
    mem_realloc = cast(GDExtensionInterfaceMemRealloc)get_proc_address("mem_realloc")
    mem_free = cast(GDExtensionInterfaceMemFree)get_proc_address("mem_free")
    print_error = cast(GDExtensionInterfacePrintError)get_proc_address("print_error")
    print_error_with_message = cast(GDExtensionInterfacePrintErrorWithMessage)get_proc_address("print_error_with_message")
    print_warning = cast(GDExtensionInterfacePrintWarning)get_proc_address("print_warning")
    print_warning_with_message = cast(GDExtensionInterfacePrintWarningWithMessage)get_proc_address("print_warning_with_message")
    print_script_error = cast(GDExtensionInterfacePrintScriptError)get_proc_address("print_script_error")
    print_script_error_with_message = cast(GDExtensionInterfacePrintScriptErrorWithMessage)get_proc_address("print_script_error_with_message")
    get_native_struct_size = cast(GDExtensionInterfaceGetNativeStructSize)get_proc_address("get_native_struct_size")
    variant_new_copy = cast(GDExtensionInterfaceVariantNewCopy)get_proc_address("variant_new_copy")
    variant_new_nil = cast(GDExtensionInterfaceVariantNewNil)get_proc_address("variant_new_nil")
    variant_destroy = cast(GDExtensionInterfaceVariantDestroy)get_proc_address("variant_destroy")
    variant_call = cast(GDExtensionInterfaceVariantCall)get_proc_address("variant_call")
    variant_call_static = cast(GDExtensionInterfaceVariantCallStatic)get_proc_address("variant_call_static")
    variant_evaluate = cast(GDExtensionInterfaceVariantEvaluate)get_proc_address("variant_evaluate")
    variant_set = cast(GDExtensionInterfaceVariantSet)get_proc_address("variant_set")
    variant_set_named = cast(GDExtensionInterfaceVariantSetNamed)get_proc_address("variant_set_named")
    variant_set_keyed = cast(GDExtensionInterfaceVariantSetKeyed)get_proc_address("variant_set_keyed")
    variant_set_indexed = cast(GDExtensionInterfaceVariantSetIndexed)get_proc_address("variant_set_indexed")
    variant_get = cast(GDExtensionInterfaceVariantGet)get_proc_address("variant_get")
    variant_get_named = cast(GDExtensionInterfaceVariantGetNamed)get_proc_address("variant_get_named")
    variant_get_keyed = cast(GDExtensionInterfaceVariantGetKeyed)get_proc_address("variant_get_keyed")
    variant_get_indexed = cast(GDExtensionInterfaceVariantGetIndexed)get_proc_address("variant_get_indexed")
    variant_iter_init = cast(GDExtensionInterfaceVariantIterInit)get_proc_address("variant_iter_init")
    variant_iter_next = cast(GDExtensionInterfaceVariantIterNext)get_proc_address("variant_iter_next")
    variant_iter_get = cast(GDExtensionInterfaceVariantIterGet)get_proc_address("variant_iter_get")
    variant_hash = cast(GDExtensionInterfaceVariantHash)get_proc_address("variant_hash")
    variant_recursive_hash = cast(GDExtensionInterfaceVariantRecursiveHash)get_proc_address("variant_recursive_hash")
    variant_hash_compare = cast(GDExtensionInterfaceVariantHashCompare)get_proc_address("variant_hash_compare")
    variant_booleanize = cast(GDExtensionInterfaceVariantBooleanize)get_proc_address("variant_booleanize")
    variant_duplicate = cast(GDExtensionInterfaceVariantDuplicate)get_proc_address("variant_duplicate")
    variant_stringify = cast(GDExtensionInterfaceVariantStringify)get_proc_address("variant_stringify")
    variant_get_type = cast(GDExtensionInterfaceVariantGetType)get_proc_address("variant_get_type")
    variant_has_method = cast(GDExtensionInterfaceVariantHasMethod)get_proc_address("variant_has_method")
    variant_has_member = cast(GDExtensionInterfaceVariantHasMember)get_proc_address("variant_has_member")
    variant_has_key = cast(GDExtensionInterfaceVariantHasKey)get_proc_address("variant_has_key")
    variant_get_type_name = cast(GDExtensionInterfaceVariantGetTypeName)get_proc_address("variant_get_type_name")
    variant_can_convert = cast(GDExtensionInterfaceVariantCanConvert)get_proc_address("variant_can_convert")
    variant_can_convert_strict = cast(GDExtensionInterfaceVariantCanConvertStrict)get_proc_address("variant_can_convert_strict")
    get_variant_from_type_constructor = cast(GDExtensionInterfaceGetVariantFromTypeConstructor)get_proc_address("get_variant_from_type_constructor")
    get_variant_to_type_constructor = cast(GDExtensionInterfaceGetVariantToTypeConstructor)get_proc_address("get_variant_to_type_constructor")
    variant_get_ptr_operator_evaluator = cast(GDExtensionInterfaceVariantGetPtrOperatorEvaluator)get_proc_address("variant_get_ptr_operator_evaluator")
    variant_get_ptr_builtin_method = cast(GDExtensionInterfaceVariantGetPtrBuiltinMethod)get_proc_address("variant_get_ptr_builtin_method")
    variant_get_ptr_constructor = cast(GDExtensionInterfaceVariantGetPtrConstructor)get_proc_address("variant_get_ptr_constructor")
    variant_get_ptr_destructor = cast(GDExtensionInterfaceVariantGetPtrDestructor)get_proc_address("variant_get_ptr_destructor")
    variant_construct = cast(GDExtensionInterfaceVariantConstruct)get_proc_address("variant_construct")
    variant_get_ptr_setter = cast(GDExtensionInterfaceVariantGetPtrSetter)get_proc_address("variant_get_ptr_setter")
    variant_get_ptr_getter = cast(GDExtensionInterfaceVariantGetPtrGetter)get_proc_address("variant_get_ptr_getter")
    variant_get_ptr_indexed_setter = cast(GDExtensionInterfaceVariantGetPtrIndexedSetter)get_proc_address("variant_get_ptr_indexed_setter")
    variant_get_ptr_indexed_getter = cast(GDExtensionInterfaceVariantGetPtrIndexedGetter)get_proc_address("variant_get_ptr_indexed_getter")
    variant_get_ptr_keyed_setter = cast(GDExtensionInterfaceVariantGetPtrKeyedSetter)get_proc_address("variant_get_ptr_keyed_setter")
    variant_get_ptr_keyed_getter = cast(GDExtensionInterfaceVariantGetPtrKeyedGetter)get_proc_address("variant_get_ptr_keyed_getter")
    variant_get_ptr_keyed_checker = cast(GDExtensionInterfaceVariantGetPtrKeyedChecker)get_proc_address("variant_get_ptr_keyed_checker")
    variant_get_constant_value = cast(GDExtensionInterfaceVariantGetConstantValue)get_proc_address("variant_get_constant_value")
    variant_get_ptr_utility_function = cast(GDExtensionInterfaceVariantGetPtrUtilityFunction)get_proc_address("variant_get_ptr_utility_function")
    string_new_with_latin1_chars = cast(GDExtensionInterfaceStringNewWithLatin1Chars)get_proc_address("string_new_with_latin1_chars")
    string_new_with_utf8_chars = cast(GDExtensionInterfaceStringNewWithUtf8Chars)get_proc_address("string_new_with_utf8_chars")
    string_new_with_utf16_chars = cast(GDExtensionInterfaceStringNewWithUtf16Chars)get_proc_address("string_new_with_utf16_chars")
    string_new_with_utf32_chars = cast(GDExtensionInterfaceStringNewWithUtf32Chars)get_proc_address("string_new_with_utf32_chars")
    string_new_with_wide_chars = cast(GDExtensionInterfaceStringNewWithWideChars)get_proc_address("string_new_with_wide_chars")
    string_new_with_latin1_chars_and_len = cast(GDExtensionInterfaceStringNewWithLatin1CharsAndLen)get_proc_address("string_new_with_latin1_chars_and_len")
    string_new_with_utf8_chars_and_len = cast(GDExtensionInterfaceStringNewWithUtf8CharsAndLen)get_proc_address("string_new_with_utf8_chars_and_len")
    string_new_with_utf16_chars_and_len = cast(GDExtensionInterfaceStringNewWithUtf16CharsAndLen)get_proc_address("string_new_with_utf16_chars_and_len")
    string_new_with_utf32_chars_and_len = cast(GDExtensionInterfaceStringNewWithUtf32CharsAndLen)get_proc_address("string_new_with_utf32_chars_and_len")
    string_new_with_wide_chars_and_len = cast(GDExtensionInterfaceStringNewWithWideCharsAndLen)get_proc_address("string_new_with_wide_chars_and_len")
    string_to_latin1_chars = cast(GDExtensionInterfaceStringToLatin1Chars)get_proc_address("string_to_latin1_chars")
    string_to_utf8_chars = cast(GDExtensionInterfaceStringToUtf8Chars)get_proc_address("string_to_utf8_chars")
    string_to_utf16_chars = cast(GDExtensionInterfaceStringToUtf16Chars)get_proc_address("string_to_utf16_chars")
    string_to_utf32_chars = cast(GDExtensionInterfaceStringToUtf32Chars)get_proc_address("string_to_utf32_chars")
    string_to_wide_chars = cast(GDExtensionInterfaceStringToWideChars)get_proc_address("string_to_wide_chars")
    string_operator_index = cast(GDExtensionInterfaceStringOperatorIndex)get_proc_address("string_operator_index")
    string_operator_index_const = cast(GDExtensionInterfaceStringOperatorIndexConst)get_proc_address("string_operator_index_const")
    string_operator_plus_eq_string = cast(GDExtensionInterfaceStringOperatorPlusEqString)get_proc_address("string_operator_plus_eq_string")
    string_operator_plus_eq_char = cast(GDExtensionInterfaceStringOperatorPlusEqChar)get_proc_address("string_operator_plus_eq_char")
    string_operator_plus_eq_cstr = cast(GDExtensionInterfaceStringOperatorPlusEqCstr)get_proc_address("string_operator_plus_eq_cstr")
    string_operator_plus_eq_wcstr = cast(GDExtensionInterfaceStringOperatorPlusEqWcstr)get_proc_address("string_operator_plus_eq_wcstr")
    string_operator_plus_eq_c32str = cast(GDExtensionInterfaceStringOperatorPlusEqC32str)get_proc_address("string_operator_plus_eq_c32str")
    string_resize = cast(GDExtensionInterfaceStringResize)get_proc_address("string_resize")
    string_name_new_with_latin1_chars = cast(GDExtensionInterfaceStringNameNewWithLatin1Chars)get_proc_address("string_name_new_with_latin1_chars")
    string_name_new_with_utf8_chars = cast(GDExtensionInterfaceStringNameNewWithUtf8Chars)get_proc_address("string_name_new_with_utf8_chars")
    string_name_new_with_utf8_chars_and_len = cast(GDExtensionInterfaceStringNameNewWithUtf8CharsAndLen)get_proc_address("string_name_new_with_utf8_chars_and_len")
    xml_parser_open_buffer = cast(GDExtensionInterfaceXmlParserOpenBuffer)get_proc_address("xml_parser_open_buffer")
    file_access_store_buffer = cast(GDExtensionInterfaceFileAccessStoreBuffer)get_proc_address("file_access_store_buffer")
    file_access_get_buffer = cast(GDExtensionInterfaceFileAccessGetBuffer)get_proc_address("file_access_get_buffer")
    worker_thread_pool_add_native_group_task = cast(GDExtensionInterfaceWorkerThreadPoolAddNativeGroupTask)get_proc_address("worker_thread_pool_add_native_group_task")
    worker_thread_pool_add_native_task = cast(GDExtensionInterfaceWorkerThreadPoolAddNativeTask)get_proc_address("worker_thread_pool_add_native_task")
    packed_byte_array_operator_index = cast(GDExtensionInterfacePackedByteArrayOperatorIndex)get_proc_address("packed_byte_array_operator_index")
    packed_byte_array_operator_index_const = cast(GDExtensionInterfacePackedByteArrayOperatorIndexConst)get_proc_address("packed_byte_array_operator_index_const")
    packed_color_array_operator_index = cast(GDExtensionInterfacePackedColorArrayOperatorIndex)get_proc_address("packed_color_array_operator_index")
    packed_color_array_operator_index_const = cast(GDExtensionInterfacePackedColorArrayOperatorIndexConst)get_proc_address("packed_color_array_operator_index_const")
    packed_float32_array_operator_index = cast(GDExtensionInterfacePackedFloat32ArrayOperatorIndex)get_proc_address("packed_float32_array_operator_index")
    packed_float32_array_operator_index_const = cast(GDExtensionInterfacePackedFloat32ArrayOperatorIndexConst)get_proc_address("packed_float32_array_operator_index_const")
    packed_float64_array_operator_index = cast(GDExtensionInterfacePackedFloat64ArrayOperatorIndex)get_proc_address("packed_float64_array_operator_index")
    packed_float64_array_operator_index_const = cast(GDExtensionInterfacePackedFloat64ArrayOperatorIndexConst)get_proc_address("packed_float64_array_operator_index_const")
    packed_int32_array_operator_index = cast(GDExtensionInterfacePackedInt32ArrayOperatorIndex)get_proc_address("packed_int32_array_operator_index")
    packed_int32_array_operator_index_const = cast(GDExtensionInterfacePackedInt32ArrayOperatorIndexConst)get_proc_address("packed_int32_array_operator_index_const")
    packed_int64_array_operator_index = cast(GDExtensionInterfacePackedInt64ArrayOperatorIndex)get_proc_address("packed_int64_array_operator_index")
    packed_int64_array_operator_index_const = cast(GDExtensionInterfacePackedInt64ArrayOperatorIndexConst)get_proc_address("packed_int64_array_operator_index_const")
    packed_string_array_operator_index = cast(GDExtensionInterfacePackedStringArrayOperatorIndex)get_proc_address("packed_string_array_operator_index")
    packed_string_array_operator_index_const = cast(GDExtensionInterfacePackedStringArrayOperatorIndexConst)get_proc_address("packed_string_array_operator_index_const")
    packed_vector2_array_operator_index = cast(GDExtensionInterfacePackedVector2ArrayOperatorIndex)get_proc_address("packed_vector2_array_operator_index")
    packed_vector2_array_operator_index_const = cast(GDExtensionInterfacePackedVector2ArrayOperatorIndexConst)get_proc_address("packed_vector2_array_operator_index_const")
    packed_vector3_array_operator_index = cast(GDExtensionInterfacePackedVector3ArrayOperatorIndex)get_proc_address("packed_vector3_array_operator_index")
    packed_vector3_array_operator_index_const = cast(GDExtensionInterfacePackedVector3ArrayOperatorIndexConst)get_proc_address("packed_vector3_array_operator_index_const")
    array_operator_index = cast(GDExtensionInterfaceArrayOperatorIndex)get_proc_address("array_operator_index")
    array_operator_index_const = cast(GDExtensionInterfaceArrayOperatorIndexConst)get_proc_address("array_operator_index_const")
    array_ref = cast(GDExtensionInterfaceArrayRef)get_proc_address("array_ref")
    array_set_typed = cast(GDExtensionInterfaceArraySetTyped)get_proc_address("array_set_typed")
    dictionary_operator_index = cast(GDExtensionInterfaceDictionaryOperatorIndex)get_proc_address("dictionary_operator_index")
    dictionary_operator_index_const = cast(GDExtensionInterfaceDictionaryOperatorIndexConst)get_proc_address("dictionary_operator_index_const")
    object_method_bind_call = cast(GDExtensionInterfaceObjectMethodBindCall)get_proc_address("object_method_bind_call")
    object_method_bind_ptrcall = cast(GDExtensionInterfaceObjectMethodBindPtrcall)get_proc_address("object_method_bind_ptrcall")
    object_destroy = cast(GDExtensionInterfaceObjectDestroy)get_proc_address("object_destroy")
    global_get_singleton = cast(GDExtensionInterfaceGlobalGetSingleton)get_proc_address("global_get_singleton")
    object_get_instance_binding = cast(GDExtensionInterfaceObjectGetInstanceBinding)get_proc_address("object_get_instance_binding")
    object_set_instance_binding = cast(GDExtensionInterfaceObjectSetInstanceBinding)get_proc_address("object_set_instance_binding")
    object_free_instance_binding = cast(GDExtensionInterfaceObjectFreeInstanceBinding)get_proc_address("object_free_instance_binding")
    object_set_instance = cast(GDExtensionInterfaceObjectSetInstance)get_proc_address("object_set_instance")
    object_get_class_name = cast(GDExtensionInterfaceObjectGetClassName)get_proc_address("object_get_class_name")
    object_cast_to = cast(GDExtensionInterfaceObjectCastTo)get_proc_address("object_cast_to")
    object_get_instance_from_id = cast(GDExtensionInterfaceObjectGetInstanceFromId)get_proc_address("object_get_instance_from_id")
    object_get_instance_id = cast(GDExtensionInterfaceObjectGetInstanceId)get_proc_address("object_get_instance_id")
    ref_get_object = cast(GDExtensionInterfaceRefGetObject)get_proc_address("ref_get_object")
    ref_set_object = cast(GDExtensionInterfaceRefSetObject)get_proc_address("ref_set_object")
    script_instance_create = cast(GDExtensionInterfaceScriptInstanceCreate)get_proc_address("script_instance_create")
    script_instance_create2 = cast(GDExtensionInterfaceScriptInstanceCreate2)get_proc_address("script_instance_create2")
    placeholder_script_instance_create = cast(GDExtensionInterfacePlaceHolderScriptInstanceCreate)get_proc_address("placeholder_script_instance_create")
    placeholder_script_instance_update = cast(GDExtensionInterfacePlaceHolderScriptInstanceUpdate)get_proc_address("placeholder_script_instance_update")
    object_get_script_instance = cast(GDExtensionInterfaceObjectGetScriptInstance)get_proc_address("object_get_script_instance")
    callable_custom_create = cast(GDExtensionInterfaceCallableCustomCreate)get_proc_address("callable_custom_create")
    callable_custom_get_userdata = cast(GDExtensionInterfaceCallableCustomGetUserData)get_proc_address("callable_custom_get_userdata")
    classdb_construct_object = cast(GDExtensionInterfaceClassdbConstructObject)get_proc_address("classdb_construct_object")
    classdb_get_method_bind = cast(GDExtensionInterfaceClassdbGetMethodBind)get_proc_address("classdb_get_method_bind")
    classdb_get_class_tag = cast(GDExtensionInterfaceClassdbGetClassTag)get_proc_address("classdb_get_class_tag")
    classdb_register_extension_class = cast(GDExtensionInterfaceClassdbRegisterExtensionClass)get_proc_address("classdb_register_extension_class")
    classdb_register_extension_class2 = cast(GDExtensionInterfaceClassdbRegisterExtensionClass2)get_proc_address("classdb_register_extension_class2")
    classdb_register_extension_class_method = cast(GDExtensionInterfaceClassdbRegisterExtensionClassMethod)get_proc_address("classdb_register_extension_class_method")
    classdb_register_extension_class_integer_constant = cast(GDExtensionInterfaceClassdbRegisterExtensionClassIntegerConstant)get_proc_address("classdb_register_extension_class_integer_constant")
    classdb_register_extension_class_property = cast(GDExtensionInterfaceClassdbRegisterExtensionClassProperty)get_proc_address("classdb_register_extension_class_property")
    classdb_register_extension_class_property_indexed = cast(GDExtensionInterfaceClassdbRegisterExtensionClassPropertyIndexed)get_proc_address("classdb_register_extension_class_property_indexed")
    classdb_register_extension_class_property_group = cast(GDExtensionInterfaceClassdbRegisterExtensionClassPropertyGroup)get_proc_address("classdb_register_extension_class_property_group")
    classdb_register_extension_class_property_subgroup = cast(GDExtensionInterfaceClassdbRegisterExtensionClassPropertySubgroup)get_proc_address("classdb_register_extension_class_property_subgroup")
    classdb_register_extension_class_signal = cast(GDExtensionInterfaceClassdbRegisterExtensionClassSignal)get_proc_address("classdb_register_extension_class_signal")
    classdb_unregister_extension_class = cast(GDExtensionInterfaceClassdbUnregisterExtensionClass)get_proc_address("classdb_unregister_extension_class")
    get_library_path = cast(GDExtensionInterfaceGetLibraryPath)get_proc_address("get_library_path")
    editor_add_plugin = cast(GDExtensionInterfaceEditorAddPlugin)get_proc_address("editor_add_plugin")
    editor_remove_plugin = cast(GDExtensionInterfaceEditorRemovePlugin)get_proc_address("editor_remove_plugin")
}
