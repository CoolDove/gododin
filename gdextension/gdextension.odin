package gdextension
/**************************************************************************/
/*  gdextension_interface.h                                               */
/**************************************************************************/
/*                         This file is part of:                          */
/*                             GODOT ENGINE                               */
/*                        https://godotengine.org                         */
/**************************************************************************/
/* Copyright (c) 2014-present Godot Engine contributors (see AUTHORS.md). */
/* Copyright (c) 2007-2014 Juan Linietsky, Ariel Manzur.                  */
/*                                                                        */
/* Permission is hereby granted, free of charge, to any person obtaining  */
/* a copy of this software and associated documentation files (the        */
/* "Software"), to deal in the Software without restriction, including    */
/* without limitation the rights to use, copy, modify, merge, publish,    */
/* distribute, sublicense, and/or sell copies of the Software, and to     */
/* permit persons to whom the Software is furnished to do so, subject to  */
/* the following conditions:                                              */
/*                                                                        */
/* The above copyright notice and this permission notice shall be         */
/* included in all copies or substantial portions of the Software.        */
/*                                                                        */
/* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,        */
/* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF     */
/* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. */
/* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY   */
/* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,   */
/* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE      */
/* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                 */
/**************************************************************************/


/* VARIANT TYPES */

GDExtensionVariantType :: enum i32 {
	GDEXTENSION_VARIANT_TYPE_NIL,

	/*  atomic types */
	GDEXTENSION_VARIANT_TYPE_BOOL,
	GDEXTENSION_VARIANT_TYPE_INT,
	GDEXTENSION_VARIANT_TYPE_FLOAT,
	GDEXTENSION_VARIANT_TYPE_STRING,

	/* math types */
	GDEXTENSION_VARIANT_TYPE_VECTOR2,
	GDEXTENSION_VARIANT_TYPE_VECTOR2I,
	GDEXTENSION_VARIANT_TYPE_RECT2,
	GDEXTENSION_VARIANT_TYPE_RECT2I,
	GDEXTENSION_VARIANT_TYPE_VECTOR3,
	GDEXTENSION_VARIANT_TYPE_VECTOR3I,
	GDEXTENSION_VARIANT_TYPE_TRANSFORM2D,
	GDEXTENSION_VARIANT_TYPE_VECTOR4,
	GDEXTENSION_VARIANT_TYPE_VECTOR4I,
	GDEXTENSION_VARIANT_TYPE_PLANE,
	GDEXTENSION_VARIANT_TYPE_QUATERNION,
	GDEXTENSION_VARIANT_TYPE_AABB,
	GDEXTENSION_VARIANT_TYPE_BASIS,
	GDEXTENSION_VARIANT_TYPE_TRANSFORM3D,
	GDEXTENSION_VARIANT_TYPE_PROJECTION,

	/* misc types */
	GDEXTENSION_VARIANT_TYPE_COLOR,
	GDEXTENSION_VARIANT_TYPE_STRING_NAME,
	GDEXTENSION_VARIANT_TYPE_NODE_PATH,
	GDEXTENSION_VARIANT_TYPE_RID,
	GDEXTENSION_VARIANT_TYPE_OBJECT,
	GDEXTENSION_VARIANT_TYPE_CALLABLE,
	GDEXTENSION_VARIANT_TYPE_SIGNAL,
	GDEXTENSION_VARIANT_TYPE_DICTIONARY,
	GDEXTENSION_VARIANT_TYPE_ARRAY,

	/* typed arrays */
	GDEXTENSION_VARIANT_TYPE_PACKED_BYTE_ARRAY,
	GDEXTENSION_VARIANT_TYPE_PACKED_INT32_ARRAY,
	GDEXTENSION_VARIANT_TYPE_PACKED_INT64_ARRAY,
	GDEXTENSION_VARIANT_TYPE_PACKED_FLOAT32_ARRAY,
	GDEXTENSION_VARIANT_TYPE_PACKED_FLOAT64_ARRAY,
	GDEXTENSION_VARIANT_TYPE_PACKED_STRING_ARRAY,
	GDEXTENSION_VARIANT_TYPE_PACKED_VECTOR2_ARRAY,
	GDEXTENSION_VARIANT_TYPE_PACKED_VECTOR3_ARRAY,
	GDEXTENSION_VARIANT_TYPE_PACKED_COLOR_ARRAY,

	GDEXTENSION_VARIANT_TYPE_VARIANT_MAX
}

GDExtensionVariantOperator :: enum i32 {
	/* comparison */
	GDEXTENSION_VARIANT_OP_EQUAL,
	GDEXTENSION_VARIANT_OP_NOT_EQUAL,
	GDEXTENSION_VARIANT_OP_LESS,
	GDEXTENSION_VARIANT_OP_LESS_EQUAL,
	GDEXTENSION_VARIANT_OP_GREATER,
	GDEXTENSION_VARIANT_OP_GREATER_EQUAL,

	/* mathematic */
	GDEXTENSION_VARIANT_OP_ADD,
	GDEXTENSION_VARIANT_OP_SUBTRACT,
	GDEXTENSION_VARIANT_OP_MULTIPLY,
	GDEXTENSION_VARIANT_OP_DIVIDE,
	GDEXTENSION_VARIANT_OP_NEGATE,
	GDEXTENSION_VARIANT_OP_POSITIVE,
	GDEXTENSION_VARIANT_OP_MODULE,
	GDEXTENSION_VARIANT_OP_POWER,

	/* bitwise */
	GDEXTENSION_VARIANT_OP_SHIFT_LEFT,
	GDEXTENSION_VARIANT_OP_SHIFT_RIGHT,
	GDEXTENSION_VARIANT_OP_BIT_AND,
	GDEXTENSION_VARIANT_OP_BIT_OR,
	GDEXTENSION_VARIANT_OP_BIT_XOR,
	GDEXTENSION_VARIANT_OP_BIT_NEGATE,

	/* logic */
	GDEXTENSION_VARIANT_OP_AND,
	GDEXTENSION_VARIANT_OP_OR,
	GDEXTENSION_VARIANT_OP_XOR,
	GDEXTENSION_VARIANT_OP_NOT,

	/* containment */
	GDEXTENSION_VARIANT_OP_IN,
	GDEXTENSION_VARIANT_OP_MAX

}

// In this API there are multiple functions which expect the caller to pass a pointer
// on return value as parameter.
// In order to make it clear if the caller should initialize the return value or not
// we have two flavor of types:
// - `GDExtensionXXXPtr` for pointer on an initialized value
// - `GDExtensionUninitializedXXXPtr` for pointer on uninitialized value
//
// Notes:
// - Not respecting those requirements can seems harmless, but will lead to unexpected
//   segfault or memory leak (for instance with a specific compiler/OS, or when two
//   native extensions start doing ptrcall on each other).
// - Initialization must be done with the function pointer returned by `variant_get_ptr_constructor`,
//   zero-initializing the variable should not be considered a valid initialization method here !
// - Some types have no destructor (see `extension_api.json`'s `has_destructor` field), for
//   them it is always safe to skip the constructor for the return value if you are in a hurry ;-)

GDExtensionVariantPtr :: rawptr
GDExtensionConstVariantPtr :: rawptr
GDExtensionUninitializedVariantPtr :: rawptr
GDExtensionStringNamePtr :: rawptr
GDExtensionConstStringNamePtr :: rawptr
GDExtensionUninitializedStringNamePtr :: rawptr
GDExtensionStringPtr :: rawptr
GDExtensionConstStringPtr :: rawptr
GDExtensionUninitializedStringPtr :: rawptr
GDExtensionObjectPtr :: rawptr
GDExtensionConstObjectPtr :: rawptr
GDExtensionUninitializedObjectPtr :: rawptr
GDExtensionTypePtr :: rawptr
GDExtensionConstTypePtr :: rawptr
GDExtensionUninitializedTypePtr :: rawptr
GDExtensionMethodBindPtr :: rawptr
GDExtensionInt :: int64_t 
GDExtensionBool :: uint8_t 
GDObjectInstanceID :: uint64_t 
GDExtensionRefPtr :: rawptr
GDExtensionConstRefPtr :: rawptr

/* VARIANT DATA I/O */

GDExtensionCallErrorType :: enum i32 {
	GDEXTENSION_CALL_OK,
	GDEXTENSION_CALL_ERROR_INVALID_METHOD,
	GDEXTENSION_CALL_ERROR_INVALID_ARGUMENT, // Expected a different variant type.
	GDEXTENSION_CALL_ERROR_TOO_MANY_ARGUMENTS, // Expected lower number of arguments.
	GDEXTENSION_CALL_ERROR_TOO_FEW_ARGUMENTS, // Expected higher number of arguments.
	GDEXTENSION_CALL_ERROR_INSTANCE_IS_NULL,
	GDEXTENSION_CALL_ERROR_METHOD_NOT_CONST, // Used for const call.
}

GDExtensionCallError :: struct {
	error: GDExtensionCallErrorType,
	argument: int32_t,
	expected: int32_t,
}

GDExtensionVariantFromTypeConstructorFunc :: #type proc "c" (GDExtensionUninitializedVariantPtr, GDExtensionTypePtr) -> void 
GDExtensionTypeFromVariantConstructorFunc :: #type proc "c" (GDExtensionUninitializedTypePtr, GDExtensionVariantPtr) -> void 
GDExtensionPtrOperatorEvaluator :: #type proc "c" (GDExtensionConstTypePtr p_left, GDExtensionConstTypePtr p_right, GDExtensionTypePtr r_result) -> void 
GDExtensionPtrBuiltInMethod :: #type proc "c" (GDExtensionTypePtr p_base, GDExtensionConstTypePtr *p_args, GDExtensionTypePtr r_return, int p_argument_count) -> void 
GDExtensionPtrConstructor :: #type proc "c" (GDExtensionUninitializedTypePtr p_base, GDExtensionConstTypePtr *p_args) -> void 
GDExtensionPtrDestructor :: #type proc "c" (GDExtensionTypePtr p_base) -> void 
GDExtensionPtrSetter :: #type proc "c" (GDExtensionTypePtr p_base, GDExtensionConstTypePtr p_value) -> void 
GDExtensionPtrGetter :: #type proc "c" (GDExtensionConstTypePtr p_base, GDExtensionTypePtr r_value) -> void 
GDExtensionPtrIndexedSetter :: #type proc "c" (GDExtensionTypePtr p_base, GDExtensionInt p_index, GDExtensionConstTypePtr p_value) -> void 
GDExtensionPtrIndexedGetter :: #type proc "c" (GDExtensionConstTypePtr p_base, GDExtensionInt p_index, GDExtensionTypePtr r_value) -> void 
GDExtensionPtrKeyedSetter :: #type proc "c" (GDExtensionTypePtr p_base, GDExtensionConstTypePtr p_key, GDExtensionConstTypePtr p_value) -> void 
GDExtensionPtrKeyedGetter :: #type proc "c" (GDExtensionConstTypePtr p_base, GDExtensionConstTypePtr p_key, GDExtensionTypePtr r_value) -> void 
GDExtensionPtrKeyedChecker :: #type proc "c" (GDExtensionConstVariantPtr p_base, GDExtensionConstVariantPtr p_key) -> uint32_t 
GDExtensionPtrUtilityFunction :: #type proc "c" (GDExtensionTypePtr r_return, GDExtensionConstTypePtr *p_args, int p_argument_count) -> void 

GDExtensionClassConstructor :: #type proc "c" () -> GDExtensionObjectPtr 

GDExtensionInstanceBindingCreateCallback :: #type proc "c" (void *p_token, void *p_instance) -> void *
GDExtensionInstanceBindingFreeCallback :: #type proc "c" (void *p_token, void *p_instance, void *p_binding) -> void 
GDExtensionInstanceBindingReferenceCallback :: #type proc "c" (void *p_token, void *p_binding, GDExtensionBool p_reference) -> GDExtensionBool 

GDExtensionInstanceBindingCallbacks :: struct {
	create_callback: GDExtensionInstanceBindingCreateCallback,
	free_callback: GDExtensionInstanceBindingFreeCallback,
	reference_callback: GDExtensionInstanceBindingReferenceCallback,
}

/* EXTENSION CLASSES */

typedef void *GDExtensionClassInstancePtr;

GDExtensionClassSet :: #type proc "c" (GDExtensionClassInstancePtr p_instance, GDExtensionConstStringNamePtr p_name, GDExtensionConstVariantPtr p_value) -> GDExtensionBool 
GDExtensionClassGet :: #type proc "c" (GDExtensionClassInstancePtr p_instance, GDExtensionConstStringNamePtr p_name, GDExtensionVariantPtr r_ret) -> GDExtensionBool 
GDExtensionClassGetRID :: #type proc "c" (GDExtensionClassInstancePtr p_instance) -> uint64_t 

GDExtensionPropertyInfo :: struct {
	type: GDExtensionVariantType,
	name: GDExtensionStringNamePtr,
	class_name: GDExtensionStringNamePtr,
	hint: uint32_t, // Bitfield of `PropertyHint` (defined in `extension_api.json`).
	hint_string: GDExtensionStringPtr,
	usage: uint32_t, // Bitfield of `PropertyUsageFlags` (defined in `extension_api.json`).
}

GDExtensionMethodInfo :: struct {
	name: GDExtensionStringNamePtr,
	return_value: GDExtensionPropertyInfo,
	flags: uint32_t, // Bitfield of `GDExtensionClassMethodFlags`.
	id: int32_t,

	/* Arguments: `default_arguments` is an array of size `argument_count`. */
	argument_count: uint32_t,
	arguments: *GDExtensionPropertyInfo,

	/* Default arguments: `default_arguments` is an array of size `default_argument_count`. */
	default_argument_count: uint32_t,
	default_arguments: *GDExtensionVariantPtr,
}

GDExtensionClassGetPropertyList :: #type proc "c" (GDExtensionClassInstancePtr p_instance, uint32_t *r_count) -> GDExtensionPropertyInfo *
GDExtensionClassFreePropertyList :: #type proc "c" (GDExtensionClassInstancePtr p_instance, GDExtensionPropertyInfo *p_list) -> void 
GDExtensionClassPropertyCanRevert :: #type proc "c" (GDExtensionClassInstancePtr p_instance, GDExtensionConstStringNamePtr p_name) -> GDExtensionBool 
GDExtensionClassPropertyGetRevert :: #type proc "c" (GDExtensionClassInstancePtr p_instance, GDExtensionConstStringNamePtr p_name, GDExtensionVariantPtr r_ret) -> GDExtensionBool 
GDExtensionClassValidateProperty :: #type proc "c" (GDExtensionClassInstancePtr p_instance, GDExtensionPropertyInfo *p_property) -> GDExtensionBool 
GDExtensionClassNotification :: #type proc "c" (GDExtensionClassInstancePtr p_instance, int32_t p_what) -> void  // Deprecated. Use GDExtensionClassNotification2 instead.
GDExtensionClassNotification2 :: #type proc "c" (GDExtensionClassInstancePtr p_instance, int32_t p_what, GDExtensionBool p_reversed) -> void 
GDExtensionClassToString :: #type proc "c" (GDExtensionClassInstancePtr p_instance, GDExtensionBool *r_is_valid, GDExtensionStringPtr p_out) -> void 
GDExtensionClassReference :: #type proc "c" (GDExtensionClassInstancePtr p_instance) -> void 
GDExtensionClassUnreference :: #type proc "c" (GDExtensionClassInstancePtr p_instance) -> void 
GDExtensionClassCallVirtual :: #type proc "c" (GDExtensionClassInstancePtr p_instance, GDExtensionConstTypePtr *p_args, GDExtensionTypePtr r_ret) -> void 
GDExtensionClassCreateInstance :: #type proc "c" (void *p_class_userdata) -> GDExtensionObjectPtr 
GDExtensionClassFreeInstance :: #type proc "c" (void *p_class_userdata, GDExtensionClassInstancePtr p_instance) -> void 
GDExtensionClassRecreateInstance :: #type proc "c" (void *p_class_userdata, GDExtensionObjectPtr p_object) -> GDExtensionClassInstancePtr 
GDExtensionClassGetVirtual :: #type proc "c" (void *p_class_userdata, GDExtensionConstStringNamePtr p_name) -> GDExtensionClassCallVirtual 
GDExtensionClassGetVirtualCallData :: #type proc "c" (void *p_class_userdata, GDExtensionConstStringNamePtr p_name) -> void *
GDExtensionClassCallVirtualWithData :: #type proc "c" (GDExtensionClassInstancePtr p_instance, GDExtensionConstStringNamePtr p_name, void *p_virtual_call_userdata, GDExtensionConstTypePtr *p_args, GDExtensionTypePtr r_ret) -> void 

GDExtensionClassCreationInfo :: struct {
	is_virtual: GDExtensionBool,
	is_abstract: GDExtensionBool,
	set_func: GDExtensionClassSet,
	get_func: GDExtensionClassGet,
	get_property_list_func: GDExtensionClassGetPropertyList,
	free_property_list_func: GDExtensionClassFreePropertyList,
	property_can_revert_func: GDExtensionClassPropertyCanRevert,
	property_get_revert_func: GDExtensionClassPropertyGetRevert,
	notification_func: GDExtensionClassNotification,
	to_string_func: GDExtensionClassToString,
	reference_func: GDExtensionClassReference,
	unreference_func: GDExtensionClassUnreference,
	create_instance_func: GDExtensionClassCreateInstance, // (Default) constructor; mandatory. If the class is not instantiable, consider making it virtual or abstract.
	free_instance_func: GDExtensionClassFreeInstance, // Destructor; mandatory.
	get_virtual_func: GDExtensionClassGetVirtual, // Queries a virtual function by name and returns a callback to invoke the requested virtual function.
	get_rid_func: GDExtensionClassGetRID,
	class_userdata: *void, // Per-class user data, later accessible in instance bindings.
}// Deprecated. Use GDExtensionClassCreationInfo2 instead.

GDExtensionClassCreationInfo2 :: struct {
	is_virtual: GDExtensionBool,
	is_abstract: GDExtensionBool,
	is_exposed: GDExtensionBool,
	set_func: GDExtensionClassSet,
	get_func: GDExtensionClassGet,
	get_property_list_func: GDExtensionClassGetPropertyList,
	free_property_list_func: GDExtensionClassFreePropertyList,
	property_can_revert_func: GDExtensionClassPropertyCanRevert,
	property_get_revert_func: GDExtensionClassPropertyGetRevert,
	validate_property_func: GDExtensionClassValidateProperty,
	notification_func: GDExtensionClassNotification2,
	to_string_func: GDExtensionClassToString,
	reference_func: GDExtensionClassReference,
	unreference_func: GDExtensionClassUnreference,
	create_instance_func: GDExtensionClassCreateInstance, // (Default) constructor; mandatory. If the class is not instantiable, consider making it virtual or abstract.
	free_instance_func: GDExtensionClassFreeInstance, // Destructor; mandatory.
	recreate_instance_func: GDExtensionClassRecreateInstance,
	// Queries a virtual function by name and returns a callback to invoke the requested virtual function.
	get_virtual_func: GDExtensionClassGetVirtual,
	// Paired with `call_virtual_with_data_func`, this is an alternative to `get_virtual_func` for extensions that
	// need or benefit from extra data when calling virtual functions.
	// Returns user data that will be passed to `call_virtual_with_data_func`.
	// Returning `NULL` from this function signals to Godot that the virtual function is not overridden.
	// Data returned from this function should be managed by the extension and must be valid until the extension is deinitialized.
	// You should supply either `get_virtual_func`, or `get_virtual_call_data_func` with `call_virtual_with_data_func`.
	get_virtual_call_data_func: GDExtensionClassGetVirtualCallData,
	// Used to call virtual functions when `get_virtual_call_data_func` is not null.
	call_virtual_with_data_func: GDExtensionClassCallVirtualWithData,
	get_rid_func: GDExtensionClassGetRID,
	class_userdata: *void, // Per-class user data, later accessible in instance bindings.
}

typedef void *GDExtensionClassLibraryPtr;

/* Method */

GDExtensionClassMethodFlags :: enum i32 {
	GDEXTENSION_METHOD_FLAG_NORMAL = 1,
	GDEXTENSION_METHOD_FLAG_EDITOR = 2,
	GDEXTENSION_METHOD_FLAG_CONST = 4,
	GDEXTENSION_METHOD_FLAG_VIRTUAL = 8,
	GDEXTENSION_METHOD_FLAG_VARARG = 16,
	GDEXTENSION_METHOD_FLAG_STATIC = 32,
	GDEXTENSION_METHOD_FLAGS_DEFAULT = GDEXTENSION_METHOD_FLAG_NORMAL,
}

GDExtensionClassMethodArgumentMetadata :: enum i32 {
	GDEXTENSION_METHOD_ARGUMENT_METADATA_NONE,
	GDEXTENSION_METHOD_ARGUMENT_METADATA_INT_IS_INT8,
	GDEXTENSION_METHOD_ARGUMENT_METADATA_INT_IS_INT16,
	GDEXTENSION_METHOD_ARGUMENT_METADATA_INT_IS_INT32,
	GDEXTENSION_METHOD_ARGUMENT_METADATA_INT_IS_INT64,
	GDEXTENSION_METHOD_ARGUMENT_METADATA_INT_IS_UINT8,
	GDEXTENSION_METHOD_ARGUMENT_METADATA_INT_IS_UINT16,
	GDEXTENSION_METHOD_ARGUMENT_METADATA_INT_IS_UINT32,
	GDEXTENSION_METHOD_ARGUMENT_METADATA_INT_IS_UINT64,
	GDEXTENSION_METHOD_ARGUMENT_METADATA_REAL_IS_FLOAT,
	GDEXTENSION_METHOD_ARGUMENT_METADATA_REAL_IS_DOUBLE
}

GDExtensionClassMethodCall :: #type proc "c" (void *method_userdata, GDExtensionClassInstancePtr p_instance, GDExtensionConstVariantPtr *p_args, GDExtensionInt p_argument_count, GDExtensionVariantPtr r_return, GDExtensionCallError *r_error) -> void 
GDExtensionClassMethodValidatedCall :: #type proc "c" (void *method_userdata, GDExtensionClassInstancePtr p_instance, GDExtensionConstVariantPtr *p_args, GDExtensionVariantPtr r_return) -> void 
GDExtensionClassMethodPtrCall :: #type proc "c" (void *method_userdata, GDExtensionClassInstancePtr p_instance, GDExtensionConstTypePtr *p_args, GDExtensionTypePtr r_ret) -> void 

GDExtensionClassMethodInfo :: struct {
	name: GDExtensionStringNamePtr,
	method_userdata: *void,
	call_func: GDExtensionClassMethodCall,
	ptrcall_func: GDExtensionClassMethodPtrCall,
	method_flags: uint32_t, // Bitfield of `GDExtensionClassMethodFlags`.

	/* If `has_return_value` is false, `return_value_info` and `return_value_metadata` are ignored. */
	has_return_value: GDExtensionBool,
	return_value_info: *GDExtensionPropertyInfo,
	return_value_metadata: GDExtensionClassMethodArgumentMetadata,

	/* Arguments: `arguments_info` and `arguments_metadata` are array of size `argument_count`.
	 * Name and hint information for the argument can be omitted in release builds. Class name should always be present if it applies.
	 */
	argument_count: uint32_t,
	arguments_info: *GDExtensionPropertyInfo,
	arguments_metadata: *GDExtensionClassMethodArgumentMetadata,

	/* Default arguments: `default_arguments` is an array of size `default_argument_count`. */
	default_argument_count: uint32_t,
	default_arguments: *GDExtensionVariantPtr,
}

GDExtensionCallableCustomCall :: #type proc "c" (void *callable_userdata, GDExtensionConstVariantPtr *p_args, GDExtensionInt p_argument_count, GDExtensionVariantPtr r_return, GDExtensionCallError *r_error) -> void 
GDExtensionCallableCustomIsValid :: #type proc "c" (void *callable_userdata) -> GDExtensionBool 
GDExtensionCallableCustomFree :: #type proc "c" (void *callable_userdata) -> void 

GDExtensionCallableCustomHash :: #type proc "c" (void *callable_userdata) -> uint32_t 
GDExtensionCallableCustomEqual :: #type proc "c" (void *callable_userdata_a, void *callable_userdata_b) -> GDExtensionBool 
GDExtensionCallableCustomLessThan :: #type proc "c" (void *callable_userdata_a, void *callable_userdata_b) -> GDExtensionBool 

GDExtensionCallableCustomToString :: #type proc "c" (void *callable_userdata, GDExtensionBool *r_is_valid, GDExtensionStringPtr r_out) -> void 

GDExtensionCallableCustomInfo :: struct {
	/* Only `call_func` and `token` are strictly required, however, `object_id` should be passed if its not a static method.
	 *
	 * `token` should point to an address that uniquely identifies the GDExtension (for example, the
	 * `GDExtensionClassLibraryPtr` passed to the entry symbol function.
	 *
	 * `hash_func`, `equal_func`, and `less_than_func` are optional. If not provided both `call_func` and
	 * `callable_userdata` together are used as the identity of the callable for hashing and comparison purposes.
	 *
	 * The hash returned by `hash_func` is cached, `hash_func` will not be called more than once per callable.
	 *
	 * `is_valid_func` is necessary if the validity of the callable can change before destruction.
	 *
	 * `free_func` is necessary if `callable_userdata` needs to be cleaned up when the callable is freed.
	 */
	callable_userdata: *void,
	token: *void,

	object_id: GDObjectInstanceID,

	call_func: GDExtensionCallableCustomCall,
	is_valid_func: GDExtensionCallableCustomIsValid,
	free_func: GDExtensionCallableCustomFree,

	hash_func: GDExtensionCallableCustomHash,
	equal_func: GDExtensionCallableCustomEqual,
	less_than_func: GDExtensionCallableCustomLessThan,

	to_string_func: GDExtensionCallableCustomToString,
}

/* SCRIPT INSTANCE EXTENSION */

typedef void *GDExtensionScriptInstanceDataPtr; // Pointer to custom ScriptInstance native implementation.

GDExtensionScriptInstanceSet :: #type proc "c" (GDExtensionScriptInstanceDataPtr p_instance, GDExtensionConstStringNamePtr p_name, GDExtensionConstVariantPtr p_value) -> GDExtensionBool 
GDExtensionScriptInstanceGet :: #type proc "c" (GDExtensionScriptInstanceDataPtr p_instance, GDExtensionConstStringNamePtr p_name, GDExtensionVariantPtr r_ret) -> GDExtensionBool 
GDExtensionScriptInstanceGetPropertyList :: #type proc "c" (GDExtensionScriptInstanceDataPtr p_instance, uint32_t *r_count) -> GDExtensionPropertyInfo *
GDExtensionScriptInstanceFreePropertyList :: #type proc "c" (GDExtensionScriptInstanceDataPtr p_instance, GDExtensionPropertyInfo *p_list) -> void 
GDExtensionScriptInstanceGetClassCategory :: #type proc "c" (GDExtensionScriptInstanceDataPtr p_instance, GDExtensionPropertyInfo *p_class_category) -> GDExtensionBool 

GDExtensionScriptInstanceGetPropertyType :: #type proc "c" (GDExtensionScriptInstanceDataPtr p_instance, GDExtensionConstStringNamePtr p_name, GDExtensionBool *r_is_valid) -> GDExtensionVariantType 
GDExtensionScriptInstanceValidateProperty :: #type proc "c" (GDExtensionScriptInstanceDataPtr p_instance, GDExtensionPropertyInfo *p_property) -> GDExtensionBool 

GDExtensionScriptInstancePropertyCanRevert :: #type proc "c" (GDExtensionScriptInstanceDataPtr p_instance, GDExtensionConstStringNamePtr p_name) -> GDExtensionBool 
GDExtensionScriptInstancePropertyGetRevert :: #type proc "c" (GDExtensionScriptInstanceDataPtr p_instance, GDExtensionConstStringNamePtr p_name, GDExtensionVariantPtr r_ret) -> GDExtensionBool 

GDExtensionScriptInstanceGetOwner :: #type proc "c" (GDExtensionScriptInstanceDataPtr p_instance) -> GDExtensionObjectPtr 
GDExtensionScriptInstancePropertyStateAdd :: #type proc "c" (GDExtensionConstStringNamePtr p_name, GDExtensionConstVariantPtr p_value, void *p_userdata) -> void 
GDExtensionScriptInstanceGetPropertyState :: #type proc "c" (GDExtensionScriptInstanceDataPtr p_instance, GDExtensionScriptInstancePropertyStateAdd p_add_func, void *p_userdata) -> void 

GDExtensionScriptInstanceGetMethodList :: #type proc "c" (GDExtensionScriptInstanceDataPtr p_instance, uint32_t *r_count) -> GDExtensionMethodInfo *
GDExtensionScriptInstanceFreeMethodList :: #type proc "c" (GDExtensionScriptInstanceDataPtr p_instance, GDExtensionMethodInfo *p_list) -> void 

GDExtensionScriptInstanceHasMethod :: #type proc "c" (GDExtensionScriptInstanceDataPtr p_instance, GDExtensionConstStringNamePtr p_name) -> GDExtensionBool 

GDExtensionScriptInstanceCall :: #type proc "c" (GDExtensionScriptInstanceDataPtr p_self, GDExtensionConstStringNamePtr p_method, GDExtensionConstVariantPtr *p_args, GDExtensionInt p_argument_count, GDExtensionVariantPtr r_return, GDExtensionCallError *r_error) -> void 
GDExtensionScriptInstanceNotification :: #type proc "c" (GDExtensionScriptInstanceDataPtr p_instance, int32_t p_what) -> void  // Deprecated. Use GDExtensionScriptInstanceNotification2 instead.
GDExtensionScriptInstanceNotification2 :: #type proc "c" (GDExtensionScriptInstanceDataPtr p_instance, int32_t p_what, GDExtensionBool p_reversed) -> void 
GDExtensionScriptInstanceToString :: #type proc "c" (GDExtensionScriptInstanceDataPtr p_instance, GDExtensionBool *r_is_valid, GDExtensionStringPtr r_out) -> void 

GDExtensionScriptInstanceRefCountIncremented :: #type proc "c" (GDExtensionScriptInstanceDataPtr p_instance) -> void 
GDExtensionScriptInstanceRefCountDecremented :: #type proc "c" (GDExtensionScriptInstanceDataPtr p_instance) -> GDExtensionBool 

GDExtensionScriptInstanceGetScript :: #type proc "c" (GDExtensionScriptInstanceDataPtr p_instance) -> GDExtensionObjectPtr 
GDExtensionScriptInstanceIsPlaceholder :: #type proc "c" (GDExtensionScriptInstanceDataPtr p_instance) -> GDExtensionBool 

typedef void *GDExtensionScriptLanguagePtr;

GDExtensionScriptInstanceGetLanguage :: #type proc "c" (GDExtensionScriptInstanceDataPtr p_instance) -> GDExtensionScriptLanguagePtr 

GDExtensionScriptInstanceFree :: #type proc "c" (GDExtensionScriptInstanceDataPtr p_instance) -> void 

typedef void *GDExtensionScriptInstancePtr; // Pointer to ScriptInstance.

GDExtensionScriptInstanceInfo :: struct {
	set_func: GDExtensionScriptInstanceSet,
	get_func: GDExtensionScriptInstanceGet,
	get_property_list_func: GDExtensionScriptInstanceGetPropertyList,
	free_property_list_func: GDExtensionScriptInstanceFreePropertyList,

	property_can_revert_func: GDExtensionScriptInstancePropertyCanRevert,
	property_get_revert_func: GDExtensionScriptInstancePropertyGetRevert,

	get_owner_func: GDExtensionScriptInstanceGetOwner,
	get_property_state_func: GDExtensionScriptInstanceGetPropertyState,

	get_method_list_func: GDExtensionScriptInstanceGetMethodList,
	free_method_list_func: GDExtensionScriptInstanceFreeMethodList,
	get_property_type_func: GDExtensionScriptInstanceGetPropertyType,

	has_method_func: GDExtensionScriptInstanceHasMethod,

	call_func: GDExtensionScriptInstanceCall,
	notification_func: GDExtensionScriptInstanceNotification,

	to_string_func: GDExtensionScriptInstanceToString,

	refcount_incremented_func: GDExtensionScriptInstanceRefCountIncremented,
	refcount_decremented_func: GDExtensionScriptInstanceRefCountDecremented,

	get_script_func: GDExtensionScriptInstanceGetScript,

	is_placeholder_func: GDExtensionScriptInstanceIsPlaceholder,

	set_fallback_func: GDExtensionScriptInstanceSet,
	get_fallback_func: GDExtensionScriptInstanceGet,

	get_language_func: GDExtensionScriptInstanceGetLanguage,

	free_func: GDExtensionScriptInstanceFree,
}// Deprecated. Use GDExtensionScriptInstanceInfo2 instead.

GDExtensionScriptInstanceInfo2 :: struct {
	set_func: GDExtensionScriptInstanceSet,
	get_func: GDExtensionScriptInstanceGet,
	get_property_list_func: GDExtensionScriptInstanceGetPropertyList,
	free_property_list_func: GDExtensionScriptInstanceFreePropertyList,
	get_class_category_func: GDExtensionScriptInstanceGetClassCategory, // Optional. Set to NULL for the default behavior.

	property_can_revert_func: GDExtensionScriptInstancePropertyCanRevert,
	property_get_revert_func: GDExtensionScriptInstancePropertyGetRevert,

	get_owner_func: GDExtensionScriptInstanceGetOwner,
	get_property_state_func: GDExtensionScriptInstanceGetPropertyState,

	get_method_list_func: GDExtensionScriptInstanceGetMethodList,
	free_method_list_func: GDExtensionScriptInstanceFreeMethodList,
	get_property_type_func: GDExtensionScriptInstanceGetPropertyType,
	validate_property_func: GDExtensionScriptInstanceValidateProperty,

	has_method_func: GDExtensionScriptInstanceHasMethod,

	call_func: GDExtensionScriptInstanceCall,
	notification_func: GDExtensionScriptInstanceNotification2,

	to_string_func: GDExtensionScriptInstanceToString,

	refcount_incremented_func: GDExtensionScriptInstanceRefCountIncremented,
	refcount_decremented_func: GDExtensionScriptInstanceRefCountDecremented,

	get_script_func: GDExtensionScriptInstanceGetScript,

	is_placeholder_func: GDExtensionScriptInstanceIsPlaceholder,

	set_fallback_func: GDExtensionScriptInstanceSet,
	get_fallback_func: GDExtensionScriptInstanceGet,

	get_language_func: GDExtensionScriptInstanceGetLanguage,

	free_func: GDExtensionScriptInstanceFree,

}

/* INITIALIZATION */

GDExtensionInitializationLevel :: enum i32 {
	GDEXTENSION_INITIALIZATION_CORE,
	GDEXTENSION_INITIALIZATION_SERVERS,
	GDEXTENSION_INITIALIZATION_SCENE,
	GDEXTENSION_INITIALIZATION_EDITOR,
	GDEXTENSION_MAX_INITIALIZATION_LEVEL,
}

GDExtensionInitialization :: struct {
	/* Minimum initialization level required.
	 * If Core or Servers, the extension needs editor or game restart to take effect */
	minimum_initialization_level: GDExtensionInitializationLevel,
	/* Up to the user to supply when initializing */
	userdata: *void,
	/* This function will be called multiple times for each initialization level. */
	initialize : proc "c" (rawptr, GDExtensionInitializationLevel),
	deinitialize : proc "c" (rawptr, GDExtensionInitializationLevel),
}

GDExtensionInterfaceFunctionPtr :: #type proc "c" () -> void 
GDExtensionInterfaceGetProcAddress :: #type proc "c" (char *p_function_name) -> GDExtensionInterfaceFunctionPtr 

/*
 * Each GDExtension should define a C function that matches the signature of GDExtensionInitializationFunction,
 * and export it so that it can be loaded via dlopen() or equivalent for the given platform.
 *
 * For example:
 *
 *   GDExtensionBool my_extension_init(GDExtensionInterfaceGetProcAddress p_get_proc_address, GDExtensionClassLibraryPtr p_library, GDExtensionInitialization *r_initialization);
 *
 * This function's name must be specified as the 'entry_symbol' in the .gdextension file.
 *
 * This makes it the entry point of the GDExtension and will be called on initialization.
 *
 * The GDExtension can then modify the r_initialization structure, setting the minimum initialization level,
 * and providing pointers to functions that will be called at various stages of initialization/shutdown.
 *
 * The rest of the GDExtension's interface to Godot consists of function pointers that can be loaded
 * by calling p_get_proc_address("...") with the name of the function.
 *
 * For example:
 *
 *   GDExtensionInterfaceGetGodotVersion get_godot_version = (GDExtensionInterfaceGetGodotVersion)p_get_proc_address("get_godot_version");
 *
 * (Note that snippet may cause "cast between incompatible function types" on some compilers, you can
 * silence this by adding an intermediary `void*` cast.)
 *
 * You can then call it like a normal function:
 *
 *   GDExtensionGodotVersion godot_version;
 *   get_godot_version(&godot_version);
 *   printf("Godot v%d.%d.%d\n", godot_version.major, godot_version.minor, godot_version.patch);
 *
 * All of these interface functions are described below, together with the name that's used to load it,
 * and the function pointer typedef that shows its signature.
 */
GDExtensionInitializationFunction :: #type proc "c" (GDExtensionInterfaceGetProcAddress p_get_proc_address, GDExtensionClassLibraryPtr p_library, GDExtensionInitialization *r_initialization) -> GDExtensionBool 

/* INTERFACE */

GDExtensionGodotVersion :: struct {
	major: uint32_t,
	minor: uint32_t,
	patch: uint32_t,
	str: *char,
}

/**
 * @name get_godot_version
 * @since 4.1
 *
 * Gets the Godot version that the GDExtension was loaded into.
 *
 * @param r_godot_version A pointer to the structure to write the version information into.
 */
GDExtensionInterfaceGetGodotVersion :: #type proc "c" (GDExtensionGodotVersion *r_godot_version) -> void 

/* INTERFACE: Memory */

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
GDExtensionInterfaceMemAlloc :: #type proc "c" (size_t p_bytes) -> void *

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
GDExtensionInterfaceMemRealloc :: #type proc "c" (void *p_ptr, size_t p_bytes) -> void *

/**
 * @name mem_free
 * @since 4.1
 *
 * Frees memory.
 *
 * @param p_ptr A pointer to the previously allocated memory.
 */
GDExtensionInterfaceMemFree :: #type proc "c" (void *p_ptr) -> void 

/* INTERFACE: Godot Core */

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
GDExtensionInterfacePrintError :: #type proc "c" (char *p_description, char *p_function, char *p_file, int32_t p_line, GDExtensionBool p_editor_notify) -> void 

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
GDExtensionInterfacePrintErrorWithMessage :: #type proc "c" (char *p_description, char *p_message, char *p_function, char *p_file, int32_t p_line, GDExtensionBool p_editor_notify) -> void 

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
GDExtensionInterfacePrintWarning :: #type proc "c" (char *p_description, char *p_function, char *p_file, int32_t p_line, GDExtensionBool p_editor_notify) -> void 

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
GDExtensionInterfacePrintWarningWithMessage :: #type proc "c" (char *p_description, char *p_message, char *p_function, char *p_file, int32_t p_line, GDExtensionBool p_editor_notify) -> void 

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
GDExtensionInterfacePrintScriptError :: #type proc "c" (char *p_description, char *p_function, char *p_file, int32_t p_line, GDExtensionBool p_editor_notify) -> void 

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
GDExtensionInterfacePrintScriptErrorWithMessage :: #type proc "c" (char *p_description, char *p_message, char *p_function, char *p_file, int32_t p_line, GDExtensionBool p_editor_notify) -> void 

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
GDExtensionInterfaceGetNativeStructSize :: #type proc "c" (GDExtensionConstStringNamePtr p_name) -> uint64_t 

/* INTERFACE: Variant */

/**
 * @name variant_new_copy
 * @since 4.1
 *
 * Copies one Variant into a another.
 *
 * @param r_dest A pointer to the destination Variant.
 * @param p_src A pointer to the source Variant.
 */
GDExtensionInterfaceVariantNewCopy :: #type proc "c" (GDExtensionUninitializedVariantPtr r_dest, GDExtensionConstVariantPtr p_src) -> void 

/**
 * @name variant_new_nil
 * @since 4.1
 *
 * Creates a new Variant containing nil.
 *
 * @param r_dest A pointer to the destination Variant.
 */
GDExtensionInterfaceVariantNewNil :: #type proc "c" (GDExtensionUninitializedVariantPtr r_dest) -> void 

/**
 * @name variant_destroy
 * @since 4.1
 *
 * Destroys a Variant.
 *
 * @param p_self A pointer to the Variant to destroy.
 */
GDExtensionInterfaceVariantDestroy :: #type proc "c" (GDExtensionVariantPtr p_self) -> void 

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
GDExtensionInterfaceVariantCall :: #type proc "c" (GDExtensionVariantPtr p_self, GDExtensionConstStringNamePtr p_method, GDExtensionConstVariantPtr *p_args, GDExtensionInt p_argument_count, GDExtensionUninitializedVariantPtr r_return, GDExtensionCallError *r_error) -> void 

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
GDExtensionInterfaceVariantCallStatic :: #type proc "c" (GDExtensionVariantType p_type, GDExtensionConstStringNamePtr p_method, GDExtensionConstVariantPtr *p_args, GDExtensionInt p_argument_count, GDExtensionUninitializedVariantPtr r_return, GDExtensionCallError *r_error) -> void 

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
GDExtensionInterfaceVariantEvaluate :: #type proc "c" (GDExtensionVariantOperator p_op, GDExtensionConstVariantPtr p_a, GDExtensionConstVariantPtr p_b, GDExtensionUninitializedVariantPtr r_return, GDExtensionBool *r_valid) -> void 

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
GDExtensionInterfaceVariantSet :: #type proc "c" (GDExtensionVariantPtr p_self, GDExtensionConstVariantPtr p_key, GDExtensionConstVariantPtr p_value, GDExtensionBool *r_valid) -> void 

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
GDExtensionInterfaceVariantSetNamed :: #type proc "c" (GDExtensionVariantPtr p_self, GDExtensionConstStringNamePtr p_key, GDExtensionConstVariantPtr p_value, GDExtensionBool *r_valid) -> void 

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
GDExtensionInterfaceVariantSetKeyed :: #type proc "c" (GDExtensionVariantPtr p_self, GDExtensionConstVariantPtr p_key, GDExtensionConstVariantPtr p_value, GDExtensionBool *r_valid) -> void 

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
GDExtensionInterfaceVariantSetIndexed :: #type proc "c" (GDExtensionVariantPtr p_self, GDExtensionInt p_index, GDExtensionConstVariantPtr p_value, GDExtensionBool *r_valid, GDExtensionBool *r_oob) -> void 

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
GDExtensionInterfaceVariantGet :: #type proc "c" (GDExtensionConstVariantPtr p_self, GDExtensionConstVariantPtr p_key, GDExtensionUninitializedVariantPtr r_ret, GDExtensionBool *r_valid) -> void 

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
GDExtensionInterfaceVariantGetNamed :: #type proc "c" (GDExtensionConstVariantPtr p_self, GDExtensionConstStringNamePtr p_key, GDExtensionUninitializedVariantPtr r_ret, GDExtensionBool *r_valid) -> void 

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
GDExtensionInterfaceVariantGetKeyed :: #type proc "c" (GDExtensionConstVariantPtr p_self, GDExtensionConstVariantPtr p_key, GDExtensionUninitializedVariantPtr r_ret, GDExtensionBool *r_valid) -> void 

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
GDExtensionInterfaceVariantGetIndexed :: #type proc "c" (GDExtensionConstVariantPtr p_self, GDExtensionInt p_index, GDExtensionUninitializedVariantPtr r_ret, GDExtensionBool *r_valid, GDExtensionBool *r_oob) -> void 

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
GDExtensionInterfaceVariantIterInit :: #type proc "c" (GDExtensionConstVariantPtr p_self, GDExtensionUninitializedVariantPtr r_iter, GDExtensionBool *r_valid) -> GDExtensionBool 

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
GDExtensionInterfaceVariantIterNext :: #type proc "c" (GDExtensionConstVariantPtr p_self, GDExtensionVariantPtr r_iter, GDExtensionBool *r_valid) -> GDExtensionBool 

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
GDExtensionInterfaceVariantIterGet :: #type proc "c" (GDExtensionConstVariantPtr p_self, GDExtensionVariantPtr r_iter, GDExtensionUninitializedVariantPtr r_ret, GDExtensionBool *r_valid) -> void 

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
GDExtensionInterfaceVariantHash :: #type proc "c" (GDExtensionConstVariantPtr p_self) -> GDExtensionInt 

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
GDExtensionInterfaceVariantRecursiveHash :: #type proc "c" (GDExtensionConstVariantPtr p_self, GDExtensionInt p_recursion_count) -> GDExtensionInt 

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
GDExtensionInterfaceVariantHashCompare :: #type proc "c" (GDExtensionConstVariantPtr p_self, GDExtensionConstVariantPtr p_other) -> GDExtensionBool 

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
GDExtensionInterfaceVariantBooleanize :: #type proc "c" (GDExtensionConstVariantPtr p_self) -> GDExtensionBool 

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
GDExtensionInterfaceVariantDuplicate :: #type proc "c" (GDExtensionConstVariantPtr p_self, GDExtensionVariantPtr r_ret, GDExtensionBool p_deep) -> void 

/**
 * @name variant_stringify
 * @since 4.1
 *
 * Converts a Variant to a string.
 *
 * @param p_self A pointer to the Variant.
 * @param r_ret A pointer to a String to store the resulting value.
 */
GDExtensionInterfaceVariantStringify :: #type proc "c" (GDExtensionConstVariantPtr p_self, GDExtensionStringPtr r_ret) -> void 

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
GDExtensionInterfaceVariantGetType :: #type proc "c" (GDExtensionConstVariantPtr p_self) -> GDExtensionVariantType 

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
GDExtensionInterfaceVariantHasMethod :: #type proc "c" (GDExtensionConstVariantPtr p_self, GDExtensionConstStringNamePtr p_method) -> GDExtensionBool 

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
GDExtensionInterfaceVariantHasMember :: #type proc "c" (GDExtensionVariantType p_type, GDExtensionConstStringNamePtr p_member) -> GDExtensionBool 

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
GDExtensionInterfaceVariantHasKey :: #type proc "c" (GDExtensionConstVariantPtr p_self, GDExtensionConstVariantPtr p_key, GDExtensionBool *r_valid) -> GDExtensionBool 

/**
 * @name variant_get_type_name
 * @since 4.1
 *
 * Gets the name of a Variant type.
 *
 * @param p_type The Variant type.
 * @param r_name A pointer to a String to store the Variant type name.
 */
GDExtensionInterfaceVariantGetTypeName :: #type proc "c" (GDExtensionVariantType p_type, GDExtensionUninitializedStringPtr r_name) -> void 

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
GDExtensionInterfaceVariantCanConvert :: #type proc "c" (GDExtensionVariantType p_from, GDExtensionVariantType p_to) -> GDExtensionBool 

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
GDExtensionInterfaceVariantCanConvertStrict :: #type proc "c" (GDExtensionVariantType p_from, GDExtensionVariantType p_to) -> GDExtensionBool 

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
GDExtensionInterfaceGetVariantFromTypeConstructor :: #type proc "c" (GDExtensionVariantType p_type) -> GDExtensionVariantFromTypeConstructorFunc 

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
GDExtensionInterfaceGetVariantToTypeConstructor :: #type proc "c" (GDExtensionVariantType p_type) -> GDExtensionTypeFromVariantConstructorFunc 

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
GDExtensionInterfaceVariantGetPtrOperatorEvaluator :: #type proc "c" (GDExtensionVariantOperator p_operator, GDExtensionVariantType p_type_a, GDExtensionVariantType p_type_b) -> GDExtensionPtrOperatorEvaluator 

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
GDExtensionInterfaceVariantGetPtrBuiltinMethod :: #type proc "c" (GDExtensionVariantType p_type, GDExtensionConstStringNamePtr p_method, GDExtensionInt p_hash) -> GDExtensionPtrBuiltInMethod 

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
GDExtensionInterfaceVariantGetPtrConstructor :: #type proc "c" (GDExtensionVariantType p_type, int32_t p_constructor) -> GDExtensionPtrConstructor 

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
GDExtensionInterfaceVariantGetPtrDestructor :: #type proc "c" (GDExtensionVariantType p_type) -> GDExtensionPtrDestructor 

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
GDExtensionInterfaceVariantConstruct :: #type proc "c" (GDExtensionVariantType p_type, GDExtensionUninitializedVariantPtr r_base, GDExtensionConstVariantPtr *p_args, int32_t p_argument_count, GDExtensionCallError *r_error) -> void 

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
GDExtensionInterfaceVariantGetPtrSetter :: #type proc "c" (GDExtensionVariantType p_type, GDExtensionConstStringNamePtr p_member) -> GDExtensionPtrSetter 

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
GDExtensionInterfaceVariantGetPtrGetter :: #type proc "c" (GDExtensionVariantType p_type, GDExtensionConstStringNamePtr p_member) -> GDExtensionPtrGetter 

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
GDExtensionInterfaceVariantGetPtrIndexedSetter :: #type proc "c" (GDExtensionVariantType p_type) -> GDExtensionPtrIndexedSetter 

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
GDExtensionInterfaceVariantGetPtrIndexedGetter :: #type proc "c" (GDExtensionVariantType p_type) -> GDExtensionPtrIndexedGetter 

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
GDExtensionInterfaceVariantGetPtrKeyedSetter :: #type proc "c" (GDExtensionVariantType p_type) -> GDExtensionPtrKeyedSetter 

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
GDExtensionInterfaceVariantGetPtrKeyedGetter :: #type proc "c" (GDExtensionVariantType p_type) -> GDExtensionPtrKeyedGetter 

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
GDExtensionInterfaceVariantGetPtrKeyedChecker :: #type proc "c" (GDExtensionVariantType p_type) -> GDExtensionPtrKeyedChecker 

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
GDExtensionInterfaceVariantGetConstantValue :: #type proc "c" (GDExtensionVariantType p_type, GDExtensionConstStringNamePtr p_constant, GDExtensionUninitializedVariantPtr r_ret) -> void 

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
GDExtensionInterfaceVariantGetPtrUtilityFunction :: #type proc "c" (GDExtensionConstStringNamePtr p_function, GDExtensionInt p_hash) -> GDExtensionPtrUtilityFunction 

/* INTERFACE: String Utilities */

/**
 * @name string_new_with_latin1_chars
 * @since 4.1
 *
 * Creates a String from a Latin-1 encoded C string.
 *
 * @param r_dest A pointer to a Variant to hold the newly created String.
 * @param p_contents A pointer to a Latin-1 encoded C string (null terminated).
 */
GDExtensionInterfaceStringNewWithLatin1Chars :: #type proc "c" (GDExtensionUninitializedStringPtr r_dest, char *p_contents) -> void 

/**
 * @name string_new_with_utf8_chars
 * @since 4.1
 *
 * Creates a String from a UTF-8 encoded C string.
 *
 * @param r_dest A pointer to a Variant to hold the newly created String.
 * @param p_contents A pointer to a UTF-8 encoded C string (null terminated).
 */
GDExtensionInterfaceStringNewWithUtf8Chars :: #type proc "c" (GDExtensionUninitializedStringPtr r_dest, char *p_contents) -> void 

/**
 * @name string_new_with_utf16_chars
 * @since 4.1
 *
 * Creates a String from a UTF-16 encoded C string.
 *
 * @param r_dest A pointer to a Variant to hold the newly created String.
 * @param p_contents A pointer to a UTF-16 encoded C string (null terminated).
 */
GDExtensionInterfaceStringNewWithUtf16Chars :: #type proc "c" (GDExtensionUninitializedStringPtr r_dest, char16_t *p_contents) -> void 

/**
 * @name string_new_with_utf32_chars
 * @since 4.1
 *
 * Creates a String from a UTF-32 encoded C string.
 *
 * @param r_dest A pointer to a Variant to hold the newly created String.
 * @param p_contents A pointer to a UTF-32 encoded C string (null terminated).
 */
GDExtensionInterfaceStringNewWithUtf32Chars :: #type proc "c" (GDExtensionUninitializedStringPtr r_dest, char32_t *p_contents) -> void 

/**
 * @name string_new_with_wide_chars
 * @since 4.1
 *
 * Creates a String from a wide C string.
 *
 * @param r_dest A pointer to a Variant to hold the newly created String.
 * @param p_contents A pointer to a wide C string (null terminated).
 */
GDExtensionInterfaceStringNewWithWideChars :: #type proc "c" (GDExtensionUninitializedStringPtr r_dest, wchar_t *p_contents) -> void 

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
GDExtensionInterfaceStringNewWithLatin1CharsAndLen :: #type proc "c" (GDExtensionUninitializedStringPtr r_dest, char *p_contents, GDExtensionInt p_size) -> void 

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
GDExtensionInterfaceStringNewWithUtf8CharsAndLen :: #type proc "c" (GDExtensionUninitializedStringPtr r_dest, char *p_contents, GDExtensionInt p_size) -> void 

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
GDExtensionInterfaceStringNewWithUtf16CharsAndLen :: #type proc "c" (GDExtensionUninitializedStringPtr r_dest, char16_t *p_contents, GDExtensionInt p_char_count) -> void 

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
GDExtensionInterfaceStringNewWithUtf32CharsAndLen :: #type proc "c" (GDExtensionUninitializedStringPtr r_dest, char32_t *p_contents, GDExtensionInt p_char_count) -> void 

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
GDExtensionInterfaceStringNewWithWideCharsAndLen :: #type proc "c" (GDExtensionUninitializedStringPtr r_dest, wchar_t *p_contents, GDExtensionInt p_char_count) -> void 

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
GDExtensionInterfaceStringToLatin1Chars :: #type proc "c" (GDExtensionConstStringPtr p_self, char *r_text, GDExtensionInt p_max_write_length) -> GDExtensionInt 

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
GDExtensionInterfaceStringToUtf8Chars :: #type proc "c" (GDExtensionConstStringPtr p_self, char *r_text, GDExtensionInt p_max_write_length) -> GDExtensionInt 

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
GDExtensionInterfaceStringToUtf16Chars :: #type proc "c" (GDExtensionConstStringPtr p_self, char16_t *r_text, GDExtensionInt p_max_write_length) -> GDExtensionInt 

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
GDExtensionInterfaceStringToUtf32Chars :: #type proc "c" (GDExtensionConstStringPtr p_self, char32_t *r_text, GDExtensionInt p_max_write_length) -> GDExtensionInt 

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
GDExtensionInterfaceStringToWideChars :: #type proc "c" (GDExtensionConstStringPtr p_self, wchar_t *r_text, GDExtensionInt p_max_write_length) -> GDExtensionInt 

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
GDExtensionInterfaceStringOperatorIndex :: #type proc "c" (GDExtensionStringPtr p_self, GDExtensionInt p_index) -> char32_t *

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
GDExtensionInterfaceStringOperatorIndexConst :: #type proc "c" (GDExtensionConstStringPtr p_self, GDExtensionInt p_index) -> char32_t *

/**
 * @name string_operator_plus_eq_string
 * @since 4.1
 *
 * Appends another String to a String.
 *
 * @param p_self A pointer to the String.
 * @param p_b A pointer to the other String to append.
 */
GDExtensionInterfaceStringOperatorPlusEqString :: #type proc "c" (GDExtensionStringPtr p_self, GDExtensionConstStringPtr p_b) -> void 

/**
 * @name string_operator_plus_eq_char
 * @since 4.1
 *
 * Appends a character to a String.
 *
 * @param p_self A pointer to the String.
 * @param p_b A pointer to the character to append.
 */
GDExtensionInterfaceStringOperatorPlusEqChar :: #type proc "c" (GDExtensionStringPtr p_self, char32_t p_b) -> void 

/**
 * @name string_operator_plus_eq_cstr
 * @since 4.1
 *
 * Appends a Latin-1 encoded C string to a String.
 *
 * @param p_self A pointer to the String.
 * @param p_b A pointer to a Latin-1 encoded C string (null terminated).
 */
GDExtensionInterfaceStringOperatorPlusEqCstr :: #type proc "c" (GDExtensionStringPtr p_self, char *p_b) -> void 

/**
 * @name string_operator_plus_eq_wcstr
 * @since 4.1
 *
 * Appends a wide C string to a String.
 *
 * @param p_self A pointer to the String.
 * @param p_b A pointer to a wide C string (null terminated).
 */
GDExtensionInterfaceStringOperatorPlusEqWcstr :: #type proc "c" (GDExtensionStringPtr p_self, wchar_t *p_b) -> void 

/**
 * @name string_operator_plus_eq_c32str
 * @since 4.1
 *
 * Appends a UTF-32 encoded C string to a String.
 *
 * @param p_self A pointer to the String.
 * @param p_b A pointer to a UTF-32 encoded C string (null terminated).
 */
GDExtensionInterfaceStringOperatorPlusEqC32str :: #type proc "c" (GDExtensionStringPtr p_self, char32_t *p_b) -> void 

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
GDExtensionInterfaceStringResize :: #type proc "c" (GDExtensionStringPtr p_self, GDExtensionInt p_resize) -> GDExtensionInt 

/* INTERFACE: StringName Utilities */

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
GDExtensionInterfaceStringNameNewWithLatin1Chars :: #type proc "c" (GDExtensionUninitializedStringNamePtr r_dest, char *p_contents, GDExtensionBool p_is_static) -> void 

/**
 * @name string_name_new_with_utf8_chars
 * @since 4.2
 *
 * Creates a StringName from a UTF-8 encoded C string.
 *
 * @param r_dest A pointer to uninitialized storage, into which the newly created StringName is constructed.
 * @param p_contents A pointer to a C string (null terminated and UTF-8 encoded).
 */
GDExtensionInterfaceStringNameNewWithUtf8Chars :: #type proc "c" (GDExtensionUninitializedStringNamePtr r_dest, char *p_contents) -> void 

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
GDExtensionInterfaceStringNameNewWithUtf8CharsAndLen :: #type proc "c" (GDExtensionUninitializedStringNamePtr r_dest, char *p_contents, GDExtensionInt p_size) -> void 

/* INTERFACE: XMLParser Utilities */

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
GDExtensionInterfaceXmlParserOpenBuffer :: #type proc "c" (GDExtensionObjectPtr p_instance, uint8_t *p_buffer, size_t p_size) -> GDExtensionInt 

/* INTERFACE: FileAccess Utilities */

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
GDExtensionInterfaceFileAccessStoreBuffer :: #type proc "c" (GDExtensionObjectPtr p_instance, uint8_t *p_src, uint64_t p_length) -> void 

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
GDExtensionInterfaceFileAccessGetBuffer :: #type proc "c" (GDExtensionConstObjectPtr p_instance, uint8_t *p_dst, uint64_t p_length) -> uint64_t 

/* INTERFACE: WorkerThreadPool Utilities */

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
GDExtensionInterfaceWorkerThreadPoolAddNativeGroupTask :: #type proc "c" (GDExtensionObjectPtr p_instance, void (*p_func)(void *, uint32_t), void *p_userdata, int p_elements, int p_tasks, GDExtensionBool p_high_priority, GDExtensionConstStringPtr p_description) -> int64_t 

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
GDExtensionInterfaceWorkerThreadPoolAddNativeTask :: #type proc "c" (GDExtensionObjectPtr p_instance, void (*p_func)(void *), void *p_userdata, GDExtensionBool p_high_priority, GDExtensionConstStringPtr p_description) -> int64_t 

/* INTERFACE: Packed Array */

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
GDExtensionInterfacePackedByteArrayOperatorIndex :: #type proc "c" (GDExtensionTypePtr p_self, GDExtensionInt p_index) -> uint8_t *

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
GDExtensionInterfacePackedByteArrayOperatorIndexConst :: #type proc "c" (GDExtensionConstTypePtr p_self, GDExtensionInt p_index) -> uint8_t *

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
GDExtensionInterfacePackedColorArrayOperatorIndex :: #type proc "c" (GDExtensionTypePtr p_self, GDExtensionInt p_index) -> GDExtensionTypePtr 

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
GDExtensionInterfacePackedColorArrayOperatorIndexConst :: #type proc "c" (GDExtensionConstTypePtr p_self, GDExtensionInt p_index) -> GDExtensionTypePtr 

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
GDExtensionInterfacePackedFloat32ArrayOperatorIndex :: #type proc "c" (GDExtensionTypePtr p_self, GDExtensionInt p_index) -> float *

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
GDExtensionInterfacePackedFloat32ArrayOperatorIndexConst :: #type proc "c" (GDExtensionConstTypePtr p_self, GDExtensionInt p_index) -> float *

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
GDExtensionInterfacePackedFloat64ArrayOperatorIndex :: #type proc "c" (GDExtensionTypePtr p_self, GDExtensionInt p_index) -> double *

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
GDExtensionInterfacePackedFloat64ArrayOperatorIndexConst :: #type proc "c" (GDExtensionConstTypePtr p_self, GDExtensionInt p_index) -> double *

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
GDExtensionInterfacePackedInt32ArrayOperatorIndex :: #type proc "c" (GDExtensionTypePtr p_self, GDExtensionInt p_index) -> int32_t *

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
GDExtensionInterfacePackedInt32ArrayOperatorIndexConst :: #type proc "c" (GDExtensionConstTypePtr p_self, GDExtensionInt p_index) -> int32_t *

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
GDExtensionInterfacePackedInt64ArrayOperatorIndex :: #type proc "c" (GDExtensionTypePtr p_self, GDExtensionInt p_index) -> int64_t *

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
GDExtensionInterfacePackedInt64ArrayOperatorIndexConst :: #type proc "c" (GDExtensionConstTypePtr p_self, GDExtensionInt p_index) -> int64_t *

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
GDExtensionInterfacePackedStringArrayOperatorIndex :: #type proc "c" (GDExtensionTypePtr p_self, GDExtensionInt p_index) -> GDExtensionStringPtr 

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
GDExtensionInterfacePackedStringArrayOperatorIndexConst :: #type proc "c" (GDExtensionConstTypePtr p_self, GDExtensionInt p_index) -> GDExtensionStringPtr 

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
GDExtensionInterfacePackedVector2ArrayOperatorIndex :: #type proc "c" (GDExtensionTypePtr p_self, GDExtensionInt p_index) -> GDExtensionTypePtr 

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
GDExtensionInterfacePackedVector2ArrayOperatorIndexConst :: #type proc "c" (GDExtensionConstTypePtr p_self, GDExtensionInt p_index) -> GDExtensionTypePtr 

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
GDExtensionInterfacePackedVector3ArrayOperatorIndex :: #type proc "c" (GDExtensionTypePtr p_self, GDExtensionInt p_index) -> GDExtensionTypePtr 

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
GDExtensionInterfacePackedVector3ArrayOperatorIndexConst :: #type proc "c" (GDExtensionConstTypePtr p_self, GDExtensionInt p_index) -> GDExtensionTypePtr 

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
GDExtensionInterfaceArrayOperatorIndex :: #type proc "c" (GDExtensionTypePtr p_self, GDExtensionInt p_index) -> GDExtensionVariantPtr 

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
GDExtensionInterfaceArrayOperatorIndexConst :: #type proc "c" (GDExtensionConstTypePtr p_self, GDExtensionInt p_index) -> GDExtensionVariantPtr 

/**
 * @name array_ref
 * @since 4.1
 *
 * Sets an Array to be a reference to another Array object.
 *
 * @param p_self A pointer to the Array object to update.
 * @param p_from A pointer to the Array object to reference.
 */
GDExtensionInterfaceArrayRef :: #type proc "c" (GDExtensionTypePtr p_self, GDExtensionConstTypePtr p_from) -> void 

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
GDExtensionInterfaceArraySetTyped :: #type proc "c" (GDExtensionTypePtr p_self, GDExtensionVariantType p_type, GDExtensionConstStringNamePtr p_class_name, GDExtensionConstVariantPtr p_script) -> void 

/* INTERFACE: Dictionary */

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
GDExtensionInterfaceDictionaryOperatorIndex :: #type proc "c" (GDExtensionTypePtr p_self, GDExtensionConstVariantPtr p_key) -> GDExtensionVariantPtr 

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
GDExtensionInterfaceDictionaryOperatorIndexConst :: #type proc "c" (GDExtensionConstTypePtr p_self, GDExtensionConstVariantPtr p_key) -> GDExtensionVariantPtr 

/* INTERFACE: Object */

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
GDExtensionInterfaceObjectMethodBindCall :: #type proc "c" (GDExtensionMethodBindPtr p_method_bind, GDExtensionObjectPtr p_instance, GDExtensionConstVariantPtr *p_args, GDExtensionInt p_arg_count, GDExtensionUninitializedVariantPtr r_ret, GDExtensionCallError *r_error) -> void 

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
GDExtensionInterfaceObjectMethodBindPtrcall :: #type proc "c" (GDExtensionMethodBindPtr p_method_bind, GDExtensionObjectPtr p_instance, GDExtensionConstTypePtr *p_args, GDExtensionTypePtr r_ret) -> void 

/**
 * @name object_destroy
 * @since 4.1
 *
 * Destroys an Object.
 *
 * @param p_o A pointer to the Object.
 */
GDExtensionInterfaceObjectDestroy :: #type proc "c" (GDExtensionObjectPtr p_o) -> void 

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
GDExtensionInterfaceGlobalGetSingleton :: #type proc "c" (GDExtensionConstStringNamePtr p_name) -> GDExtensionObjectPtr 

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
GDExtensionInterfaceObjectGetInstanceBinding :: #type proc "c" (GDExtensionObjectPtr p_o, void *p_token, GDExtensionInstanceBindingCallbacks *p_callbacks) -> void *

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
GDExtensionInterfaceObjectSetInstanceBinding :: #type proc "c" (GDExtensionObjectPtr p_o, void *p_token, void *p_binding, GDExtensionInstanceBindingCallbacks *p_callbacks) -> void 

/**
 * @name object_free_instance_binding
 * @since 4.2
 *
 * Free an Object's instance binding.
 *
 * @param p_o A pointer to the Object.
 * @param p_library A token the library received by the GDExtension's entry point function.
 */
GDExtensionInterfaceObjectFreeInstanceBinding :: #type proc "c" (GDExtensionObjectPtr p_o, void *p_token) -> void 

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
GDExtensionInterfaceObjectSetInstance :: #type proc "c" (GDExtensionObjectPtr p_o, GDExtensionConstStringNamePtr p_classname, GDExtensionClassInstancePtr p_instance) -> void  /* p_classname should be a registered extension class and should extend the p_o object's class. */

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
GDExtensionInterfaceObjectGetClassName :: #type proc "c" (GDExtensionConstObjectPtr p_object, GDExtensionClassLibraryPtr p_library, GDExtensionUninitializedStringNamePtr r_class_name) -> GDExtensionBool 

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
GDExtensionInterfaceObjectCastTo :: #type proc "c" (GDExtensionConstObjectPtr p_object, void *p_class_tag) -> GDExtensionObjectPtr 

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
GDExtensionInterfaceObjectGetInstanceFromId :: #type proc "c" (GDObjectInstanceID p_instance_id) -> GDExtensionObjectPtr 

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
GDExtensionInterfaceObjectGetInstanceId :: #type proc "c" (GDExtensionConstObjectPtr p_object) -> GDObjectInstanceID 

/* INTERFACE: Reference */

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
GDExtensionInterfaceRefGetObject :: #type proc "c" (GDExtensionConstRefPtr p_ref) -> GDExtensionObjectPtr 

/**
 * @name ref_set_object
 * @since 4.1
 *
 * Sets the Object referred to by a reference.
 *
 * @param p_ref A pointer to the reference.
 * @param p_object A pointer to the Object to refer to.
 */
GDExtensionInterfaceRefSetObject :: #type proc "c" (GDExtensionRefPtr p_ref, GDExtensionObjectPtr p_object) -> void 

/* INTERFACE: Script Instance */

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
GDExtensionInterfaceScriptInstanceCreate :: #type proc "c" (GDExtensionScriptInstanceInfo *p_info, GDExtensionScriptInstanceDataPtr p_instance_data) -> GDExtensionScriptInstancePtr 

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
GDExtensionInterfaceScriptInstanceCreate2 :: #type proc "c" (GDExtensionScriptInstanceInfo2 *p_info, GDExtensionScriptInstanceDataPtr p_instance_data) -> GDExtensionScriptInstancePtr 

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
GDExtensionInterfacePlaceHolderScriptInstanceCreate :: #type proc "c" (GDExtensionObjectPtr p_language, GDExtensionObjectPtr p_script, GDExtensionObjectPtr p_owner) -> GDExtensionScriptInstancePtr 

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
GDExtensionInterfacePlaceHolderScriptInstanceUpdate :: #type proc "c" (GDExtensionScriptInstancePtr p_placeholder, GDExtensionConstTypePtr p_properties, GDExtensionConstTypePtr p_values) -> void 

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
GDExtensionInterfaceObjectGetScriptInstance :: #type proc "c" (GDExtensionConstObjectPtr p_object, GDExtensionObjectPtr p_language) -> GDExtensionScriptInstanceDataPtr 

/* INTERFACE: Callable */

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
GDExtensionInterfaceCallableCustomCreate :: #type proc "c" (GDExtensionUninitializedTypePtr r_callable, GDExtensionCallableCustomInfo *p_callable_custom_info) -> void 

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
GDExtensionInterfaceCallableCustomGetUserData :: #type proc "c" (GDExtensionConstTypePtr p_callable, void *p_token) -> void *

/* INTERFACE: ClassDB */

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
GDExtensionInterfaceClassdbConstructObject :: #type proc "c" (GDExtensionConstStringNamePtr p_classname) -> GDExtensionObjectPtr 

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
GDExtensionInterfaceClassdbGetMethodBind :: #type proc "c" (GDExtensionConstStringNamePtr p_classname, GDExtensionConstStringNamePtr p_methodname, GDExtensionInt p_hash) -> GDExtensionMethodBindPtr 

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
GDExtensionInterfaceClassdbGetClassTag :: #type proc "c" (GDExtensionConstStringNamePtr p_classname) -> void *

/* INTERFACE: ClassDB Extension */

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
GDExtensionInterfaceClassdbRegisterExtensionClass :: #type proc "c" (GDExtensionClassLibraryPtr p_library, GDExtensionConstStringNamePtr p_class_name, GDExtensionConstStringNamePtr p_parent_class_name, GDExtensionClassCreationInfo *p_extension_funcs) -> void 

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
GDExtensionInterfaceClassdbRegisterExtensionClass2 :: #type proc "c" (GDExtensionClassLibraryPtr p_library, GDExtensionConstStringNamePtr p_class_name, GDExtensionConstStringNamePtr p_parent_class_name, GDExtensionClassCreationInfo2 *p_extension_funcs) -> void 

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
GDExtensionInterfaceClassdbRegisterExtensionClassMethod :: #type proc "c" (GDExtensionClassLibraryPtr p_library, GDExtensionConstStringNamePtr p_class_name, GDExtensionClassMethodInfo *p_method_info) -> void 

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
GDExtensionInterfaceClassdbRegisterExtensionClassIntegerConstant :: #type proc "c" (GDExtensionClassLibraryPtr p_library, GDExtensionConstStringNamePtr p_class_name, GDExtensionConstStringNamePtr p_enum_name, GDExtensionConstStringNamePtr p_constant_name, GDExtensionInt p_constant_value, GDExtensionBool p_is_bitfield) -> void 

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
GDExtensionInterfaceClassdbRegisterExtensionClassProperty :: #type proc "c" (GDExtensionClassLibraryPtr p_library, GDExtensionConstStringNamePtr p_class_name, GDExtensionPropertyInfo *p_info, GDExtensionConstStringNamePtr p_setter, GDExtensionConstStringNamePtr p_getter) -> void 

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
GDExtensionInterfaceClassdbRegisterExtensionClassPropertyIndexed :: #type proc "c" (GDExtensionClassLibraryPtr p_library, GDExtensionConstStringNamePtr p_class_name, GDExtensionPropertyInfo *p_info, GDExtensionConstStringNamePtr p_setter, GDExtensionConstStringNamePtr p_getter, GDExtensionInt p_index) -> void 

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
GDExtensionInterfaceClassdbRegisterExtensionClassPropertyGroup :: #type proc "c" (GDExtensionClassLibraryPtr p_library, GDExtensionConstStringNamePtr p_class_name, GDExtensionConstStringPtr p_group_name, GDExtensionConstStringPtr p_prefix) -> void 

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
GDExtensionInterfaceClassdbRegisterExtensionClassPropertySubgroup :: #type proc "c" (GDExtensionClassLibraryPtr p_library, GDExtensionConstStringNamePtr p_class_name, GDExtensionConstStringPtr p_subgroup_name, GDExtensionConstStringPtr p_prefix) -> void 

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
GDExtensionInterfaceClassdbRegisterExtensionClassSignal :: #type proc "c" (GDExtensionClassLibraryPtr p_library, GDExtensionConstStringNamePtr p_class_name, GDExtensionConstStringNamePtr p_signal_name, GDExtensionPropertyInfo *p_argument_info, GDExtensionInt p_argument_count) -> void 

/**
 * @name classdb_unregister_extension_class
 * @since 4.1
 *
 * Unregisters an extension class in the ClassDB.
 *
 * @param p_library A pointer the library received by the GDExtension's entry point function.
 * @param p_class_name A pointer to a StringName with the class name.
 */
GDExtensionInterfaceClassdbUnregisterExtensionClass :: #type proc "c" (GDExtensionClassLibraryPtr p_library, GDExtensionConstStringNamePtr p_class_name) -> void  /* Unregistering a parent class before a class that inherits it will result in failure. Inheritors must be unregistered first. */

/**
 * @name get_library_path
 * @since 4.1
 *
 * Gets the path to the current GDExtension library.
 *
 * @param p_library A pointer the library received by the GDExtension's entry point function.
 * @param r_path A pointer to a String which will receive the path.
 */
GDExtensionInterfaceGetLibraryPath :: #type proc "c" (GDExtensionClassLibraryPtr p_library, GDExtensionUninitializedStringPtr r_path) -> void 

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
GDExtensionInterfaceEditorAddPlugin :: #type proc "c" (GDExtensionConstStringNamePtr p_class_name) -> void 

/**
 * @name editor_remove_plugin
 * @since 4.1
 *
 * Removes an editor plugin.
 *
 * @param p_class_name A pointer to a StringName with the name of a class that was previously added as an editor plugin.
 */
GDExtensionInterfaceEditorRemovePlugin :: #type proc "c" (GDExtensionConstStringNamePtr p_class_name) -> void 
