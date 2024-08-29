package bindgen

import "core:os"
import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"
import "core:unicode"
import "core:path/filepath"
import "core:encoding/json"
import gde "../gdextension"

Globals :: struct {
	builtin_classes : [dynamic]string,
	engine_classes : map[string]bool, // Key is class name, value is boolean where True means the class is refcounted.
	native_structures : [dynamic]string, // Type names of native structures
	singletons : [dynamic]string,
	pck : string,
}

generate_global_constants :: proc(root: json.Object, target_dir: string, g: ^Globals) {
  file := filepath.join([]string{target_dir, "global_constants.odin"})
  mode: int = 0
  when os.OS == .Linux || os.OS == .Darwin {
    mode = os.S_IRUSR | os.S_IWUSR | os.S_IRGRP | os.S_IROTH
  }

  os.remove(file) // remove old file first
  fd, err := os.open(file, os.O_WRONLY|os.O_CREATE, mode)
  defer os.close(fd)
  if err == os.ERROR_NONE {
    os.write_string(fd, "package godot\n\n")
    os.write_string(fd, "import \"core:fmt\"\n")
    os.write_string(fd, "import \"core:strings\"\n")    

    // TODO real_t with different 32/64 size based on "build_configuration"
    os.write_string(fd, "real_t :: f32\n")
    
    for constant in root["global_constants"].(json.Array) {
    }

    for enum_def in root["global_enums"].(json.Array) {
      name := fmt.tprintf("%s", enum_def.(json.Object)["name"])

      if strings.has_prefix(name, "Variant.") {
        continue // skip these
      }

      os.write_string(fd, fmt.tprintf("%s :: enum {{\n", name))
      for value in enum_def.(json.Object)["values"].(json.Array) {
        k := value.(json.Object)["name"]
        v := value.(json.Object)["value"]
        os.write_string(fd, fmt.tprintf("\t%s = %.0f,\n", k, v))
      }
      os.write_string(fd, "}\n\n")
    }

    put_in_enums_and_consts :: proc(fd: os.Handle, class_api: json.Object, with_consts: bool, prevent_redeclaration: ^[dynamic]string, g: ^Globals) {
      class_name := fmt.tprintf("%s", class_api["name"])

      if "enums" in class_api {
        for enum_api in class_api["enums"].(json.Array) {
          name := fmt.tprintf("%s_%s", class_name, enum_api.(json.Object)["name"])
          os.write_string(fd, fmt.tprintf("%s :: enum {{\n", name))
          if "values" in enum_api.(json.Object) {
            for value in enum_api.(json.Object)["values"].(json.Array) {
              vname := fmt.tprintf("%s", value.(json.Object)["name"])
              val   := fmt.tprintf("%.0f", value.(json.Object)["value"])
              os.write_string(fd, fmt.tprintf("  %s = %s,\n", vname, val))
            }
          }
          os.write_string(fd, "}\n")
        }
      }
      if "constants" in class_api && with_consts {
        for value in class_api["constants"].(json.Array) {
          type := ""
          if !("type" in value.(json.Object)) {
            type = "int"
          } else {
            type = fmt.tprintf("%s", value.(json.Object)["type"])
          }
          vname := fmt.tprintf("%s", value.(json.Object)["name"])
          if slice.contains(prevent_redeclaration[:], vname) {
            continue
          }
          append(prevent_redeclaration, vname)
          vtype := fmt.tprintf("%s", value.(json.Object)["type"])
          val   := fmt.tprintf("%.0f", value.(json.Object)["value"])
          vtype = correct_type(vtype, "", g)
          if len(vtype) > 0 do vtype = fmt.tprintf(" %s ", vtype)
          os.write_string(fd, fmt.tprintf("%s :%s: %s\n", vname, correct_type(vtype, "", g), val))
        }
      }
    }

    prevent_redeclaration : [dynamic]string; defer delete(prevent_redeclaration)

    for builtin_class_api in root["builtin_classes"].(json.Array) {
      put_in_enums_and_consts(fd, builtin_class_api.(json.Object), false, &prevent_redeclaration, g)
    }
    for class_api in root["classes"].(json.Array) {
      put_in_enums_and_consts(fd, class_api.(json.Object), true, &prevent_redeclaration, g)
    }
    
    os.write_string(fd, `
Variant_Type :: enum {
  NIL,

  // atomic types
  BOOL,
  INT,
  FLOAT,
  STRING,
  
  // math types
  VECTOR2,
  VECTOR2I,
  RECT2,
  RECT2I,
  VECTOR3,
  VECTOR3I,
  TRANSFORM2D,
  VECTOR4,
  VECTOR4I,
  PLANE,
  QUATERNION,
  AABB,
  BASIS,
  TRANSFORM3D,
  PROJECTION,

  // misc types
  COLOR,
  STRING_NAME,
  NODE_PATH,
  RID,
  OBJECT,
  CALLABLE,
  SIGNAL,
  DICTIONARY,
  ARRAY,
  
  // typed arrays
  PACKED_BYTE_ARRAY,
  PACKED_INT32_ARRAY,
  PACKED_INT64_ARRAY,
  PACKED_FLOAT32_ARRAY,
  PACKED_FLOAT64_ARRAY,
  PACKED_STRING_ARRAY,
  PACKED_VECTOR2_ARRAY,
  PACKED_VECTOR3_ARRAY,
  PACKED_COLOR_ARRAY,
  
  VARIANT_MAX,
}

get_typestring_as_i32 :: proc(s: string, clean_up: bool = false) -> i32 {
  @static _types : map[string]Variant_Type
  if clean_up {
    delete(_types)
    return 0
  }

  if len(_types) == 0 {
    _types["nil"] = Variant_Type.NIL  // TODO auto-gen this
  // atomic types
    _types[ "bool"] = Variant_Type.BOOL
    _types[ "int"] = Variant_Type.INT
    _types[ "float"] = Variant_Type.FLOAT
    _types[ "string"] = Variant_Type.STRING
  
  // math types
    _types[ "vector2"] = Variant_Type.VECTOR2
    _types[ "vector2i"] = Variant_Type.VECTOR2I
    _types[ "rect2"] = Variant_Type.RECT2
    _types[ "rect2i"] = Variant_Type.RECT2I
    _types[ "vector3"] = Variant_Type.VECTOR3
    _types[ "vector3i"] = Variant_Type.VECTOR3I
    _types[ "transform2d"] = Variant_Type.TRANSFORM2D
    _types[ "vector4"] = Variant_Type.VECTOR4
    _types[ "vector4i"] = Variant_Type.VECTOR4I
    _types[ "plane"] = Variant_Type.PLANE
    _types[ "quaternion"] = Variant_Type.QUATERNION
    _types[ "aabb"] = Variant_Type.AABB
    _types[ "basis"] = Variant_Type.BASIS
    _types[ "transform3d"] = Variant_Type.TRANSFORM3D
    _types[ "projection"] = Variant_Type.PROJECTION

  // misc types
    _types[ "color"] = Variant_Type.COLOR
    _types[ "string_name"] = Variant_Type.STRING_NAME
    _types[ "node_path"] = Variant_Type.NODE_PATH
    _types[ "rid"] = Variant_Type.RID
    _types[ "object"] = Variant_Type.OBJECT
    _types[ "callable"] = Variant_Type.CALLABLE
    _types[ "signal"] = Variant_Type.SIGNAL
    _types[ "dictionary"] = Variant_Type.DICTIONARY
    _types[ "array"] = Variant_Type.ARRAY
  
  // typed arrays
    _types[ "packed_byte_array"] = Variant_Type.PACKED_BYTE_ARRAY
    _types[ "packed_int32_array"] = Variant_Type.PACKED_INT32_ARRAY
    _types[ "packed_int64_array"] = Variant_Type.PACKED_INT64_ARRAY
    _types[ "packed_float32_array"] = Variant_Type.PACKED_FLOAT32_ARRAY
    _types[ "packed_float64_array"] = Variant_Type.PACKED_FLOAT64_ARRAY
    _types[ "packed_string_array"] = Variant_Type.PACKED_STRING_ARRAY
    _types[ "packed_vector2_array"] = Variant_Type.PACKED_VECTOR2_ARRAY
    _types[ "packed_vector3_array"] = Variant_Type.PACKED_VECTOR3_ARRAY
    _types[ "packed_color_array"] = Variant_Type.PACKED_COLOR_ARRAY
  }

  str_tmp := strings.to_lower(s); defer delete(str_tmp)
  if str_tmp in _types {
    return cast(i32)_types[str_tmp]
  }
  return 0
}

get_type_as_i32 :: proc(t: typeid, clean_up: bool = false) -> i32 {
  @static _types : map[typeid]i32
  if clean_up {
    get_typestring_as_i32("", true)
    delete(_types)
    return 0
  }
  if t in _types {
    return _types[t]
  } else {
    _types[t] = get_typestring_as_i32(fmt.tprintf("%s", t))
    return _types[t]
  }
}

get_size_of_type :: proc(t: i32, clean_up: bool = false) -> i32 {
  #partial switch cast(Variant_Type)t {
    case .NIL: return 0
    case .BOOL: return 1
    case .INT: return 8
    case .FLOAT: return 8
    case .STRING: return String_SIZE
    case .VECTOR2: return Vector2_SIZE
    case .VECTOR2I: return Vector2i_SIZE
    case .RECT2: return Rect2_SIZE
    case .RECT2I: return Rect2i_SIZE
    case .VECTOR3: return Vector3_SIZE
    case .VECTOR3I: return Vector3i_SIZE
    case .TRANSFORM2D: return Transform2D_SIZE
    case .VECTOR4: return Vector4_SIZE
    case .VECTOR4I: return Vector4i_SIZE
    case .PLANE: return Plane_SIZE
    case .QUATERNION: return Quaternion_SIZE
    case .AABB: return AABB_SIZE
    case .BASIS: return Basis_SIZE
    case .TRANSFORM3D: return Transform3D_SIZE
    case .PROJECTION: return Projection_SIZE
    case .COLOR: return Color_SIZE
    case .STRING_NAME: return StringName_SIZE
    case .NODE_PATH: return NodePath_SIZE
    case .RID: return RID_SIZE
    case .OBJECT: return size_of(rawptr) // is this right?
    case .CALLABLE: return Callable_SIZE
    case .SIGNAL: return Signal_SIZE
    case .DICTIONARY: return Dictionary_SIZE
    case .ARRAY: return Array_SIZE
    case .PACKED_BYTE_ARRAY: return PackedByteArray_SIZE
    case .PACKED_INT32_ARRAY: return PackedInt32Array_SIZE
    case .PACKED_INT64_ARRAY: return PackedInt64Array_SIZE
    case .PACKED_FLOAT32_ARRAY: return PackedFloat32Array_SIZE
    case .PACKED_FLOAT64_ARRAY: return PackedFloat64Array_SIZE
    case .PACKED_STRING_ARRAY: return PackedStringArray_SIZE
    case .PACKED_VECTOR2_ARRAY: return PackedVector2Array_SIZE
    case .PACKED_VECTOR3_ARRAY: return PackedVector3Array_SIZE
    case .PACKED_COLOR_ARRAY: return PackedColorArray_SIZE
  }
  return 0
}

Operator :: enum {
  // comparison
  OP_EQUAL,
  OP_NOT_EQUAL,
  OP_LESS,
  OP_LESS_EQUAL,
  OP_GREATER,
  OP_GREATER_EQUAL,
  // mathematic
  OP_ADD,
  OP_SUBTRACT,
  OP_MULTIPLY,
  OP_DIVIDE,
  OP_NEGATE,
  OP_POSITIVE,
  OP_MODULE,
  // bitwise
  OP_SHIFT_LEFT,
  OP_SHIFT_RIGHT,
  OP_BIT_AND,
  OP_BIT_OR,
  OP_BIT_XOR,
  OP_BIT_NEGATE,
  // logic
  OP_AND,
  OP_OR,
  OP_XOR,
  OP_NOT,
  // containment
  OP_IN,
  OP_MAX,
  // other
  OP_IS_NOT,
}
`)
  }
}

camel_to_snake :: proc(name: string) -> string {
  if name == "AABB" do return "aabb"
  if name == "RID" do return "rid"
  if name == "AESContext" do return "aes_context"

  one_letter := false
  result := ""

  r := rune(name[0])
  prev_letter := r
  if unicode.is_letter(r) do one_letter = true
  result = fmt.tprintf("%s%c", result, unicode.to_lower(rune(name[0])))
  
  for i in 1..<len(name) {
    r = rune(name[i])
    next_letter := rune('_')
    if i+1 < len(name) do next_letter = rune(name[i+1])
    if unicode.is_upper(r) {
      if one_letter && (unicode.is_lower(prev_letter) || unicode.is_lower(next_letter)) {
result = fmt.tprintf("%s%c%c", result, '_', unicode.to_lower(r))
      } else {
        result = fmt.tprintf("%s%c", result, unicode.to_lower(r))
      }
    } else {
      result = fmt.tprintf("%s%c", result, r)
    }
    if unicode.is_letter(r) do one_letter = true
    prev_letter = r
  }
  if strings.contains(result, "1_d") {
    result, _ = strings.replace_all(result, "1_d", "1d")
  }
  if strings.contains(result, "2_d") {
    result, _ = strings.replace_all(result, "2_d", "2d")
  }
  if strings.contains(result, "3_d") {
    result, _ = strings.replace_all(result, "3_d", "3d")
  }
  
  return result
}

is_pod_type :: proc(type_name: string) -> bool {
  // These are types for which no class should be generated.
  @static pod_types := []string{"Nil"    ,        "void"    ,        "bool"    ,        "real_t" ,
                                "float"  ,        "double"  ,        "int"     ,        "int8_t" ,
                                "uint8_t",        "int16_t" ,        "uint16_t",        "int32_t",
                                "int64_t",        "uint32_t",        "uint64_t",
                                "u8", "i8", "u16", "i16", "u32", "i32", "u64", "i64", "f32", "f64",
                               }
  for i in pod_types {
    if i == type_name do return true
  }
  return false
}

is_included_struct_type :: proc(type_name: string) -> bool {
  // Struct types which we already have implemented.
  //@static included_struct_types := []string{"AABB","Basis","Color","Plane","Projection",
  //                                          "Quaternion","Rect2","Rect2i","Transform2D",
  //                                          "Transform3D","Vector2","Vector2i","Vector3",
  //                                          "Vector3i","Vector4","Vector4i"}
  @static included_struct_types := []string{}
  for i in included_struct_types {
    if i == type_name do return true
  }
  return false
}

is_included_type :: proc(type_name: string) -> bool {
  // Types which are already implemented.
  return is_included_struct_type(type_name) || type_name == "ObjectID"
}

is_bitfield :: proc(type_name: string) -> bool {
  return strings.has_prefix(type_name, "bitfield::")
}

get_enum_class :: proc(enum_name: string) -> string {
  if strings.contains(enum_name, ".") {
    if is_bitfield(enum_name) {
      str, _ := strings.replace_all(enum_name, "bitfield::", "")
      return strings.split(str, ".")[0]
    } else {
      str, _ := strings.replace_all(enum_name, "enum::", "")      
      return strings.split(str, ".")[0]
    }
  }
  return ""
}

is_enum :: proc(type_name: string) -> bool {
  return strings.has_prefix(type_name, "enum::") || strings.has_prefix(type_name, "bitfield::")
}

is_engine_class :: proc(type_name: string, g: ^Globals) -> bool {
  spl := strings.split(type_name, ".")
  tn := spl[len(spl)-1]
  return tn == "Object" || tn in g.engine_classes
}

is_variant :: proc(type_name: string, g: ^Globals) -> bool {
  return ( type_name == "Variant" ||
	  slice.contains(g.builtin_classes[:], type_name) ||
	  type_name == "Nil" ||
	  strings.has_prefix(type_name, "typedarray::"))
}

is_included :: proc(type_name: string, current_type: string, g: ^Globals) -> bool {
  // Check if a builtin type should be included.
  // This removes Variant and POD types from inclusion, and the current type.

  if strings.has_prefix(type_name, "typedarray::") do return true
  to_include := get_enum_class(type_name) if is_enum(type_name) else type_name
  if to_include == current_type || is_pod_type(to_include) do return false
  if to_include == "UtilityFunctions" do return true
  return is_engine_class(to_include, g) || is_variant(to_include, g)
}

get_operator_id_name :: proc(op: string) -> string {
  @static op_id_map : map[string]string
  if len(op_id_map) == 0 {    
    op_id_map["=="] = "equal"
    op_id_map["!="] = "not_equal"
    op_id_map["<"] = "less"
    op_id_map["<="] = "less_equal"
    op_id_map[">"] = "greater"
    op_id_map[">="] = "greater_equal"
    op_id_map["+"] = "add"
    op_id_map["-"] = "subtract"
    op_id_map["*"] = "multiply"
    op_id_map["/"] = "divide"
    op_id_map["unary-"] = "negate"
    op_id_map["unary+"] = "positive"
    op_id_map["%"] = "module"
    op_id_map["<<"] = "shift_left"
    op_id_map[">>"] = "shift_right"
    op_id_map["&"] = "bit_and"
    op_id_map["|"] = "bit_or"
    op_id_map["^"] = "bit_xor"
    op_id_map["~"] = "bit_negate"
    op_id_map["and"] = "and"
    op_id_map["or"] = "or"
    op_id_map["xor"] = "xor"
    op_id_map["not"] = "not"
    op_id_map["and"] = "and"
    op_id_map["in"] = "in"
  }
  return op_id_map[op]
}

get_enum_name :: proc(enum_name: string) -> string {
  str := ""
  if is_bitfield(enum_name) {
    str, _ = strings.replace_all(enum_name, "bitfield::", "")
  } else {
    str, _ = strings.replace_all(enum_name, "enum::", "")
  }
  tmp := strings.split(str, ".")
  return tmp[len(tmp)-1]
}

is_refcounted :: proc(type_name: string, g: ^Globals) -> bool {
  return type_name in g.engine_classes && g.engine_classes[type_name]
}

correct_type :: proc(type_name: string, meta: string, g: ^Globals) -> string {
  type_conversion : map[string]string
  type_conversion["float"] = "f32"
  type_conversion["double"] = "f64"
  type_conversion["nil"] = ""
  type_conversion["int"] = "int"
  type_conversion["uint"] = "uint"
  type_conversion["int8"] = "i8"
  type_conversion["uint8"] = "u8"
  type_conversion["int16"] = "i16"
  type_conversion["uint16"] = "u16"
  type_conversion["int32"] = "i32"
  type_conversion["uint32"] = "u32"
  type_conversion["int64"] = "i64"
  type_conversion["uint64"] = "u64"
  type_conversion["bool"] = "bool"
  type_conversion["u8"] = "u8"
  type_conversion["i8"] = "i8"
  type_conversion["u16"] = "u16"
  type_conversion["i16"] = "i16"
  type_conversion["u32"] = "u32"
  type_conversion["i32"] = "i32"
  type_conversion["u64"] = "u64"
  type_conversion["i64"] = "i64"
  type_conversion["f32"] = "f32"
  type_conversion["f64"] = "f64"

  type_conversion["int8_t"] = "i8"
  type_conversion["uint8_t"] = "u8"
  type_conversion["int16_t"] = "i16"
  type_conversion["uint16_t"] = "u16"
  type_conversion["int32_t"] = "i32"
  type_conversion["uint32_t"] = "u32"
  type_conversion["int64_t"] = "i64"
  type_conversion["uint64_t"] = "u64"
  
  if meta != "" {
    if meta in type_conversion {
      return type_conversion[type_name]
    } else {
      return meta
    }
  }
  tn := type_name
  if strings.has_prefix(tn, "const ") {
    tn = tn[6:]
  }
  if strings.has_suffix(tn, "*") {
    tn = tn[:len(tn)-1]
  }
  if strings.has_suffix(tn, " *") {
    tn = tn[:len(tn)-2]
  }
  if strings.has_suffix(tn, " **") {
    tn = tn[:len(tn)-3]
  }

  if tn in type_conversion {
    return type_conversion[tn]
  }

  if strings.has_prefix(type_name, "typedarray::") {
    str, _ := strings.replace_all(type_name, "typedarray::", "") // TODO?
    return fmt.tprintf("[]%s%s", g.pck, str)
  }

  if is_enum(type_name) {
    base_class := get_enum_class(type_name)   
    if is_bitfield(type_name) {
      return fmt.tprintf("u64") //bit_set[%s%s_%s]", g.pck, base_class, get_enum_name(type_name))
    } else {
      if base_class != "" {
        return fmt.tprintf("%s%s_%s", g.pck, base_class, get_enum_name(type_name))
      } else {
        return fmt.tprintf("%s%s", g.pck, get_enum_name(type_name))
      }
    }
  }

  //if is_refcounted(type_name, g) {
  //  return fmt.tprintf("%sRef< %s >", g.pck, type_name)
  //}  // TODO

  if type_name == "Object" || is_engine_class(type_name, g) {
    return fmt.tprintf("%s%s", g.pck, type_name)
  }

  if strings.has_suffix(type_name, "*") {
    return fmt.tprintf("^%s%s", g.pck, type_name[:len(type_name)-1])
  }

  return fmt.tprintf("%s%s", g.pck, type_name)
}
  
type_for_parameter :: proc(type_name: string, meta: string, g: ^Globals) -> string {
  if strings.contains(type_name, "void") {
    return "rawptr" // all "void*" and "const void*" are assumed to be rawptrs
  } else if is_pod_type(type_name) && type_name != "Nil" || is_enum(type_name) {
    return correct_type(type_name, meta, g)
  } else if is_variant(type_name, g) || is_refcounted(type_name, g) || type_name == "Object" {
    return fmt.tprintf("%s", correct_type(type_name, "", g))
  } else {
    return correct_type(type_name, "", g)
  }
}

escape_identifier :: proc(id: string) -> string {
  @static odin_keywords_map: map[string]string
  if len(odin_keywords_map) == 0 {
    odin_keywords_map["class"] = "_class"
    odin_keywords_map["char"] = "_char"
    odin_keywords_map["short"] = "_short"
    odin_keywords_map["bool"] = "_bool"
    odin_keywords_map["int"] = "_int"
    odin_keywords_map["default"] = "_default"
    odin_keywords_map["case"] = "_case"
    odin_keywords_map["switch"] = "_switch"
    odin_keywords_map["export"] = "_export"
    odin_keywords_map["template"] = "_template"
    odin_keywords_map["new"] = "new_"
    odin_keywords_map["operator"] = "_operator"
    odin_keywords_map["typeof"] = "type_of"
    odin_keywords_map["typename"] = "type_name"
    odin_keywords_map["context"] = "_context"
    odin_keywords_map["in"] = "_in"
    odin_keywords_map["map"] = "_map"
  }
  if id in odin_keywords_map {
    return odin_keywords_map[id]
  }
  return id
}

correct_default_value :: proc(value: string, type_name: string, g: ^Globals) -> string {
	return "{}"
  // @static value_map : map[string]string
  // fmt.printf("get default value for type: {}\n", type_name)
  // if len(value_map) == 0 {
  //   value_map["null"] = "{}"// 
  //   // value_map["null"] = "nil"
  //   //value_map["\"\""] = fmt.tprintf("%sString()", g.pck)
  //   //value_map["&\"\""] = fmt.tprintf("%sStringName()", g.pck)
  //   //value_map["[]"] = fmt.tprintf("%sArray()", g.pck)
  //   //value_map["{}"] = fmt.tprintf("%sDictionary()", g.pck)
  // }
  // _, ok := strconv.parse_int(value)
  // if ok do return value
  // if type_name == "bool" do return value

  // is_real := (type_name == "float")
  // if !is_real do return "nil"
  // 
  // if value in value_map do return value_map[value]
  // if value == "" do return fmt.tprintf("%s()", type_name)
  // 
  // if strings.has_prefix(value, "Array[") do return "{}"
  // return value
}

make_function_parameters :: proc(parameters: json.Array, g: ^Globals, include_default: bool=false, for_builtin: bool=false, is_vararg: bool=false) -> string {
  signature : [dynamic]string

  index := 0
  for par in parameters {
    type := fmt.tprintf("%s", par.(json.Object)["type"])
    meta := fmt.tprintf("%s", par.(json.Object)["meta"])
    name := fmt.tprintf("%s", par.(json.Object)["name"])    
    parameter := type_for_parameter(type, "meta" in par.(json.Object) ? meta : "", g)
    //snake_parameter := camel_to_snake(parameter)
    parameter_name := escape_identifier(name)

    if len(parameter_name) == 0 {
      parameter_name = fmt.tprintf("arg_%d", index+1)
    }
    parameter = fmt.tprintf("%s: %s", parameter_name, parameter)

    if include_default && "default_value" in par.(json.Object) && (!for_builtin || type != "Variant") {
      parameter = fmt.tprintf("%s = ", parameter)
      if is_enum(type) {
        parameter_type := correct_type(type, "", g)
        parameter = fmt.tprintf("%s%s", parameter, parameter_type)
      }
      default_value := fmt.tprintf("%s", par.(json.Object)["default_value"])
      parameter = fmt.tprintf("%s%s", parameter, correct_default_value(default_value, type, g))
    }

    append(&signature, parameter)

    if is_vararg {
      //append(&signature, "args: ..any") // TODO
    }
    
    index += 1
  }
  return strings.join(signature[:], ", ")
}

get_ptr_to_arg :: proc() -> (pta: map[string][2]string) {
  // for casting to needed type to interface with Variant_Types
  pta["int"]  = {"INT", "i64"} // an odin type = { GD..Variant_Type, some type to cast to (for interface reasons) }
  pta["uint"] = {"INT", "i64"}
  pta["bool"] = {"BOOL", "u8"} // most of these are from method_ptrcall.hpp in godot-cpp src, but with odin types
  pta["u8"]   = {"INT", "i64"}
  pta["i8"]   = {"INT", "i64"}
  pta["u16"]  = {"INT", "i64"}
  pta["i16"]  = {"INT", "i64"}
  pta["u32"]  = {"INT", "i64"}
  pta["i32"]  = {"INT", "i64"}
  pta["i64"]  = {"INT", "i64"}
  pta["u64"]  = {"INT", "i64"}
  pta["f32"]  = {"FLOAT", "f64"}
  pta["f64"]  = {"FLOAT", "f64"} // TODO: is this all int, bool and float types?

  pta["godot.String"]  = {"STRING", "String"}
  pta["godot.StringName"]  = {"STRING_NAME", "StringName"}
  
  pta["godot.Vector2"] = {"VECTOR2", "Vector2"}
  pta["godot.Vector2i"]  = {"VECTOR2I", "Vector2i"}
  pta["godot.Rect2"] = {"RECT2", "Rect2"}
  pta["godot.Rect2i"]  = {"RECT2I", "Rect2i"}
  pta["godot.Vector3"] = {"VECTOR3", "Vector3"}
  pta["godot.Vector3i"]  = {"VECTOR3I", "Vector3i"}
  pta["godot.Transform2D"] = {"TRANSFORM2D", "Transform2D"}
  pta["godot.Vector4"] = {"VECTOR4", "Vector4"}
  pta["godot.Vector4i"]  = {"VECTOR4I", "Vector4i"}
  pta["godot.Plane"] = {"QUATERNION", "Plane"}
  pta["godot.Quaternion"]  = {"QUATERNION", "Quaternion"}
  pta["godot.AABB"]  = {"AABB", "AABB"}
  pta["godot.Basis"] = {"BASIS", "Basis"}
  pta["godot.Transform3D"] = {"TRANSFORM3D", "Transform3D"}  
  pta["godot.Projection"]  = {"PROJECTION", "Projection"}

  /* misc types */
  pta["godot.Color"] = {"COLOR", "Color"}
  pta["godot.StringName"]  = {"STRING_NAME", "SringName"}
  pta["godot.NodePath"]  = {"NODE_PATH", "NodePath"}
  pta["godot.RID"] = {"RID", "RID"}
  pta["godot.Object"]  = {"OBJECT", "Object"}
  pta["godot.Callable"]  = {"CALLABLE", "Callable"}
  pta["godot.Signal"]  = {"SIGNAL", "Signal"}
  pta["godot.Dictionary"]  = {"DICTIONARY", "Dictionary"}
  pta["godot.Array"] = {"ARRAY", "Array"}  

  /* typed arrays */
  pta["godot.PackedByteArray"] = {"PACKED_BYTE_ARRAY", "PackedByteArray"}    
  pta["godot.PackedInt32Array"]  = {"PACKED_INT32_ARRAY", "PackedInt32Array"}
  pta["godot.PackedInt64Array"]  = {"PACKED_INT64_ARRAY", "PackedInt64Array"}
  pta["godot.PackedFloat32Array"]  = {"PACKED_FLOAT32_ARRAY", "PackedFloat32Array"}
  pta["godot.PackedFloat64Array"]  = {"PACKED_FLOAT64_ARRAY", "PackedFloat64Array"}
  pta["godot.PackedStringArray"] = {"PACKED_STRING_ARRAY", "PackedStringArray"}
  pta["godot.PackedVector2Array"]  = {"PACKED_VECTOR2_ARRAY", "PackedVector2Array"}
  pta["godot.PackedVector3Array"]  = {"PACKED_VECTOR3_ARRAY", "PackedVector3Array"}
  pta["godot.PackedColorArray"]  = {"PACKED_COLOR_ARRAY", "PackedColorArray"}
  
  return
}

generate_variant_class :: proc(target_dir: string, g: ^Globals) {
  class_name := "Variant"
  snake_class_name := camel_to_snake(class_name)  
  dir := fmt.tprintf("%s/%s", target_dir, snake_class_name)
  class_file := fmt.tprintf("%s/%s%s", dir, snake_class_name, ".odin")  

  os.make_directory(dir)
  mode: int = 0
  when os.OS == .Linux || os.OS == .Darwin {
    mode = os.S_IRUSR | os.S_IWUSR | os.S_IRGRP | os.S_IROTH
  }
  os.remove(class_file)

  fd, err := os.open(class_file, os.O_WRONLY|os.O_CREATE, mode)
  defer os.close(fd)
  if err == os.ERROR_NONE {
    os.write_string(fd, fmt.tprintf("package %s\n\n", snake_class_name))
    os.write_string(fd, "import \"core:fmt\"\n")    
    os.write_string(fd, "import \"core:strings\"\n")
    os.write_string(fd, "import godot \"../\"\n")
    os.write_string(fd, "import gde \"../../gdextension\"\n\n")

    os.write_string(fd, `
from_type_constructor :: proc(type: godot.Variant_Type) -> gde.GDExtensionVariantFromTypeConstructorFunc {
  @static from_type : [godot.Variant_Type.VARIANT_MAX]gde.GDExtensionVariantFromTypeConstructorFunc
  type := cast(int)type
  if from_type[1] == nil { // start from 1 to skip NIL
    for i := 1; i < cast(int)godot.Variant_Type.VARIANT_MAX; i+=1 {
      from_type[i] = gde.get_variant_from_type_constructor(cast(gde.GDExtensionVariantType)i)
    }
  }
  return from_type[type]
}
to_type_constructor :: proc(type: godot.Variant_Type) -> gde.GDExtensionTypeFromVariantConstructorFunc {
  @static to_type : [godot.Variant_Type.VARIANT_MAX]gde.GDExtensionTypeFromVariantConstructorFunc
  type :int= cast(int)type
  if to_type[1] == nil { // start from 1 to skip NIL
    for i := 1; i < cast(int)godot.Variant_Type.VARIANT_MAX; i+=1 {
      to_type[i] = gde.get_variant_to_type_constructor(cast(gde.GDExtensionVariantType)i)
    }
  }
  return to_type[type]
}
copy :: proc(from: godot.Variant) -> godot.Variant {
  from := from
  to : godot.Variant
  gde.variant_new_copy(cast(gde.GDExtensionVariantPtr)&to, cast(gde.GDExtensionConstVariantPtr)&from)
  return to
}
new_nil :: proc() -> godot.Variant {
  me : godot.Variant
  gde.variant_new_nil(cast(gde.GDExtensionVariantPtr)&me)
  return me
}
destroy :: proc(me: ^godot.Variant) {
  gde.variant_destroy(cast(gde.GDExtensionVariantPtr)me)
}
`)

    // ptr to arg stuff ------------------------------
    ptr_to_arg := get_ptr_to_arg()

    idx := 0
	for k, v in ptr_to_arg {
		os.write_string(fd, fmt.tprintf(`
constructor%d :: proc(val: %s) -> godot.Variant {{
	@static _constructor : gde.GDExtensionVariantFromTypeConstructorFunc
	if _constructor == nil do _constructor = gde.get_variant_from_type_constructor(.GDEXTENSION_VARIANT_TYPE_%s)
	lval := cast(%s)val
	me: godot.Variant
	_constructor(cast(gde.GDExtensionVariantPtr)&me, cast(gde.GDExtensionTypePtr)&lval)
	return me
}}`, idx, k, v[0], k))
        os.write_string(fd, fmt.tprintf(`
to_%s :: proc(me: ^godot.Variant) -> %s {{
	@static _to_type : gde.GDExtensionTypeFromVariantConstructorFunc
	if _to_type == nil do _to_type = gde.get_variant_to_type_constructor(.GDEXTENSION_VARIANT_TYPE_%s)
	to : %s
	_to_type(cast(gde.GDExtensionTypePtr)&to, cast(gde.GDExtensionVariantPtr)me)
	return to
}}
`, strings.trim_left(k, "godot."), k, v[0], k))
		idx += 1
	}

    // special string constructor ------------------------------
    os.write_string(fd, fmt.tprintf(`
constructor_string :: proc(str: string) -> godot.Variant {{
	gstr : godot.String
	str := strings.clone_to_cstring(str); defer delete(str)
	gde.string_new_with_latin1_chars(cast(gde.GDExtensionStringPtr)&gstr, str)
	@static _constructor : gde.GDExtensionVariantFromTypeConstructorFunc
	if _constructor == nil do _constructor = gde.get_variant_from_type_constructor(.GDEXTENSION_VARIANT_TYPE_STRING)
	me : godot.Variant
	_constructor(cast(gde.GDExtensionVariantPtr)&me, cast(gde.GDExtensionTypePtr)&gstr)
	return me
}}
to_string :: proc(me: ^godot.Variant, allocator:=context.allocator) -> string {{
	context.allocator = allocator
	s := to_String(me)
	length := gde.string_to_utf8_chars(cast(gde.GDExtensionConstStringPtr)&s, nil, 0)
	cstr := make([]u8, length)
	gde.string_to_utf8_chars(cast(gde.GDExtensionConstStringPtr)&s, cast(cstring)raw_data(cstr), length)
	return transmute(string)cstr
}}
`))
    // ------------------------------
    
    os.write_string(fd, "constructor :: proc{")
    idx = 0
    for _, _ in ptr_to_arg {
      os.write_string(fd, fmt.tprintf("constructor%d%s", idx, ", "))
      idx += 1
    }
    os.write_string(fd, fmt.tprintf("constructor_string"))
    os.write_string(fd, "}\n")
    // os.write_string(fd, "to_type :: proc{")
    // idx = 0
    // for _, _ in ptr_to_arg {
    //   os.write_string(fd, fmt.tprintf("to_type%d%s", idx, idx!=len(ptr_to_arg)-1 ? ", " : ""))
    //   idx += 1
    // }
    // os.write_string(fd, "}\n")

    // special converting  any <-> Variant  stuff ---
    os.write_string(fd, "\n\n")
    os.write_string(fd, "convert_variant :: proc(v: ^godot.Variant, allocator:=context.allocator) -> any {\n")
    os.write_string(fd, "  vtype := gde.variant_get_type(cast(gde.GDExtensionConstVariantPtr)v)\n")
    os.write_string(fd, "  if vtype == gde.GDExtensionVariantType.GDEXTENSION_VARIANT_TYPE_STRING {\n")
    os.write_string(fd, "    return to_string(v, allocator)\n")
    os.write_string(fd, "  }\n")
    vtoa : map[string]string
    for k, v in ptr_to_arg { // reverse map look up
      if !(v[0] in vtoa) {
        vtoa[v[0]] = k
      }
    }
    for k, v in vtoa {
		if k == "STRING" do continue
		os.write_string(fd, fmt.tprintf("  if vtype == gde.GDExtensionVariantType.GDEXTENSION_VARIANT_TYPE_%s {{\n", k))
		os.write_string(fd, fmt.tprintf("    return to_%s(v)\n", strings.trim_left(v, "godot.")))
		os.write_string(fd, fmt.tprintf("  }}\n"))
    }
    os.write_string(fd, "  return nil\n")
    os.write_string(fd, "}\n")
    
    os.write_string(fd, "convert_any :: proc(a: any) -> godot.Variant {\n")
    os.write_string(fd, "  if a.id == string {\n")
    os.write_string(fd, "    return constructor(a.(string))\n")
    os.write_string(fd, "  }\n")
	idx = 0
    for k, _ in ptr_to_arg {
      os.write_string(fd, fmt.tprintf("  if a.id == %s {{\n", k))
      os.write_string(fd, fmt.tprintf("    return constructor%d(a.(%s))\n", idx, k))
      os.write_string(fd, fmt.tprintf("  }}\n"))
	  idx += 1
    }
    os.write_string(fd, "  return new_nil()\n")   
    os.write_string(fd, "}\n")
    // ------------------------------
    
  }
}

correct_operator :: proc(op: string) -> string {
  switch op {
    // comparison
  case "==":
    return "OP_EQUAL"
  case "!=":
    return "OP_NOT_EQUAL"
  case "<":
    return "OP_LESS"
  case "<=":
    return "OP_LESS_EQUAL"
  case ">":
    return "OP_GREATER"
  case ">=":
    return "OP_GREATER_EQUAL"
  // mathematic
  case "+":
    return "OP_ADD"
  case "-":
    return "OP_SUBTRACT"
  case "*":
    return "OP_MULTIPLY"
  case "/":
    return "OP_DIVIDE"
  case "unary-":
    return "OP_NEGATE"
  case "unary+":
    return "OP_POSITIVE"
  case "%":
    return "OP_MODULE"
  // bitwise
  case "<<":
    return "OP_SHIFT_LEFT"
  case ">>":
    return "OP_SHIFT_RIGHT"
  case "&":
    return "OP_BIT_AND"
  case "|":
    return "OP_BIT_OR"
  case "^":
    return "OP_BIT_XOR"
  case "~":
    return "OP_BIT_NEGATE"
  // logic
  case "&&":
    return "OP_AND"
  case "||":
    return "OP_OR"
  case "xor":
    return "OP_XOR"
  case "not":
    return "OP_NOT"
  case "!":
    return "OP_NOT"
  // containment
  case "in":
    return "OP_IN"
  } 
  fmt.printf("Unhandled OPERATOR %s\n", op)
  return ""
}

generate_builtin_classes :: proc(builtin_api: json.Object, target_dir: string, size: int, used_classes: ^[dynamic]string, fully_used_classes: ^[dynamic]string, sfd: os.Handle, g: ^Globals) {
  // generate_variant_class(target_dir, g)
  
  class_name := fmt.tprintf("%s", builtin_api["name"])
  snake_class_name := camel_to_snake(class_name)
  dir := fmt.tprintf("%s/%s", target_dir, snake_class_name)
  class_file := fmt.tprintf("%s/%s%s", dir, snake_class_name, ".odin")

  // instead of making an odin struct "fit" what a class should be
  // make a package of snake_class_name that contains NO member variables/data struct(class_name) but
  // does contain all member functions(as procs), constructors, destructor, operators, etc.. of the class
  // note1: packages are directory based, so all class procs will be packages/sub-directories of godot
  // note2: and all (:: structs) will be in "godot" package (structures.odin)
  os.make_directory(dir)
  
  mode: int = 0
  when os.OS == .Linux || os.OS == .Darwin {
    mode = os.S_IRUSR | os.S_IWUSR | os.S_IRGRP | os.S_IROTH
  }

  os.remove(class_file)

  fd, err := os.open(class_file, os.O_WRONLY|os.O_CREATE, mode)
  
  defer os.close(fd)
  if err == os.ERROR_NONE {
    os.write_string(fd, fmt.tprintf("package godot\n\n"))
    os.write_string(fd, "// builtin\n")
    os.write_string(fd, "import gde \"../gdextension\"\n\n")

    // Special cases.
    if class_name == "String" || class_name == "StringName" {
      os.write_string(fd, "import \"core:strings\"\n")
      os.write_string(fd, "import \"../variant\"\n")
      
      if class_name == "String" {
        os.write_string(fd, `// helper function
_to_string :: proc(sn: ^godot.String, s: string) {
	tmp := strings.clone_to_cstring(s); defer delete(tmp)
	gde.string_new_with_utf8_chars(auto_cast sn, tmp)

	clean_string_names(sn)
}
// _to_string_name :: proc(sn: ^godot.StringName, s: string) {
//   str : godot.String
//   tmp := strings.clone_to_cstring(s); defer delete(tmp)
//   gde.string_new_with_utf8_chars(cast(gde.GDExtensionStringPtr)&str, tmp)
//   p : gde.GDExtensionPtrConstructor
//   call_args : [1]rawptr
//   call_args[0] = &str
//   p = gde.variant_get_ptr_constructor(gde.GDExtensionVariantType.GDEXTENSION_VARIANT_TYPE_STRING_NAME, 2)
//   p(cast(gde.GDExtensionTypePtr)&sn, cast(^gde.GDExtensionConstTypePtr)&call_args[0])
// 
//   clean_string_names(sn)
// }
clean_string_names :: proc(ptr: rawptr = nil) {
  @static names : [dynamic]rawptr
  if ptr == nil {
    for p in names {
      free(p)
    }
    delete(names)
    return
  }
  append(&names, ptr)
}
`)
      }
    }
    if class_name != "String" {
      os.write_string(fd, "import gstring \"../string\"\n") // for _to_string_name
    }

    if class_name == "Vector2" || class_name == "Vector3" || class_name == "Vector4" {
      os.write_string(fd, "import \"core:math\"\n")
    }

    if class_name == "PackedStringArray" {
      os.write_string(fd, "import \"core:strings\"\n")
    }
    if class_name == "PackedColorArray" {
      os.write_string(fd, "import \"core:strings\"\n") // TODO color.hpp
    } // TODO ...

    if class_name == "Array" {
      os.write_string(fd, "import \"core:container/small_array\"\n")
    }

    if class_name == "Dictionary" {
      os.write_string(fd, "import \"../variant\"\n")
    }

    for include in fully_used_classes {
      if include == "TypedArray" {
        os.write_string(fd, "import \"core:fmt\"\n")
      } else {
        os.write_string(fd, "import \"core:fmt\"\n")
      }
    }
    if len(fully_used_classes) > 0 do os.write_string(fd, "\n")

    os.write_string(sfd, fmt.tprintf("%s_SIZE :: %d\n", class_name, size))
    if "members" in builtin_api {
		os.write_string(sfd, fmt.tprintf("%s :: struct {{ // size: %d\n", class_name, size))
		// os.write_string(sfd, fmt.tprintf("  opaque : [%d]u8,\n", size))
		for member in builtin_api["members"].(json.Array) {
			name := fmt.tprintf("%s", member.(json.Object)["name"])
			type := fmt.tprintf("%s", member.(json.Object)["type"])
			os.write_string(sfd, fmt.tprintf("  %s : %s,\n", name, correct_type(type, "", g)))
		}
		os.write_string(sfd, "}\n")
    } else {
		os.write_string(sfd, fmt.tprintf("%s :: distinct [%s_SIZE]u8\n", class_name, class_name))
	}

	// -- old version
    // Create struct in builtin_structures.odin
    // os.write_string(sfd, fmt.tprintf("%s_SIZE :: %d\n", class_name, size))
    // os.write_string(sfd, fmt.tprintf("%s :: distinct [%d]u8\n", class_name, size))
    // os.write_string(sfd, fmt.tprintf("%s :: struct {{\n", class_name))

    // os.write_string(sfd, fmt.tprintf("  opaque : [%s_SIZE]u8,\n", class_name))
    // if "members" in builtin_api {
	// 	for member in builtin_api["members"].(json.Array) {
	// 		name := fmt.tprintf("%s", member.(json.Object)["name"])
	// 		type := fmt.tprintf("%s", member.(json.Object)["type"])

	// 		os.write_string(sfd, fmt.tprintf("  %s : %s,\n", name, correct_type(type, "", g)))
	// 	}
    // }
    // if "methods" in builtin_api {
    //   for method in builtin_api["methods"].(json.Array) {
    //     method_name := fmt.tprintf("%s", method.(json.Object)["name"])
    //     if method_name == "map" do method_name = "_map"

    //     method_signature := fmt.tprintf("proc(me: ^%s", correct_type(class_name, "", g))
    //     vararg := cast(bool) method.(json.Object)["is_vararg"].(json.Boolean)
    //     if "arguments" in method.(json.Object) {        
    //       method_signature = fmt.tprintf("%s, %s", method_signature,
    //                                      make_function_parameters(method.(json.Object)["arguments"].(json.Array), g, true, true, vararg))
    //     }
    //     method_signature = fmt.tprintf("%s)", method_signature)       
    //     if "is_static" in method.(json.Object) && method.(json.Object)["is_static"].(json.Boolean) {
    //       //method_signature = fmt.tprintf("%s", method_signature) // TODO??
    //     }
    //     if "return_type" in method.(json.Object) {
    //       return_type := fmt.tprintf("%s", method.(json.Object)["return_type"])
    //       pta := get_ptr_to_arg()
    //       crt := correct_type(return_type, "", g)
    //       ptr := "^"
    //       if crt in pta {
    //         ptr = ""
    //       }
    //       method_signature = fmt.tprintf("%s -> %s%s", method_signature, ptr, crt)
    //     }

    //     os.write_string(sfd, fmt.tprintf("  %s : %s,\n", method_name, method_signature))
    //   }
    // }
    // if "indexing_return_type" in builtin_api {
    //   type := fmt.tprintf("%s", builtin_api["indexing_return_type"])
    //   cname := correct_type(class_name, "", g)
    //   ctype := correct_type(type, "", g)
    //   if strings.contains(cname, "Int32") do ctype = "i32"
    //   if strings.contains(cname, "Int64") do ctype = "i64"
    //   if strings.contains(cname, "Float32") do ctype = "f32"
    //   if strings.contains(cname, "Float64") do ctype = "f64"
    //   os.write_string(sfd, fmt.tprintf("  set_idx : proc(me: ^%s, #any_int idx: int, v: ^%s),\n", cname, ctype))
    //   os.write_string(sfd, fmt.tprintf("  get_idx : proc(me: ^%s, #any_int idx: int) -> ^%s,\n", cname, ctype))
    // }
    // os.write_string(sfd, "}\n\n")

    os.write_string(fd, "// Constants ------------------------------\n")
    // ------------------------------

    g.pck = "godot."
    
    if "constants" in builtin_api {
      for constant in builtin_api["constants"].(json.Array) {
        name := fmt.tprintf("%s", constant.(json.Object)["name"])
        type := fmt.tprintf("%s", constant.(json.Object)["type"])
        valu := fmt.tprintf("%s", constant.(json.Object)["value"])

        { // any named field can be set and everything else will be zero
          if strings.has_prefix(valu, "Vector2") { // opaque and 2 floats
            valu, _ = strings.replace_all(valu, "(", "{")
            valu, _ = strings.replace_all(valu, ")", "}")
            idx := strings.index(valu, "{")
            spl := strings.split(valu[idx+1:], ",")
            valu = fmt.tprintf("%s%s x=%s, y=%s", g.pck, valu[0:idx+1], spl[0], spl[1])
            valu, _ = strings.replace_all(valu, "inf", "math.inf_f32(1)")
          }

          if strings.has_prefix(valu, "Vector3") { // opaque and 3 floats
            valu, _ = strings.replace_all(valu, "(", "{")
            valu, _ = strings.replace_all(valu, ")", "}")
            idx := strings.index(valu, "{")
            spl := strings.split(valu[idx+1:], ",")
            valu = fmt.tprintf("%s%s x=%s, y=%s, z=%s", g.pck, valu[0:idx+1], spl[0], spl[1], spl[2])
            valu, _ = strings.replace_all(valu, "inf", "math.inf_f32(1)")
          }
          
          if strings.has_prefix(valu, "Vector4") || strings.has_prefix(valu, "Quaternion") { // opaque and 4 floats
            valu, _ = strings.replace_all(valu, "(", "{")
            valu, _ = strings.replace_all(valu, ")", "}")
            idx := strings.index(valu, "{")
            spl := strings.split(valu[idx+1:], ",")
            valu = fmt.tprintf("%s%s x=%s, y=%s, z=%s, w=%s", g.pck, valu[0:idx+1], spl[0], spl[1], spl[2], spl[3])
            valu, _ = strings.replace_all(valu, "inf", "math.inf_f32(1)")
          }

          if strings.has_prefix(valu, "Color") { // opaque, 4 floats(rgba), 4 ints(rgba_int), 3 float(hsv)
            valu, _ = strings.replace_all(valu, "(", "{")
            valu, _ = strings.replace_all(valu, ")", "}")
            idx := strings.index(valu, "{")
            spl := strings.split(valu[idx+1:], ",")
            spl[3], _ = strings.replace_all(spl[3], "}", "")
            valu = fmt.tprintf("%s%s r=%s, g=%s, b=%s, a=%s}", g.pck, valu[0:idx+1], spl[0], spl[1], spl[2], spl[3])
          }

          if strings.has_prefix(valu, "Transform2D") {  // opaque and 3 vector2's
            valu, _ = strings.replace_all(valu, "(", "{")
            valu, _ = strings.replace_all(valu, ")", "}")
            idx := strings.index(valu, "{")
            spl := strings.split(valu[idx+1:], ",")
            x := fmt.tprintf("x=%s,y=%s", spl[0], spl[1])
            y := fmt.tprintf("x=%s,y=%s", spl[2], spl[3])
            o := fmt.tprintf("x=%s,y=%s", spl[4], spl[5])
            valu = fmt.tprintf("%s%s x={{%s}}, y={{%s}}, origin={{%s}}", g.pck, valu[0:idx+1], x, y, o)
          }

          if strings.has_prefix(valu, "Transform3D") {  // opaque and 3x3 mat (basis) and origin (vector3)
            valu, _ = strings.replace_all(valu, "(", "{")
            valu, _ = strings.replace_all(valu, ")", "}")
            idx := strings.index(valu, "{")
            spl := strings.split(valu[idx+1:], ",")
            x := fmt.tprintf("x={{x=%s, y=%s, z=%s}}", spl[0], spl[1], spl[2])
            y := fmt.tprintf("y={{x=%s, y=%s, z=%s}}", spl[3], spl[4], spl[5])
            z := fmt.tprintf("z={{x=%s, y=%s, z=%s}}", spl[6], spl[7], spl[8])
            o := fmt.tprintf("{{x=%s, y=%s, z=%s}}", spl[9], spl[10], spl[11])
            valu = fmt.tprintf("%s%s basis={{%s,%s,%s}}, origin=%s", g.pck, valu[0:idx+1], x, y, z, o)
          }

          if strings.has_prefix(valu, "Basis") { // opaque and a 3x3 mat... or 3 vector3's
            valu, _ = strings.replace_all(valu, "(", "{")
            valu, _ = strings.replace_all(valu, ")", "}")
            idx := strings.index(valu, "{")
            spl := strings.split(valu[idx+1:], ",")
            x := fmt.tprintf("x=%s, y=%s, z=%s", spl[0], spl[1], spl[2])
            y := fmt.tprintf("x=%s, y=%s, z=%s", spl[3], spl[4], spl[5])
            z := fmt.tprintf("x=%s, y=%s, z=%s", spl[6], spl[7], spl[8])
            valu = fmt.tprintf("%s%s x={{%s}}, y={{%s}}, z={{%s}}", g.pck, valu[0:idx+1], x, y, z)
            valu, _ = strings.replace_all(valu, "inf", "math.inf_f32(1)")
          }
          
          os.write_string(fd, fmt.tprintf("%s : %s = %s\n", name, correct_type(type, "", g), valu))
        }
      }
    }

    os.write_string(fd, "\n// Constructors Destructor ------------------------------\n")

    // os.write_string(fd, fmt.tprintf("_bind :: proc(me: ^%s) {{\n", correct_type(class_name, "", g)))
    // if "methods" in builtin_api {
    //   for method in builtin_api["methods"].(json.Array) {
    //     method_name := fmt.tprintf("%s", method.(json.Object)["name"])
    //     if method_name == "map" do method_name = "_map"
    //     os.write_string(fd, fmt.tprintf("  me.%s = %s\n", method_name, method_name))
    //   }
    // }
    // if "indexing_return_type" in builtin_api {
    //   os.write_string(fd, fmt.tprintf("  me.set_idx = set_idx\n"))
    //   os.write_string(fd, fmt.tprintf("  me.get_idx = get_idx\n"))
    // }
    // os.write_string(fd, fmt.tprintf("}}\n"))
    
    if "constructors" in builtin_api {
      for constructor in builtin_api["constructors"].(json.Array) {
        idx, _ := strconv.parse_int(fmt.tprintf("%f", constructor.(json.Object)["index"]))
        method_signature := fmt.tprintf("constructor%d :: proc(", idx)
        arguments : [dynamic]string; defer delete(arguments)
        if "arguments" in constructor.(json.Object) {
          for argument, i in constructor.(json.Object)["arguments"].(json.Array) {
            name := fmt.tprintf("%s", argument.(json.Object)["name"])
            type := fmt.tprintf("%s", argument.(json.Object)["type"])
            tmp := ""
            if type == "bool" {
              tmp = fmt.tprintf("bval%d := %s ? 1 : 0\n  call_args[%d] = cast(gde.GDExtensionConstTypePtr)&bval%d", i, escape_identifier(name), i, i)
            } else if type == "int" {
              tmp = fmt.tprintf("val%d := %s; call_args[%d] = cast(gde.GDExtensionConstTypePtr)&val%d", i, escape_identifier(name), i, i)
            } else if type == "float" {
              tmp = fmt.tprintf("val%d := cast(f64)%s; call_args[%d] = cast(gde.GDExtensionConstTypePtr)&val%d", i, escape_identifier(name), i, i)
            } else {
              tmp = fmt.tprintf("val%d := %s; call_args[%d] = cast(gde.GDExtensionConstTypePtr)&val%d", i, escape_identifier(name), i, i)
            }
            
            append(&arguments, strings.clone(tmp))
          }
        }
        
        if "arguments" in constructor.(json.Object) {
          args := constructor.(json.Object)["arguments"]
          arg_type := fmt.tprintf("%s", args.(json.Array)[0].(json.Object)["type"])
          
          method_signature = fmt.tprintf("%s%s", method_signature,
                                         make_function_parameters(args.(json.Array), g, true, true))          
        }
        method_signature = fmt.tprintf("%s) -> godot.%s {{\n", method_signature, class_name)
        os.write_string(fd, method_signature)
        os.write_string(fd, fmt.tprintf("  @static constructor_%d : gde.GDExtensionPtrConstructor\n", idx)) // TODO: assign to me's proc ptr instead?
        l := len(arguments) > 0 ? len(arguments) : 1
        os.write_string(fd, fmt.tprintf("  call_args : [%d]rawptr\n", l))
        for a in arguments {
          os.write_string(fd, fmt.tprintf("  %s\n", a))
        }
        os.write_string(fd, fmt.tprintf("  me : godot.%s\n", class_name))
        os.write_string(fd, fmt.tprintf("  if constructor_%d == nil do constructor_%d = gde.variant_get_ptr_constructor(gde.GDExtensionVariantType.GDEXTENSION_VARIANT_TYPE_%s, %d)\n", idx, idx, strings.to_upper(snake_class_name), idx))
        os.write_string(fd, fmt.tprintf("  constructor_%d(cast(gde.GDExtensionTypePtr)&me, cast(^gde.GDExtensionConstTypePtr)&call_args[0])\n", idx))

        // also call bind in all constructors
        // os.write_string(fd, fmt.tprintf("  _bind(me)\n"))
        os.write_string(fd, "  return me\n")
        os.write_string(fd, "}\n")
      }

      if class_name == "String" {
        // generate custom string proc constructors here
          os.write_string(fd, fmt.tprintf("to_string :: proc(me: ^%s, allocator:= context.allocator) -> string {{\n", correct_type(class_name, "", g)))
          os.write_string(fd, "  context.allocator = allocator\n")
          os.write_string(fd, "  data_len := gde.string_to_latin1_chars(cast(gde.GDExtensionConstStringPtr)me, nil, 0)\n")
          os.write_string(fd, "  data := make([]u8, data_len+1)\n")
          os.write_string(fd, "  gde.string_to_latin1_chars(cast(gde.GDExtensionConstStringPtr)me, cast(cstring)&data[0], data_len)\n")
          os.write_string(fd, "  data[data_len] = 0\n")
          os.write_string(fd, "  return string(data)\n")          
          os.write_string(fd, "}\n")
          
          os.write_string(fd, `
constructor_string :: proc(str: cstring) -> godot.String {
	gstr : godot.String
	gde.string_new_with_utf8_chars(&gstr, str)
	return gstr
}
`)
      } else if class_name == "StringName" {
        os.write_string(fd, `
constructor_string :: proc(str: cstring) -> godot.StringName {
	strn : godot.StringName
	gde.string_name_new_with_utf8_chars(&strn, str)
	return strn
}
to_string :: proc(strn: ^godot.StringName, allocator:=context.allocator) -> string {
	context.allocator = allocator
	var := variant.constructor(strn^); defer variant.destroy(&var)
	return variant.to_string(&var, allocator)
}
`)
      }
      
      os.write_string(fd, "constructor :: proc{")
      for constructor in builtin_api["constructors"].(json.Array) {
        idx, _ := strconv.parse_int(fmt.tprintf("%f", constructor.(json.Object)["index"]))
        s := idx > 0 ? ", " : ""
        os.write_string(fd, fmt.tprintf("%sconstructor%d", s, idx))
      }
      if class_name == "String" || class_name == "StringName" {
        os.write_string(fd, fmt.tprintf(", constructor_string"))
      }
      os.write_string(fd, "}\n")
    }
    
    if builtin_api["has_destructor"].(json.Boolean) {
      method_signature := fmt.tprintf("destructor :: proc(me: ^%s", correct_type(class_name, "", g))
      method_signature = fmt.tprintf("%s) {{\n", method_signature)
      os.write_string(fd, method_signature)
      os.write_string(fd, fmt.tprintf("  @static destructor : gde.GDExtensionPtrDestructor\n"))
      os.write_string(fd, fmt.tprintf("  if destructor == nil do destructor = gde.variant_get_ptr_destructor(gde.GDExtensionVariantType.GDEXTENSION_VARIANT_TYPE_%s)\n", strings.to_upper(snake_class_name)))
      os.write_string(fd, fmt.tprintf("  destructor(cast(gde.GDExtensionTypePtr)me)\n"))
      os.write_string(fd, "}\n")
    }
    
    os.write_string(fd, "\n// Methods ------------------------------\n")
    
    method_list : [dynamic]string
    if "methods" in builtin_api {
      for method in builtin_api["methods"].(json.Array) {
        method_name := fmt.tprintf("%s", method.(json.Object)["name"])
        hash, _ := strconv.parse_int(fmt.tprintf("%f", method.(json.Object)["hash"]))
        enum_type_name := fmt.tprintf("GDEXTENSION_VARIANT_TYPE_%s", strings.to_upper(snake_class_name))
        if method_name == "map" do method_name = "_map"
        append(&method_list, method_name)
        
        method_signature := fmt.tprintf("%s :: proc(me: ^%s", method_name, correct_type(class_name, "", g))
        vararg := cast(bool) method.(json.Object)["is_vararg"].(json.Boolean)
        if "arguments" in method.(json.Object) {        
          method_signature = fmt.tprintf("%s, %s", method_signature,
                                         make_function_parameters(method.(json.Object)["arguments"].(json.Array), g, true, true, vararg))
        }
        method_signature = fmt.tprintf("%s)", method_signature)       
        if "is_static" in method.(json.Object) && method.(json.Object)["is_static"].(json.Boolean) {
          //method_signature = fmt.tprintf("%s", method_signature) // TODO??
        }
        if "return_type" in method.(json.Object) {
          return_type := fmt.tprintf("%s", method.(json.Object)["return_type"])
          pta := get_ptr_to_arg()
          crt := correct_type(return_type, "", g)
          ptr := "^"
          if crt in pta {
            ptr = ""
          }
          
          // method_signature = fmt.tprintf("%s -> %s%s", method_signature, ptr, crt)
          method_signature = fmt.tprintf("%s -> %s", method_signature, crt)
          
        }
        os.write_string(fd, method_signature)
        os.write_string(fd, fmt.tprintf(" {{\n"))

        os.write_string(fd, "// builtin class method\n")

        os.write_string(fd, fmt.tprintf("  @static name : godot.StringName\n"))        
        os.write_string(fd, fmt.tprintf("  @static _method : gde.GDExtensionPtrBuiltInMethod\n"))
        os.write_string(fd, fmt.tprintf("  if _method == nil {{\n"))
        // os.write_string(fd, fmt.tprintf("    name = new(godot.StringName); %s_to_string_name(name, \"%s\")\n", class_name!="String"?"gstring.":"", method_name))
        os.write_string(fd, fmt.tprintf("    gde.string_name_new_with_utf8_chars(&name, \"%s\")\n", method_name))
        os.write_string(fd, fmt.tprintf("    _method = gde.variant_get_ptr_builtin_method(gde.GDExtensionVariantType.%s, &name, %d)\n", enum_type_name, hash))
        os.write_string(fd, fmt.tprintf("  }}\n"))

        arguments : [dynamic]string; defer delete(arguments)
        if "arguments" in method.(json.Object) {
          for argument, i in method.(json.Object)["arguments"].(json.Array) {
            name := fmt.tprintf("%s", argument.(json.Object)["name"])
            type := fmt.tprintf("%s", argument.(json.Object)["type"])
            tmp : string
            if type == "bool" {
              tmp = fmt.tprintf("bval%d := %s ? 1 : 0\n  call_args[%d] = cast(gde.GDExtensionConstTypePtr)&bval%d", i, escape_identifier(name), i, i)
            } else {
              tmp = fmt.tprintf("val%d :%s= %s; call_args[%d] = auto_cast &val%d", i, correct_type(type, "", g), escape_identifier(name), i, i)
              // if strings.has_prefix(correct_type(type, "", g), "godot") {
              //   tmp = fmt.tprintf("val%d := %s; call_args[%d] = cast(gde.GDExtensionConstTypePtr)val%d", i, escape_identifier(name), i, i)
              // } else {
              //   tmp = fmt.tprintf("val%d :%s= %s; call_args[%d] = cast(gde.GDExtensionConstTypePtr)&val%d", i, correct_type(type, "", g), escape_identifier(name), i, i)
              // }
            }
            append(&arguments, strings.clone(tmp))
          }
        }
        l := len(arguments) > 0 ? len(arguments) : 1
        os.write_string(fd, fmt.tprintf("  call_args : [%d]gde.GDExtensionConstTypePtr\n", l))
        for a in arguments {
          os.write_string(fd, fmt.tprintf("  %s\n", a))
        }
        
        if "return_type" in method.(json.Object) {
          return_type := fmt.tprintf("%s", method.(json.Object)["return_type"])
          pta := get_ptr_to_arg()
          crt := correct_type(return_type, "", g)
          crt_with_ptr := fmt.tprintf("^%s", crt)
          ptr := ""
          if crt_with_ptr in pta || crt == "godot.Variant" {
            ptr = "^"
          }

          os.write_string(fd, fmt.tprintf("  ret : %s\n", crt))
          os.write_string(fd, fmt.tprintf("  _method(cast(gde.GDExtensionTypePtr)me, raw_data(call_args[:]), cast(gde.GDExtensionTypePtr)&ret, %d)\n", len(arguments)))
          // if ptr == "^" {
          //   os.write_string(fd, fmt.tprintf("  ret := new(%s)\n", crt))
          //   os.write_string(fd, fmt.tprintf("  method(cast(gde.GDExtensionTypePtr)&me, cast(^gde.GDExtensionConstTypePtr)&call_args[0], cast(gde.GDExtensionTypePtr)ret, %d)\n", len(arguments)))
          // } else {
          //   os.write_string(fd, fmt.tprintf("  ret : %s\n", crt))
          //   os.write_string(fd, fmt.tprintf("  method(cast(gde.GDExtensionTypePtr)&me, cast(^gde.GDExtensionConstTypePtr)&call_args[0], cast(gde.GDExtensionTypePtr)&ret, %d)\n", len(arguments)))
          // }
          // 
          os.write_string(fd, fmt.tprintf("  return ret\n"))
        } else {
          os.write_string(fd, fmt.tprintf("  _method(cast(gde.GDExtensionTypePtr)me, cast(^gde.GDExtensionConstTypePtr)&call_args[0], nil, %d)\n", len(arguments)))
        }
        os.write_string(fd, "}\n")
      }
    }

    if class_name == "String" {
      //os.write_string(fd, "utf8 :: proc(from: ^char, len: int=-1) -> string {}\n")
      //os.write_string(fd, "parse_utf8 :: proc(from: ^char, len: int=-1) {}\n")
      //os.write_string(fd, "utf16 :: proc(from: ^char, len: int=-1) -> string {}\n")
      //os.write_string(fd, "parse_utf16 :: proc(from: ^char, len: int=-1)\n")
      // more TODO
    }

    //if "members" in builtin_api {
    //  for member in builtin_api["members"].(json.Array) {
    //    getname := fmt.tprintf("get_%s", member.(json.Object)["name"])
    //    setname := fmt.tprintf("set_%s", member.(json.Object)["name"])        
    //    type := fmt.tprintf("%s", member.(json.Object)["type"])
    //    if !(slice.contains(method_list[:], getname)) {
    //      os.write_string(fd, fmt.tprintf("%s :: proc() -> %s\n", getname, correct_type(type, "", g)))
    //    }
    //    if !(slice.contains(method_list[:], setname)) {
    //      os.write_string(fd, fmt.tprintf("%s :: proc() -> %s\n", setname, correct_type(type, "", g)))
    //    }
    //  }
    //}

    if "indexing_return_type" in builtin_api {
      type := fmt.tprintf("%s", builtin_api["indexing_return_type"])
      cname := correct_type(class_name, "", g)
      ctype := correct_type(type, "", g)
      if strings.contains(cname, "Int32") do ctype = "i32"
      if strings.contains(cname, "Int64") do ctype = "i64"
      if strings.contains(cname, "Float32") do ctype = "f32"
      if strings.contains(cname, "Float64") do ctype = "f64"


      // TODO make this global? and include set_idx/get_idx in struct proc pointers
      gdproc_map : map[string]string
      gdproc_map["Array"] = "array_operator_index"
      gdproc_map["PackedByteArray"] = "packed_byte_array_operator_index"
      gdproc_map["PackedColorArray"] = "packed_color_array_operator_index"
      gdproc_map["PackedFloat32Array"] = "packed_float32_array_operator_index"
      gdproc_map["PackedFloat64Array"] = "packed_float64_array_operator_index"
      gdproc_map["PackedInt32Array"] = "packed_int32_array_operator_index"
      gdproc_map["PackedInt64Array"] = "packed_int64_array_operator_index"
      gdproc_map["PackedStringArray"] = "packed_string_array_operator_index"
      gdproc_map["PackedVector2Array"] = "packed_vector2_array_operator_index"
      gdproc_map["PackedVector3Array"] = "packed_vector3_array_operator_index"

      if class_name in gdproc_map {
        os.write_string(fd, fmt.tprintf("set_idx :: proc(me: ^%s, #any_int idx: int, v: ^%s) {{\n", cname, ctype))
        os.write_string(fd, fmt.tprintf("  self := cast(gde.GDExtensionTypePtr)me\n"))
        os.write_string(fd, fmt.tprintf("  (cast(^%s)gde.%s(self, cast(gde.GDExtensionInt)idx))^ = v^\n", ctype, gdproc_map[class_name]))
        os.write_string(fd, fmt.tprintf("}}\n"))
        os.write_string(fd, fmt.tprintf("get_idx :: proc(me: ^%s, #any_int idx: int) -> ^%s {{\n", cname, ctype))
        os.write_string(fd, fmt.tprintf("  self := cast(gde.GDExtensionTypePtr)me\n"))     
        os.write_string(fd, fmt.tprintf("  return cast(^%s)gde.%s(self, cast(gde.GDExtensionInt)idx)\n", ctype, gdproc_map[class_name]))
        os.write_string(fd, fmt.tprintf("}}\n"))
        
      } else {
        os.write_string(fd, fmt.tprintf("set_idx :: proc(me: ^%s, #any_int idx: int, v: ^%s) {{\n", cname, ctype))
        os.write_string(fd, fmt.tprintf("  self := cast(gde.GDExtensionVariantPtr)me\n"))
        os.write_string(fd, fmt.tprintf("  valid : gde.GDExtensionBool\n"))
        os.write_string(fd, fmt.tprintf("  oob : gde.GDExtensionBool\n"))
        os.write_string(fd, fmt.tprintf("  gde.variant_set_indexed(self, cast(gde.GDExtensionInt)idx, cast(gde.GDExtensionConstVariantPtr)v, &valid, &oob)\n"))
        os.write_string(fd, fmt.tprintf("}}\n"))
        os.write_string(fd, fmt.tprintf("get_idx :: proc(me: ^%s, #any_int idx: int) -> ^%s {{\n", cname, ctype))
        os.write_string(fd, fmt.tprintf("  self := cast(gde.GDExtensionConstVariantPtr)me\n"))
        os.write_string(fd, fmt.tprintf("  valid : gde.GDExtensionBool\n"))
        os.write_string(fd, fmt.tprintf("  oob : gde.GDExtensionBool\n"))
        os.write_string(fd, fmt.tprintf("  ret := new(%s)\n", ctype))
        os.write_string(fd, fmt.tprintf("  gde.variant_get_indexed(self, cast(gde.GDExtensionInt)idx, cast(gde.GDExtensionVariantPtr)ret, &valid, &oob)\n"))
        os.write_string(fd, fmt.tprintf("  return ret\n"))
        os.write_string(fd, fmt.tprintf("}}\n"))
      }
    }
    
    if class_name == "Array" {
      // type should be OBJECT if class_name is something.. TODO: what is/does script do?
      os.write_string(fd, fmt.tprintf("set_typed :: proc(me: ^godot.Array, type: gde.GDExtensionVariantType, class_name: gde.GDExtensionConstStringNamePtr) {{\n"))
      os.write_string(fd, fmt.tprintf("  script := new(godot.Variant); defer free(script)\n")) // what is this?
      os.write_string(fd, fmt.tprintf("  gde.array_set_typed(cast(gde.GDExtensionTypePtr)me, type, class_name, cast(gde.GDExtensionConstVariantPtr)&script)\n"))
      os.write_string(fd, fmt.tprintf("}}\n"))
    }

    // if "is_keyed" in builtin_api && builtin_api["is_keyed"].(json.Boolean) {
    //   // any variant can be key
    //   //pta["uint"] = {"INT", "i64"}
    //   pta := get_ptr_to_arg()
    //   vtoa : map[string]string
    //   for k, v in pta { // reverse map look up
    //     if !(v[0] in vtoa) {
    //       vtoa[v[0]] = k
    //     }
    //   }
    //   
    //   for k, v in vtoa {
    //     os.write_string(fd, fmt.tprintf("set_key_%s :: proc(me: ^godot.Dictionary, pk: %s, v: ^godot.Variant) {{\n", k, v))
    //     os.write_string(fd, fmt.tprintf("  self := cast(gde.GDExtensionTypePtr)me\n"))
    //     os.write_string(fd, fmt.tprintf("  k := new(godot.Variant)\n"))
    //     os.write_string(fd, fmt.tprintf("  variant.constructor(k, pk)\n"))
    //     os.write_string(fd, fmt.tprintf("  (cast(^godot.Variant)gde.dictionary_operator_index(self, cast(gde.GDExtensionConstVariantPtr)k))^ = v^\n"))
    //     os.write_string(fd, fmt.tprintf("}}\n"))
    //     os.write_string(fd, fmt.tprintf("get_key_%s :: proc(me: ^godot.Dictionary, pk: %s) -> ^godot.Variant {{\n", k, v))
    //     os.write_string(fd, fmt.tprintf("  self := cast(gde.GDExtensionTypePtr)me\n"))
    //     os.write_string(fd, fmt.tprintf("  k := new(godot.Variant)\n"))
    //     os.write_string(fd, fmt.tprintf("  variant.constructor(k, pk)\n"))
    //     os.write_string(fd, fmt.tprintf("  return cast(^godot.Variant)gde.dictionary_operator_index(self, cast(gde.GDExtensionConstVariantPtr)k)\n"))
    //     os.write_string(fd, fmt.tprintf("}}\n"))
    //   }
    //   os.write_string(fd, fmt.tprintf("set_key_str :: proc(me: ^godot.Dictionary, pk: string, pv: string) {{\n"))
    //   os.write_string(fd, fmt.tprintf("  self := cast(gde.GDExtensionTypePtr)me\n"))
    //   os.write_string(fd, fmt.tprintf("  k := new(godot.Variant); defer free(k)\n"))
    //   os.write_string(fd, fmt.tprintf("  variant.constructor(k, pk)\n"))
    //   os.write_string(fd, fmt.tprintf("  v := new(godot.Variant); defer free(v)\n"))
    //   os.write_string(fd, fmt.tprintf("  variant.constructor(v, pv)\n"))
    //   os.write_string(fd, fmt.tprintf("  (cast(^godot.Variant)gde.dictionary_operator_index(self, cast(gde.GDExtensionConstVariantPtr)k))^ = v^\n"))
    //   os.write_string(fd, fmt.tprintf("}}\n"))      
    //   os.write_string(fd, fmt.tprintf("get_key_str :: proc(me: ^godot.Dictionary, pk: string) -> ^godot.Variant {{\n"))
    //   os.write_string(fd, fmt.tprintf("  self := cast(gde.GDExtensionTypePtr)me\n"))
    //   os.write_string(fd, fmt.tprintf("  k := new(godot.Variant)\n"))
    //   os.write_string(fd, fmt.tprintf("  variant.constructor(k, pk)\n"))
    //   os.write_string(fd, fmt.tprintf("  return cast(^godot.Variant)gde.dictionary_operator_index(self, cast(gde.GDExtensionConstVariantPtr)k)\n"))
    //   os.write_string(fd, fmt.tprintf("}}\n"))      
    //   
    //   os.write_string(fd, fmt.tprintf("set_key :: proc{{\n"))
    //   for k, v in vtoa {
    //     os.write_string(fd, fmt.tprintf("set_key_%s,", k))
    //   }
    //   os.write_string(fd, fmt.tprintf("set_key_str"))
    //   os.write_string(fd, fmt.tprintf("}}\n"))
    //   os.write_string(fd, fmt.tprintf("get_key :: proc{{\n"))
    //   for k, v in vtoa {
    //     os.write_string(fd, fmt.tprintf("get_key_%s,", k))
    //   }
    //   os.write_string(fd, fmt.tprintf("get_key_str"))
    //   os.write_string(fd, fmt.tprintf("}}\n"))      
    //   //os.write_string(fd, fmt.tprintf("is_key :: proc{{}}\n")) // TODO
    // }

    operators_map : map[string]int
    // if "operators" in builtin_api {
    //   for operator in builtin_api["operators"].(json.Array) {
    //     operator_name := fmt.tprintf("%s", operator.(json.Object)["name"])
    //     right_type := fmt.tprintf("%s", operator.(json.Object)["right_type"])
    //     return_type := fmt.tprintf("%s", operator.(json.Object)["return_type"])
    //     is_unary := strings.contains(operator_name, "unary")
    //     non_unary_name, _ := strings.replace_all(operator_name, "unary", "")
    //     cop := correct_operator(operator_name)
    //     pta := get_ptr_to_arg()
    //     crt := correct_type(return_type, "", g)
    //     ptr := "^"
    //     if crt in pta {
    //       ptr = ""
    //     }

	// 	if correct_operator(operator_name) == "OP_NOT" do continue
    //     
    //     if "right_type" in operator.(json.Object) {
    //       if !(cop in operators_map) {
    //         operators_map[cop] = 0
    //       }
    //       os.write_string(fd, fmt.tprintf("operator_%s%d :: proc(me: ^%s, other: %s) -> %s%s ", cop, operators_map[cop], correct_type(class_name, "", g), type_for_parameter(right_type, "", g), ptr, crt))
    //       operators_map[correct_operator(operator_name)] += 1
    //     } else {
    //       cop := correct_operator(non_unary_name)
    //       if !(cop in operators_map) {
    //         operators_map[cop] = 0
    //       }
    //       os.write_string(fd, fmt.tprintf("operator_%s :: proc(me: ^%s) -> %s%s ", cop, correct_type(class_name, "", g), ptr, crt))
    //     }

    //     os.write_string(fd, fmt.tprintf("{{\n"))
    //     enum_type_name := fmt.tprintf("GDEXTENSION_VARIANT_TYPE_%s", strings.to_upper(snake_class_name))
    //     os.write_string(fd, fmt.tprintf("  @static name : godot.String\n"))
    //     os.write_string(fd, fmt.tprintf("  @static operator : gde.GDExtensionPtrOperatorEvaluator\n"))
    //     os.write_string(fd, fmt.tprintf("  if operator == nil {{\n"))
    //     os.write_string(fd, fmt.tprintf("    gde.string_name_new_with_utf8_chars(&name, \"%s\")\n", operator_name))
    //     if right_type == "Variant" do right_type = "nil"
    //     snake_right_type := camel_to_snake(right_type)
    //     rt := fmt.tprintf("GDEXTENSION_VARIANT_TYPE_%s", strings.to_upper(snake_right_type))
    //     os.write_string(fd, fmt.tprintf("    operator = gde.variant_get_ptr_operator_evaluator(gde.GDExtensionVariantOperator.GDEXTENSION_VARIANT_%s, gde.GDExtensionVariantType.%s, gde.GDExtensionVariantType.%s)\n", cop, enum_type_name, rt))
    //     os.write_string(fd, fmt.tprintf("  }}\n"))

    //     if correct_type(return_type, "", g) == "bool" {
    //       os.write_string(fd, fmt.tprintf("  ret := new(int)\n"))
    //     } else {
    //       os.write_string(fd, fmt.tprintf("  ret := new(%s)\n", correct_type(return_type, "", g)))
    //       os.write_string(fd, fmt.tprintf("  ret := new(%s)\n", correct_type(return_type, "", g)))
    //     }
    //     if !is_unary {
    //       if type_for_parameter(right_type, "", g) == "bool" {
    //         os.write_string(fd, "  lother : int = other ? 1 : 0\n") // local other
    //       } else {
    //         os.write_string(fd, fmt.tprintf("  lother : %s = other\n", type_for_parameter(right_type, "", g)))
    //       }
    //       if strings.has_prefix(type_for_parameter(right_type, "", g), "^") {
    //         os.write_string(fd, fmt.tprintf("  operator(cast(gde.GDExtensionConstTypePtr)me, cast(gde.GDExtensionConstTypePtr)lother, cast(gde.GDExtensionTypePtr)ret)\n"))
    //       } else {
    //         os.write_string(fd, fmt.tprintf("  operator(cast(gde.GDExtensionConstTypePtr)me, cast(gde.GDExtensionConstTypePtr)&lother, cast(gde.GDExtensionTypePtr)ret)\n"))
    //       }
    //     } else {
    //       os.write_string(fd, fmt.tprintf("  operator(cast(gde.GDExtensionConstTypePtr)me, cast(gde.GDExtensionConstTypePtr)nil, cast(gde.GDExtensionTypePtr)ret)\n"))         
    //     }
    //     
    //     if correct_type(return_type, "", g) == "bool" {
    //       os.write_string(fd, "  return ret^ == 0 ? false : true")
    //     } else {
    //       os.write_string(fd, "  return ret")
    //     }
    //     os.write_string(fd, "\n}\n")
    //     
    //   }
    // }
    for op_k, op_v in operators_map {
      if op_v == 0 do continue
      os.write_string(fd, fmt.tprintf("%s :: proc{{", op_k))
      for i in 0..<op_v {
        os.write_string(fd, fmt.tprintf("%soperator_%s%d", i>0 ? ", " : "", op_k, i))
      }
      os.write_string(fd, "}\n")
    }

    g.pck = ""

  }

  // TODO: more "nice stuff" for builtin types
}

generate_builtin_bindings :: proc(root: json.Object, target_dir: string, build_config: string, g: ^Globals) {
	if true do return
  file := filepath.join([]string{target_dir, "builtin_structures.odin"})
    fmt.printf("Generate builtin class\n")
  mode: int = 0
  when os.OS == .Linux || os.OS == .Darwin {
    mode = os.S_IRUSR | os.S_IWUSR | os.S_IRGRP | os.S_IROTH
  }

  os.remove(file)
  fd, err := os.open(file, os.O_WRONLY|os.O_CREATE, mode)
  defer os.close(fd)
  if err == os.ERROR_NONE {
    os.write_string(fd, "package godot\n\n")
    os.write_string(fd, "import gde \"../gdextension\"\n\n")
    g.pck = ""

    // Store types beforehand.
    for builtin_api in root["builtin_classes"].(json.Array) {
      name := fmt.tprintf("%s", builtin_api.(json.Object)["name"])
      if is_pod_type(name) do continue
      append(&g.builtin_classes, strings.clone(name))
    }

    builtin_sizes : map[string]int

    // Get sizes
    for size_list in root["builtin_class_sizes"].(json.Array) {
      bc := fmt.tprintf("%s", size_list.(json.Object)["build_configuration"])
      if bc == build_config {
        for size in size_list.(json.Object)["sizes"].(json.Array) {
          sname   := fmt.tprintf("%s", size.(json.Object)["name"])
          sval, _ := strconv.parse_int(fmt.tprintf("%f", size.(json.Object)["size"]))
          builtin_sizes[strings.clone(sname)] = sval
        }
        break
      }
    }

    // Variant, GodotObject, Wrapped, and Ref
    os.write_string(fd, fmt.tprintf("GODOT_ODIN_VARIANT_SIZE :: %d\n", builtin_sizes["Variant"]))
    os.write_string(fd, fmt.tprintf("Variant :: distinct [GODOT_ODIN_VARIANT_SIZE]u8\n"))
    
    os.write_string(fd, fmt.tprintf("GodotObject :: distinct rawptr\n"))
    
    os.write_string(fd, `
Wrapped :: struct {
	_owner : rawptr, // GodotObject ptr
	_table : rawptr, // vtable
}
Wrapped_VTABLE :: struct {
}
`)

    os.write_string(fd, fmt.tprintf("Ref :: struct {{\n"))
    //os.write_string(fd, fmt.tprintf("  reference : rawptr,\n"))
    os.write_string(fd, fmt.tprintf("}}\n"))

    // Write something similar to class header/source files for odin
    for builtin_api in root["builtin_classes"].(json.Array) {
      name := fmt.tprintf("%s", builtin_api.(json.Object)["name"])

      if is_pod_type(name) { continue }
      if is_included_type(name) { continue }

      used_classes : [dynamic]string
      fully_used_classes : [dynamic]string
      defer delete(used_classes)
      defer delete(fully_used_classes)

      size := builtin_sizes[name]

      if "constructors" in builtin_api.(json.Object) {
        for constructor in builtin_api.(json.Object)["constructors"].(json.Array) {
          if "arguments" in constructor.(json.Object) {
            for argument in constructor.(json.Object)["arguments"].(json.Array) {
              type := fmt.tprintf("%s", argument.(json.Object)["type"])
              if is_included(type, name, g) {
                if "default_value" in argument.(json.Object) && type != "Variant" {
                  append(&fully_used_classes, strings.clone(type))
                } else {
                  append(&used_classes, strings.clone(type))
                }
              }
            }
          }
        }
      }

      if "methods" in builtin_api.(json.Object) {
        for method in builtin_api.(json.Object)["methods"].(json.Array) {
          if "arguments" in method.(json.Object) {
            for argument in method.(json.Object)["arguments"].(json.Array) {
              type := fmt.tprintf("%s", argument.(json.Object)["type"])
              if is_included(type, name, g) {
                if "default_value" in argument.(json.Object) && type != "Variant" {
                  append(&fully_used_classes, strings.clone(type))
                } else {
                  append(&used_classes, strings.clone(type))
                }
              }
            }
          }
          if "return_type" in method.(json.Object) {
            ret_type := fmt.tprintf("%s", method.(json.Object)["return_type"])
            if is_included(ret_type, name, g) {
              append(&used_classes, strings.clone(ret_type))
            }
          }
        }
      }

      if "members" in builtin_api.(json.Object) {
        for member in builtin_api.(json.Object)["members"].(json.Array) {
          type := fmt.tprintf("%s", member.(json.Object)["type"])
          if is_included(type, name, g) {
            append(&used_classes, strings.clone(type))
          }
        }
      }

      if "indexing_return_type" in builtin_api.(json.Object) {
        irtype := fmt.tprintf("%s", builtin_api.(json.Object)["indexing_return_type"])
        if is_included(irtype, name, g) {
          append(&used_classes, strings.clone(irtype))
        }
      }

      if "operators" in builtin_api.(json.Object) {
        for operator in builtin_api.(json.Object)["operators"].(json.Array) {
          if "right_type" in operator.(json.Object) {
            rtype := fmt.tprintf("%s", operator.(json.Object)["right_type"])
            if is_included(rtype, name, g) {
              append(&used_classes, strings.clone(rtype))
            }
          }
        }
      }

      for type_name in fully_used_classes {
        for i in 0..<len(used_classes) {
          if type_name == used_classes[i] {
            unordered_remove(&used_classes, i)
          }
        }
      }

      slice.sort(used_classes[:])
      slice.sort(fully_used_classes[:])
      slim_used_classes : [dynamic]string
      slim_fully_used_classes : [dynamic]string   
      prev := ""
      for i in 0..<len(used_classes) {
        if prev != used_classes[i] do append(&slim_used_classes, used_classes[i])
        prev = used_classes[i]
      }
      prev = ""
      for i in 0..<len(fully_used_classes) {
        if prev != fully_used_classes[i] do append(&slim_fully_used_classes, fully_used_classes[i])
        prev = fully_used_classes[i]
      }
      
      //fmt.println(name, "is using", slim_used_classes)    
      //fmt.println(name, "is fully using", slim_fully_used_classes)

      // below will create both a "class procs" file and add a struct to "structure.odin"
      generate_builtin_classes(builtin_api.(json.Object), target_dir, size, &slim_used_classes, &slim_fully_used_classes, fd, g)
    }
  }
}

is_struct_type :: proc(type_name: string, g: ^Globals) -> bool {
  return is_included_struct_type(type_name) || slice.contains(g.native_structures[:], type_name)
}

get_return_type :: proc(function_data: json.Object, g: ^Globals) -> string {
  return_type := ""
  return_meta := ""
  if "return_type" in function_data {   // TYPE
    rt := fmt.tprintf("%s", function_data["return_type"])
    return_type = rt
  } else if "return_value" in function_data {  // VALUE
    return_type = fmt.tprintf("%s", function_data["return_value"].(json.Object)["type"])
    if "meta" in function_data["return_value"].(json.Object) {
      return_meta = fmt.tprintf("%s", function_data["return_value"].(json.Object)["meta"])
    }
  }
  return_type, _ = strings.replace_all(return_type, "const ", "")
  return return_type
}

make_signature :: proc(class_name: string, function_data: json.Object, g: ^Globals, use_template_get_node: bool = true, for_builtin: bool = false, for_engine: bool = false) -> string {
  func_signature := ""
  is_vararg := "is_vararg" in function_data && function_data["is_vararg"].(json.Boolean)
  //is_static := "is_static" in function_data && function_data["is_static"].(json.Boolean)

  name := fmt.tprintf("%s", function_data["name"])
  function_signature_internal := ""
  if is_vararg {
    function_signature_internal = "_internal"
  }

  func_signature = fmt.tprintf("%s%s%s :: proc(", func_signature, escape_identifier(name), function_signature_internal)

  return_type := get_return_type(function_data, g)

  if for_engine { // include "me: ^SomeClass," arg
    func_signature = fmt.tprintf("%sme: ^%s, ", func_signature, correct_type(class_name, "", g))
  }
  
  if is_vararg {
    func_signature = fmt.tprintf("%sargs: ^^%sVariant, arg_count: int", func_signature, g.pck)
  } else {
    if "arguments" in function_data {
		// return_type_is_array := strings.has_prefix(return_type, "typedarray::")
		func_signature = fmt.tprintf("%s%s", func_signature, make_function_parameters(function_data["arguments"].(json.Array), g, false, false, is_vararg))
    }
  }
  func_signature = fmt.tprintf("%s)", func_signature)
  
  rt := correct_type(return_type, "", g) // TODO return meta?
  if strings.contains(rt, "^void") {
    rt = "rawptr"
  }

  if return_type != "" {
	func_signature = fmt.tprintf("%s -> %s", func_signature, rt)
  }
  return func_signature
}

generate_engine_classes :: proc(class_api: json.Object, target_dir: string, used_classes: ^[dynamic]string, fully_used_classes: ^[dynamic]string, sfd: os.Handle, g: ^Globals) {
  // generate_variant_class(target_dir, g)
  
  class_name := fmt.tprintf("%s", class_api["name"])
  snake_class_name := camel_to_snake(class_name)
  // dir := fmt.tprintf("%s/%s", target_dir, snake_class_name)
  // class_file := fmt.tprintf("%s/%s%s", dir, snake_class_name, ".odin")
  class_file := filepath.join([]string{target_dir, fmt.tprintf("%s.odin", snake_class_name)})

  // fmt.printf("Generate engine class: {}\n", class_name)

  // instead of making an odin struct "fit" what a class should be
  // make a package of snake_class_name that contains NO member variables/data struct(class_name) but
  // does contain all member functions(as procs), constructors, destructor, operators, etc.. of the class
  // note1: packages are directory based, so all class procs will be packages/sub-directories of godot
  // note2: and all (:: structs) will be in "godot" package (structures.odin)
  // os.make_directory(dir)
  
  mode: int = 0
  when os.OS == .Linux || os.OS == .Darwin {
    mode = os.S_IRUSR | os.S_IWUSR | os.S_IRGRP | os.S_IROTH
  }

  os.remove(class_file)

  fd, err := os.open(class_file, os.O_WRONLY|os.O_CREATE, mode)
  
  defer os.close(fd)
  if err == os.ERROR_NONE {
    os.write_string(fd, "package godot\n\n")
    os.write_string(fd, "// engine\n")    
    os.write_string(fd, "import gde \"../gdextension\"\n")
    os.write_string(fd, "import \"../variant\"\n")

    for included in fully_used_classes {
      if included == "TypedArray" || included == "Variant" || included == "String" {
        //os.write_string(fd, "import \"../typed_array\"\n")
      } else {
        os.write_string(fd, fmt.tprintf("import \"../%s\"\n", camel_to_snake(included)))
      }
    }
		// there are a few engine classes not included in some files for some reason
		// TODO: real fix, by including them in ..._used_classes
		if class_name == "StandardMaterial3D" {
			os.write_string(fd, "import \"../base_material3d\"\n")
		} else if class_name == "Texture" {
			os.write_string(fd, "import \"../resource\"\n")
		}
		
    os.write_string(fd, "\n")

    if class_name != "Object" {
      //os.write_string(fd, "import \"<type_traits>\"\n")
      os.write_string(fd, "\n")     
    }

    parent := "Wrapped"
    if "inherits" in class_api {
      parent = fmt.tprintf("%s", class_api["inherits"])
    }

    tmp := g.pck
    g.pck = ""

    os.write_string(sfd, fmt.tprintf(`
%s :: struct {{
	_owner : rawptr, // GodotObject ptr
	using _table : ^%s_VTABLE, // vtable
}}
`, class_name, class_name))

    os.write_string(sfd, fmt.tprintf(`as_%s :: proc(obj: Object) -> %s {{
	return {{ _owner=obj._owner, _table = &__%s_table }}
}}
__%s_table : %s_VTABLE
`, class_name, class_name, class_name, class_name, class_name))

    os.write_string(sfd, fmt.tprintf("%s_VTABLE :: struct {{\n", class_name))
    os.write_string(sfd, fmt.tprintf("  using _ : ^%s_VTABLE,\n", parent))
    if "methods" in class_api {
      for method in class_api["methods"].(json.Array) {
        method_signature := make_signature(class_name, method.(json.Object), g, true, false, true)
        if strings.has_prefix(method_signature, "_") do continue
        method_signature, _ = strings.replace_all(method_signature, "::", ":")
        is_vararg := method.(json.Object)["is_vararg"].(json.Boolean)
        if is_vararg {
          end := strings.index(method_signature, ":")
          method_signature = method_signature[0:end-1]
          return_type := get_return_type(method.(json.Object), g)
          rt := correct_type(return_type, "", g) // TODO return meta?
          has_return := return_type != ""
          
          if has_return {
            method_signature = fmt.tprintf("%s : proc(me: ^%s, args: ..any) -> %s", method_signature, correct_type(class_name, "", g), correct_type(return_type, "", g))
          } else {
            method_signature = fmt.tprintf("%s : proc(me: ^%s, args: ..any)", method_signature, correct_type(class_name, "", g))
          }

          method_signature, _ = strings.replace_all(method_signature, "_internal", "")
        }
        os.write_string(sfd, fmt.tprintf("  %s,\n", method_signature))
      }
    }
    
    // is_singleton := slice.contains(g.singletons[:], class_name)
    // if is_singleton {
    //   // anything TODO here? for singletons?
    // }   
    os.write_string(sfd, "}\n\n") // end struct {

    g.pck = tmp

    // do fancy foot work to make a "constructor" for and engine object
    // if no_obj is true, then just bind procs, don't make an object with godot
    os.write_string(fd, fmt.tprintf("constructor :: proc() -> %s\n", class_name))
    os.write_string(fd, fmt.tprintf("{{\n"))
    os.write_string(fd, fmt.tprintf("  @static class_name : godot.StringName\n"))
    os.write_string(fd, fmt.tprintf("  @static initialized : bool\n"))
    os.write_string(fd, fmt.tprintf("  if initialized {{\n"))
    os.write_string(fd, fmt.tprintf("    gde.string_name_new_with_utf8_chars(&class_name, \"%s\")\n", class_name))
    os.write_string(fd, fmt.tprintf("    initialized = true\n"))
    os.write_string(fd, fmt.tprintf("  }}\n"))
    os.write_string(fd, fmt.tprintf("  me : godot.%s\n", class_name))
    os.write_string(fd, fmt.tprintf("  me._owner = gde.classdb_construct_object(cast(gde.GDExtensionConstStringNamePtr)&class_name)\n"))
    os.write_string(fd, fmt.tprintf("  me._table = &__%s_table\n", class_name))
    os.write_string(fd, "  return me\n")
    os.write_string(fd, "}\n")

	os.write_string(fd, fmt.tprintf("__%s_table := godot.%s_VTABLE {{\n", class_name, class_name))
    if "methods" in class_api {
      for method in class_api["methods"].(json.Array) {
        method_name :string= method.(json.Object)["name"].(json.String)
		if method_name == "" || method_name[0] == '_' do continue
        os.write_string(fd, fmt.tprintf("  %s = %s,\n", method_name, method_name))
      }
    }
	os.write_string(fd, "}\n\n\n")

	os.write_string(fd, "// methods\n")
    
    if "methods" in class_api {
      for method in class_api["methods"].(json.Array) {
        if method.(json.Object)["is_virtual"].(json.Boolean) do continue // done later

        method_signature := make_signature(class_name, method.(json.Object), g, true, false, true)
        os.write_string(fd, fmt.tprintf("%s\n", method_signature))
        generate_engine_classes_method(method.(json.Object), class_name, fd, g, used_classes)
      }
      for method in class_api["methods"].(json.Array) {
        if !method.(json.Object)["is_virtual"].(json.Boolean) do continue

        method_signature := make_signature(class_name, method.(json.Object), g, true, false, true)
        os.write_string(fd, fmt.tprintf("%s\n", method_signature))
        // TODO gen virtual methods?
      }
    }

	// fmt.printf("classes used by {}: {}\n", class_name, used_classes)
  }
    
  // TODO: more "nice stuff" for engine classes
}

build_configurations :: [?]string {
	"float_32",
	"float_64",
	"double_32",
	"double_64",
}
build_conf_float_defines :: [?]string { "f32", "f64", "f32", "f64", }
build_conf_int_defines :: [?]string { "i32", "i64", "i32", "i64", }

current_build_configuration_idx :: 1 // float_64

FileWriter :: struct {
	sb : strings.Builder,
	path : string,
}

file_writer_make :: proc(path: string, allocator:=context.allocator) -> FileWriter {
	context.allocator = allocator
	fw : FileWriter
	strings.builder_init(&fw.sb)
	fw.path = path
	return fw
}
file_writer_write :: proc(using fw: ^FileWriter) {// and destroy
	os.write_entire_file(path, transmute([]u8)strings.to_string(sb))
	strings.builder_destroy(&sb)
}

dovegen :: proc(root: json.Object, target_dir: string) {
	os.make_directory(target_dir)

	sb_godotfile : strings.Builder
	strings.builder_init(&sb_godotfile); strings.builder_destroy(&sb_godotfile)
	strings.write_string(&sb_godotfile, "package godot\n")
	strings.write_string(&sb_godotfile, "import gde \"../gdextension\"\n\n")

	// Generate builtin classes
	fw_builtin_classes := file_writer_make(filepath.join([]string{ target_dir, "define_builtin_classes.odin" }))
	dovegen_builtin_classes(&fw_builtin_classes.sb, root)
	file_writer_write(&fw_builtin_classes)

	// Generate variant stuff
	fw_variant := file_writer_make(filepath.join([]string{ target_dir, "variant.odin" }, context.temp_allocator))
	dovegen_variant(&fw_variant.sb, root)
	file_writer_write(&fw_variant)

	// Generate object classes
	sb_classfile : strings.Builder
	strings.builder_init(&sb_classfile); strings.builder_destroy(&sb_classfile)
	for class_api in root["classes"].(json.Array) {
		class_name := class_api.(json.Object)["name"].(json.String)
		if class_name == "ClassDB" do continue
		if class_name == "OS" do continue
		strings.builder_reset(&sb_classfile)
		dovegen_engine_class(&sb_godotfile, &sb_classfile, class_api.(json.Object))
		path := filepath.join([]string{ target_dir, fmt.tprintf("%s.odin", camel_to_snake(class_name)) }, context.temp_allocator)
		os.write_entire_file(path, transmute([]u8)strings.to_string(sb_classfile))
	}

	os.write_entire_file(filepath.join([]string{ target_dir, "godot.odin" }, context.temp_allocator), transmute([]u8)strings.to_string(sb_godotfile))
}

dovegen_builtin_classes :: proc(sb_classesfile: ^strings.Builder, root: json.Object) {
	using strings
	write_string(sb_classesfile, "package godot\nimport gde \"../gdextension\"\n\n")
	sizes := root["builtin_class_sizes"].(json.Array)[current_build_configuration_idx].(json.Object)["sizes"].(json.Array)
	_offsets := root["builtin_class_member_offsets"].(json.Array)[current_build_configuration_idx].(json.Object)["classes"].(json.Array)
	offsets := make(map[string]json.Array, len(_offsets)); defer delete(offsets)
	for o in _offsets do offsets[o.(json.Object)["name"].(json.String)] = o.(json.Object)["members"].(json.Array)

	for class, idx in root["builtin_classes"].(json.Array) {
		name := class.(json.Object)["name"].(json.String)
		size :int= cast(int)sizes[idx].(json.Object)["size"].(json.Float)

		write_string(sb_classesfile, fmt.tprintf("// %s\n", name)) // builtin class define
		if offset, ok := offsets[name]; ok {// with members
			write_string(sb_classesfile, fmt.tprintf("%s :: struct {{ // [%d]u8\n", name, size))
			for m in offset {
				m := m.(json.Object)
				member_name := m["member"].(json.String)
				member_type := m["meta"].(json.String)
				// float and int in builtin classes are all 4 bytes.
				if member_type == "float" do member_type = "f32"
				if member_type == "int32" do member_type = "i32"
				write_string(sb_classesfile, fmt.tprintf("\t%s : %s,\n", member_name, member_type))
			}
			write_string(sb_classesfile, "}\n\n")
		} else {// no members
			if name == "bool" do continue
			else if name == "float" do write_string(sb_classesfile, fmt.tprintf("%s :: %s\n\n", name, build_conf_float_defines[current_build_configuration_idx]))
			else if name == "int" do write_string(sb_classesfile, fmt.tprintf("%s :: %s\n\n", name, build_conf_int_defines[current_build_configuration_idx]))
			else do write_string(sb_classesfile, fmt.tprintf("%s :: distinct [%d]u8\n\n", name, size))
		}
	}
}
dovegen_variant :: proc(sb: ^strings.Builder, root: json.Object) {
	using strings
	write_string(sb, "package godot\nimport gde \"../gdextension\"\n\n")
	sizes := root["builtin_class_sizes"].(json.Array)[current_build_configuration_idx].(json.Object)["sizes"].(json.Array)
	assert(sizes[len(sizes)-1].(json.Object)["name"].(json.String)=="Variant", "Failed to get size of builtin class Variant, the last one is not Variant anymore.")
	write_string(sb, fmt.tprintf("Variant :: distinct [%d]u8\n\n", cast(int)sizes[len(sizes)-1].(json.Object)["size"].(json.Float)))
	write_string(sb, "variant_destroy :: proc (v: ^Variant) { gde.variant_destroy(auto_cast v) } \n")

	for class, idx in root["builtin_classes"].(json.Array) {
		// variant constructor
		v_class_name := class.(json.Object)["name"].(json.String)
		write_string(sb, fmt.tprintf(`
variant_from_%s :: proc(p: %s) -> Variant {{
	@static variant_cons : gde.GDExtensionVariantFromTypeConstructorFunc
	if variant_cons == nil {{
		variant_cons = gde.get_variant_from_type_constructor(.%s)
	}}
	p : %s
	ret : Variant
	variant_cons(&ret, &p)
	return ret
}}
`, v_class_name, v_class_name, dove_builtin_class_name_to_variant_type_enum_name(v_class_name, context.temp_allocator), v_class_name))
	}
}

dove_builtin_class_name_to_variant_type_enum_name :: proc(class_name: string, allocator:=context.allocator) -> string {
	context.allocator = allocator
	if class_name == "Array" do return "GDEXTENSION_VARIANT_TYPE_ARRAY"
	ints, was_allocation := strings.replace(class_name, "Array", "_Array", 1); defer if was_allocation do delete(ints)
	return fmt.aprintf("GDEXTENSION_VARIANT_TYPE_%s", strings.to_upper_snake_case(ints))
}

dovegen_engine_class :: proc(sb_godotfile, sb_classfile: ^strings.Builder, class_api: json.Object) {
	using strings
	sb_header, sb_body : Builder

	// Generate class file
	class_name :string= class_api["name"].(json.String)
	parent_name :string= class_api["inherits"].(json.String) if "inherits" in class_api else ""
	builder_init(&sb_header); defer builder_destroy(&sb_header)
	builder_init(&sb_body); defer builder_destroy(&sb_body)

	write_string(&sb_header, "package godot\n\n")
	write_string(&sb_header, "import gde \"../gdextension\"\n\n")

	dovegen_funcimpl_instance_constructor(&sb_body, class_name)

	// Table
	write_string(&sb_body, fmt.tprintf(`
__%s_table : _%s_TABLE
@private
_%s_TABLE :: struct {{
`, class_name, class_name, class_name))
	if parent_name != "" do write_string(&sb_body, fmt.tprintf("\tusing _ : ^_%s_TABLE,\n", parent_name))
	if "methods" in class_api {
		for method in class_api["methods"].(json.Array) {
			method_name := method.(json.Object)["name"].(json.String)
			if method_name[0] == '_' do continue
			// @TEMPORARY: Disabled to test variant bindings at first.
			// write_string(&sb_body, fmt.tprintf("\t%s : ", method_name))
			// dovegen_method_signature(&sb_body, method.(json.Object))
			// write_string(&sb_body, ",\n")
		}
	}
	write_string(&sb_body, "}\n")

	// Submit
	write_string(sb_classfile, to_string(sb_header))
	write_string(sb_classfile, to_string(sb_body))

	// Struct definition in file `_godot.odin`.
	if parent_name == "" {// No parent, the only one is `Object`
		write_string(sb_godotfile, fmt.tprintf(`
%s :: struct {{
	_obj : rawptr,
	_table : rawptr,
}}
`, class_name))
	} else {
		write_string(sb_godotfile, fmt.tprintf(`
%s :: struct {{ // : %s
	_obj : rawptr,
	_table : ^_%s_TABLE,
}}
`, class_name, parent_name, class_name))
	}
}

dovegen_method_signature :: proc(sb: ^strings.Builder, method: json.Object) {
	using strings
	is_vararg := "is_vararg" in method && method["is_vararg"].(json.Boolean)
	return_value := method["return_value"].(json.Object)["type"].(json.String) if "return_value" in method else ""
	write_string(sb, "proc (")
	if "arguments" in method {
		args := method["arguments"].(json.Array)
		for &arg, idx in args {
			arg := arg.(json.Object)
			arg_name := arg["name"].(json.String)
			arg_type := arg["type"].(json.String)
			write_string(sb, fmt.tprintf("%s: %s", arg_name, arg_type))
			if idx < len(args)-1 do write_string(sb, ", ")
		}
	}
	write_string(sb, ")")
	if return_value != "" {
		write_string(sb, " -> ")
		write_string(sb, return_value)
	}
}

// dovegen_funcimpl_variant_constructor :: proc() {
// }
// dovegen_funcimpl_variant_to_type :: proc() {
// }
dovegen_funcimpl_variant_method :: proc() {
}
dovegen_funcimpl_variant_utility_function :: proc() {
}
dovegen_funcimpl_instance_constructor :: proc(sb: ^strings.Builder, class_name: string) {
	using strings
	write_string(sb, "\n")
	write_string(sb, fmt.tprintf(`
create_%s :: proc() -> %s {{// dove object constructor
	@static class_name : StringName
	@static initialized : bool
	if initialized {{
		gde.string_name_new_with_utf8_chars(&class_name, "%s")
		initialized = true
	}}
	o := gde.classdb_construct_object(cast(gde.GDExtensionConstStringNamePtr)&class_name)
	return {{ _obj = o, _table = &__%s_table }}
}}
`, class_name, class_name, class_name, class_name))
	write_string(sb, fmt.tprintf(`
as_%s :: proc(obj: Object) -> %s {{// dove object converter
	return {{ _obj = obj._obj, _table = &__%s_table }}
}}
`, class_name, class_name, class_name))
}
dovegen_funcimpl_instance_method :: proc() {
}



generate_engine_classes_method :: proc(method: json.Object, class_name: string, fd: os.Handle, g: ^Globals, used_classes: ^[dynamic]string=nil) {
  os.write_string(fd, "{\n")
  os.write_string(fd, "// engine class method\n")

  method_name := fmt.tprintf("%s", method["name"])
  hash := fmt.tprintf("%.0f", method["hash"])
  is_static := "is_static" in method && method["is_static"].(json.Boolean)
  is_vararg := "is_vararg" in method && method["is_vararg"].(json.Boolean)

  if !is_static {
    os.write_string(fd, fmt.tprintf("  inst := cast(gde.GDExtensionObjectPtr)me._owner\n"))
  } else {
    os.write_string(fd, fmt.tprintf("  inst := cast(gde.GDExtensionObjectPtr)nil\n"))    
  }
  
  os.write_string(fd, fmt.tprintf("  @static class_name : godot.StringName\n"))
  os.write_string(fd, fmt.tprintf("  @static method_name : godot.StringName\n"))
  os.write_string(fd, fmt.tprintf("  @static method : gde.GDExtensionMethodBindPtr\n"))
  os.write_string(fd, fmt.tprintf("  if method == nil {{\n"))
  // os.write_string(fd, fmt.tprintf("    class_name = new(godot.StringName); gstring._to_string_name(class_name, \"%s\")\n", class_name))
  // os.write_string(fd, fmt.tprintf("    method_name = new(godot.StringName); gstring._to_string_name(method_name, \"%s\")\n", method_name))
  os.write_string(fd, fmt.tprintf("    gde.string_name_new_with_utf8_chars(&class_name, \"%s\")\n", class_name))
  os.write_string(fd, fmt.tprintf("    gde.string_name_new_with_utf8_chars(&method_name, \"%s\")\n", method_name))
  os.write_string(fd, fmt.tprintf("    method = gde.classdb_get_method_bind(cast(gde.GDExtensionConstStringNamePtr)&class_name, cast(gde.GDExtensionConstStringNamePtr)&method_name, %s)\n", hash))
  os.write_string(fd, fmt.tprintf("  }}\n"))
  
  arguments : [dynamic]string; defer delete(arguments)
  if "arguments" in method {
    for argument, i in method["arguments"].(json.Array) {

      name := fmt.tprintf("%s", argument.(json.Object)["name"])
      type := fmt.tprintf("%s", argument.(json.Object)["type"])
      meta := fmt.tprintf("%s", argument.(json.Object)["meta"])
      parameter := type_for_parameter(type, "meta" in argument.(json.Object) ? meta : "", g)

      with_owner := ""
      if is_engine_class(type, g) {
        with_owner = "._owner"
      }
      
      tmp : string
      if type == "bool" {
        tmp = fmt.tprintf("bval%d := %s?gde.TRUE:gde.FALSE; call_args[%d] = cast(gde.GDExtensionConstTypePtr)&bval%d", i, escape_identifier(name), i, i)
      // } else if strings.has_prefix(parameter, "^") {
      //   tmp = fmt.tprintf("val%d := %s%s; call_args[%d] = cast(gde.GDExtensionConstTypePtr)&val%d", i, escape_identifier(name), with_owner, i, i)
      } else {
        // tmp = fmt.tprintf("val%d := %s%s; call_args[%d] = cast(gde.GDExtensionConstTypePtr)%sval%d", i, escape_identifier(name), with_owner, i, with_owner==""?"&":"", i)
		tmp = fmt.tprintf("val%d := %s%s; call_args[%d] = cast(gde.GDExtensionConstTypePtr)&val%d", i, escape_identifier(name), with_owner, i, i)
	  }
      append(&arguments, strings.clone(tmp))
    }
  }

  return_type := get_return_type(method, g)
  rt := correct_type(return_type, "", g) // TODO return meta?
  has_return := return_type != ""
  
  if !is_vararg {
    l := len(arguments) > 0 ? len(arguments) : 1
    os.write_string(fd, fmt.tprintf("  call_args : [%d]rawptr\n", l))
    for a in arguments {
      os.write_string(fd, fmt.tprintf("  %s\n", a))
    }
    
    if has_return {   // _ptrcall doesn't need arg_count, since it's not vararg
		if is_engine_class(rt, g) {
			if strings.has_prefix(rt, "[]") {// TODO: Array handling
				elem_type := strings.trim_left(rt, "[]")
				// fmt.printf("return type: {} -> {}\n", rt, return_type)
				os.write_string(fd, fmt.tprintf("  retary: godot.Array\n"))
				os.write_string(fd, fmt.tprintf("  gde.object_method_bind_ptrcall(method, inst, raw_data(call_args[:]), &retary)\n"))
				os.write_string(fd, fmt.tprintf("  count := array.size(&retary)\n"))
				os.write_string(fd, fmt.tprintf("  retslice := make([]%s, count, context.temp_allocator)\n", elem_type))
				os.write_string(fd, fmt.tprintf("  for i in 0..<count {{\n"))
				os.write_string(fd, fmt.tprintf("    obj := variant.to_Object(array.get_idx(&retary, i))\n"))
				os.write_string(fd, fmt.tprintf("    retslice[i] = godot.as_%s(obj)\n", strings.trim_left(elem_type, "godot.")))
				os.write_string(fd, fmt.tprintf("  }}\n"))
				os.write_string(fd, fmt.tprintf("  return retslice\n"))
				if used_classes != nil {
					append(used_classes, "Array", strings.trim_left(elem_type, "godot."))
				}
			} else {
				os.write_string(fd, fmt.tprintf("  ret : %s\n", rt))
				os.write_string(fd, fmt.tprintf("  gde.object_method_bind_ptrcall(method, inst, raw_data(call_args[:]), &ret)\n"))
				os.write_string(fd, fmt.tprintf("  return godot.as_%s(transmute(godot.Object)ret)\n", strings.trim_left(rt, "godot.")))
			}
		} else {
			os.write_string(fd, fmt.tprintf("  ret : %s\n", rt))
			os.write_string(fd, fmt.tprintf("  gde.object_method_bind_ptrcall(method, inst, raw_data(call_args[:]), &ret)\n"))
			os.write_string(fd, fmt.tprintf("  return ret\n"))
		}
    } else {
      os.write_string(fd, fmt.tprintf("  gde.object_method_bind_ptrcall(method, inst, raw_data(call_args[:]), nil)\n"))
    }
  } else { // is_varg
    
    if has_return {
      if is_engine_class(return_type, g) {
        os.write_string(fd, fmt.tprintf("  ret := new(%s)\n", rt))
        os.write_string(fd, fmt.tprintf("  ret_error : gde.GDExtensionCallError\n"))
        os.write_string(fd, fmt.tprintf("  gde.object_method_bind_call(method, inst, cast(^gde.GDExtensionConstVariantPtr)args, cast(gde.GDExtensionInt)arg_count, cast(gde.GDExtensionVariantPtr)ret, &ret_error)\n"))
        os.write_string(fd, fmt.tprintf("  return ret\n"))
      } else {
        os.write_string(fd, fmt.tprintf("  ret : %s\n", rt))
        os.write_string(fd, fmt.tprintf("  ret_error : gde.GDExtensionCallError\n"))
        os.write_string(fd, fmt.tprintf("  gde.object_method_bind_call(method, inst, cast(^gde.GDExtensionConstVariantPtr)args, cast(gde.GDExtensionInt)arg_count, cast(gde.GDExtensionVariantPtr)&ret, &ret_error)\n"))
        os.write_string(fd, fmt.tprintf("  return ret\n"))
      }
    } else {
      os.write_string(fd, fmt.tprintf("  ret_error : gde.GDExtensionCallError\n"))
      os.write_string(fd, fmt.tprintf("  gde.object_method_bind_call(method, inst, cast(^gde.GDExtensionConstVariantPtr)args, cast(gde.GDExtensionInt)arg_count, nil, &ret_error)\n"))
    }

    os.write_string(fd, "}\n")
    // now write with ..any
    if has_return {
      os.write_string(fd, fmt.tprintf("%s :: proc(me: ^%s, args: ..any) -> %s {{\n", method_name, correct_type(class_name, "", g), correct_type(return_type, "", g)))
    } else {
      os.write_string(fd, fmt.tprintf("%s :: proc(me: ^%s, args: ..any) {{\n", method_name, correct_type(class_name, "", g)))
    }
      os.write_string(fd, fmt.tprintf("  gargs := make([]godot.Variant, len(args)); defer delete(gargs)\n"))
      os.write_string(fd, fmt.tprintf("  pargs := make([]^godot.Variant, len(args)); defer delete(pargs)\n"))
      os.write_string(fd, fmt.tprintf("  for &a, idx in args {{\n"))
      os.write_string(fd, fmt.tprintf("    gargs[idx] = variant.convert_any(a)\n"))
      os.write_string(fd, fmt.tprintf("    pargs[idx] = &gargs[idx]\n"))
      os.write_string(fd, fmt.tprintf("  }}\n"))
      os.write_string(fd, "  defer for &a in gargs do variant.destroy(&a)\n")
    if has_return {
      os.write_string(fd, fmt.tprintf("  return %s(me, &pargs[0], len(pargs))\n", fmt.tprintf("%s_internal", method_name)))
    } else {
      os.write_string(fd, fmt.tprintf("  %s(me, &pargs[0], len(pargs))\n", fmt.tprintf("%s_internal", method_name)))
    }
    
  }
  os.write_string(fd, "}\n")
}

generate_engine_classes_bindings :: proc(root: json.Object, target_dir: string, use_template_get_node: bool, g: ^Globals) {
	fmt.printf("Generate engine classes\n")
	
	// if true do continue

    // used_classes : [dynamic]string
    // fully_used_classes : [dynamic]string
    // defer delete(used_classes)
    // defer delete(fully_used_classes)
    // 
    // if "methods" in class_api.(json.Object) {
    //   for method in class_api.(json.Object)["methods"].(json.Array) {
    //     if "arguments" in method.(json.Object) {
    //       for argument in method.(json.Object)["arguments"].(json.Array) {
    //         type_name := fmt.tprintf("%s", argument.(json.Object)["type"])
    //         if strings.has_prefix(type_name, "const ") {
    //           type_name = type_name[6:]
    //         }
    //         if strings.has_suffix(type_name, "*") {
    //           type_name = type_name[:len(type_name)-1]
    //         }

    //         if is_included(type_name, class_name, g) {
    //           if strings.has_prefix(type_name, "typedarray::") {
    //             append(&fully_used_classes, "TypedArray")
    //             array_type_name, _ := strings.replace_all(type_name, "typedarray::", "")
    //             if strings.has_prefix(array_type_name, "const ") {
    //               array_type_name = array_type_name[6:]
    //             }
    //             if strings.has_suffix(array_type_name, "*") {
    //               array_type_name = array_type_name[:len(array_type_name)-1]
    //             }

    //             if is_included(array_type_name, class_name, g) {
    //               if is_enum(array_type_name) {
    //                 append(&fully_used_classes, get_enum_class(array_type_name))
    //               } else if "default_value" in argument.(json.Object) {
    //                 append(&fully_used_classes, array_type_name)
    //               } else {
    //                 append(&used_classes, array_type_name)
    //               }
    //             }
    //           } else if is_enum(type_name) {
    //             append(&fully_used_classes, get_enum_class(type_name))
    //           } else if "default_value" in argument.(json.Object) {
    //             append(&fully_used_classes, type_name)                
    //           } else {
    //             append(&used_classes, type_name)
    //           }
    //           //if is_refcounted(type_name, g) {
    //           //  append(&fully_used_classes, "Ref")
    //           //}  // TODO
    //         }
    //       }
    //     }
    //     
    //     // for method
    //     if "return_value" in method.(json.Object) {
    //       type_name := fmt.tprintf("%s", method.(json.Object)["return_value"].(json.Object)["type"])
    //       if strings.has_prefix(type_name, "const ") {
    //         type_name = type_name[6:]
    //       }
    //       if strings.has_suffix(type_name, "*") {
    //         type_name = type_name[:len(type_name)-1]
    //       }
    //       if is_included(type_name, class_name, g) {
    //         if strings.has_prefix(type_name, "typedarray::") {
    //           append(&fully_used_classes, "TypedArray")
    //           array_type_name, _ := strings.replace_all(type_name, "typedarray::", "")
    //           if strings.has_prefix(array_type_name, "const ") {
    //             array_type_name = array_type_name[6:]
    //           }
    //           if strings.has_suffix(array_type_name, "*") {
    //             array_type_name = array_type_name[:len(array_type_name)-1]
    //           }
    //           if is_included(array_type_name, class_name, g) {
    //             if is_enum(array_type_name) {
    //               append(&fully_used_classes, get_enum_class(array_type_name))
    //             } else if is_variant(array_type_name, g) {
    //               append(&fully_used_classes, array_type_name)
    //             } else {
    //               append(&used_classes, array_type_name)
    //             }
    //           }
    //         } else if is_enum(type_name) {
    //           append(&fully_used_classes, get_enum_class(type_name))
    //         } else if is_variant(type_name, g) {
    //           append(&fully_used_classes, type_name)
    //         } else {
    //           append(&used_classes, type_name)
    //         }
    //         //if is_refcounted(type_name, g) {
    //         //  append(&fully_used_classes, "Ref")
    //         //}  // TODO
    //       }
    //     }

    //     if "members" in class_api.(json.Object) {
    //       for member in class_api.(json.Object)["members"].(json.Array) {
    //         type := fmt.tprintf("%s", member.(json.Object)["type"])
    //         if is_included(type, class_name, g) {
    //           if is_enum(type) {
    //             append(&fully_used_classes, get_enum_class(type))
    //           } else {
    //             append(&used_classes, type)
    //           }
    //           //if is_refcounted(type, g) {
    //           //  append(&fully_used_classes, "Ref")
    //           //}  // TODO
    //         }
    //       }
    //     }

    //     if "inherits" in class_api.(json.Object) {
    //       name := fmt.tprintf("%s", class_api.(json.Object)["name"])
    //       inherits := fmt.tprintf("%s", class_api.(json.Object)["inherits"])
    //       if is_included(inherits, class_name, g) {
    //         append(&fully_used_classes, inherits)
    //       }
    //       //if is_refcounted(name, g) {
    //       //  append(&fully_used_classes, "Ref")
    //       //}  // TODO
    //     } else {
    //       //append(&fully_used_classes, "Wrapped")
    //     }
    //     
    //   }
    // }

    // // adjustments
    // for type_name in fully_used_classes {
    //   for i in 0..<len(used_classes) {
    //     if type_name == used_classes[i] {
    //       unordered_remove(&used_classes, i)
    //     }
    //   }
    // }
    // 
    // slice.sort(used_classes[:])
    // slice.sort(fully_used_classes[:])
    // slim_used_classes : [dynamic]string
    // slim_fully_used_classes : [dynamic]string   
    // prev := ""
    // for i in 0..<len(used_classes) {
    //   if prev != used_classes[i] do append(&slim_used_classes, used_classes[i])
    //   prev = used_classes[i]
    // }
    // prev = ""
    // for i in 0..<len(fully_used_classes) {
    //   if prev != fully_used_classes[i] do append(&slim_fully_used_classes, fully_used_classes[i])
    //   prev = fully_used_classes[i]
    // }
    // 
    // //fmt.println(class_name, "is using", slim_used_classes)    
    // //fmt.println(class_name, "is fully using", slim_fully_used_classes)

    // generate_engine_classes(class_api.(json.Object), target_dir, &slim_used_classes, &slim_fully_used_classes, sfd, g)
	// }
}

get_gdextension_type :: proc(type_name: string) -> string {
  type_conversion_map : map[string]string
  type_conversion_map["bool"] = "i8"
  type_conversion_map["u8"] = "i64"
  type_conversion_map["i8"] = "i64"
  type_conversion_map["u16"] = "i64"
  type_conversion_map["i16"] = "i64"
  type_conversion_map["u32"] = "i64"
  type_conversion_map["i32"] = "i64"
  type_conversion_map["int"] = "i64"
  type_conversion_map["f32"] = "f64"

  if strings.has_prefix(type_name, "BitField<") do return "i64"

  if type_name in type_conversion_map {
    return type_conversion_map[type_name]
  }
  return type_name
}

// get_encoded_arg :: proc(arg_name: string, type_name: string, type_meta: string, g: ^Globals) -> (result: string, name: string) {
//   name = escape_identifier(arg_name)
//   arg_type := correct_type(type_name, "", g)
//   if is_pod_type(arg_type) {
//     result = fmt.tprintf("%s_encoded := cast(%s)%s", name, get_gdextension_type(arg_type), name)
//     name = fmt.tprintf("&%s_encoded", name)
//   } else if is_engine_class(type_name, g) {
//     name = fmt.tprintf("((%s != nil) ? %s : nil)", name, name)
//   } else {
//     name = fmt.tprintf("%s", name)
//   }
//   return
// }

generate_utility_functions :: proc(root: json.Object, target_dir: string, g: ^Globals) {
  target_dir2 := filepath.join([]string{ target_dir, "utility_functions" })
  file := filepath.join([]string{target_dir2, "utility_functions.odin"})
  mode: int = 0
  when os.OS == .Linux || os.OS == .Darwin {
    mode = os.S_IRUSR | os.S_IWUSR | os.S_IRGRP | os.S_IROTH
  }

  os.make_directory(target_dir)
  os.make_directory(target_dir2)
  
  os.remove(file)
  fd, err := os.open(file, os.O_WRONLY|os.O_CREATE, mode)
  defer os.close(fd)
  if err != os.ERROR_NONE {
    fmt.println("ERROR: unable to open utility_functions.odin")
    return
  }
  os.write_string(fd, "package utility_functions\n\n")
  os.write_string(fd, "import gde \"../../gdextension\"\n")
  os.write_string(fd, "import godot \"../\"\n")
  os.write_string(fd, "import \"../string_name\"\n")
  os.write_string(fd, "import \"../variant\"\n") 
  
  g.pck = "godot."

  for function in root["utility_functions"].(json.Array) {
    //fmt.println(function)
    func_name := function.(json.Object)["name"]
    hash := fmt.tprintf("%.0f", function.(json.Object)["hash"])
    
    vararg := "is_vararg" in function.(json.Object) && function.(json.Object)["is_vararg"].(json.Boolean)

    function_signature := make_signature("UtilityFunctions", function.(json.Object), g)
    os.write_string(fd, fmt.tprintf("%s {{\n", function_signature))
    // function body
    os.write_string(fd, "	using godot\n")
    os.write_string(fd, fmt.tprintf("\t@static __function_name : godot.StringName\n"))
    os.write_string(fd, fmt.tprintf("\t@static __function : gde.GDExtensionPtrUtilityFunction\n"))   
    os.write_string(fd, fmt.tprintf("\tif __function == nil {{\n"))
    os.write_string(fd, fmt.tprintf("\t\t__function_name = string_name.constructor(\"%s\")\n", func_name))
    os.write_string(fd, fmt.tprintf("\t\t__function = gde.variant_get_ptr_utility_function(cast(gde.GDExtensionConstStringNamePtr)&__function_name, %s)\n", hash))
    os.write_string(fd, fmt.tprintf("\t}}\n"))

    return_type := ""
    has_return := "return_type" in function.(json.Object)
    if has_return {
      return_type = fmt.tprintf("%s", function.(json.Object)["return_type"])
      has_return = (return_type != "void")
    }
    
	Arg :: struct { name, type : string }

    arguments : [dynamic]Arg
    if "arguments" in function.(json.Object) {
      for argument in function.(json.Object)["arguments"].(json.Array) {
        meta := ""
        if "meta" in argument.(json.Object) do meta = fmt.tprintf("%s", argument.(json.Object)["meta"])
        // encode, arg_name := get_encoded_arg(
        //   fmt.tprintf("%s", argument.(json.Object)["name"]),
        //   fmt.tprintf("%s", argument.(json.Object)["type"]),
        //   meta, g)
        // os.write_string(fd, fmt.tprintf("  %s\n", encode))
        // append(&arguments, arg_name)
        append(&arguments, Arg{
			name = fmt.tprintf("%s", argument.(json.Object)["name"]),
			type = fmt.tprintf("%s", correct_type(argument.(json.Object)["type"].(json.String), "", g)),
		})
      }
    }
        
    if !vararg {
      // os.write_string(fd, fmt.tprintf("  args := make([]gde.GDExtensionConstTypePtr, %d)\n", len(arguments)))
      os.write_string(fd, fmt.tprintf("  args : [%d]gde.GDExtensionConstTypePtr\n", len(arguments)))
      for a, idx in arguments {
        os.write_string(fd, fmt.tprintf(" val%d := cast(%s)%s; args[%d] = cast(gde.GDExtensionConstTypePtr)&val%d\n", idx, get_gdextension_type(a.type), a.name, idx, idx))
      }

      if has_return {
        if return_type == "Object" {
          //fmt.printf("%s - %s\n", return_type, function_signature) TODO instance_from_id()
          os.write_string(fd, "  ret : godot.Object\n")
          os.write_string(fd, "  __function(cast(gde.GDExtensionTypePtr)&ret, raw_data(args[:]), len(args))\n")
          //os.write_string(fd, "  return gde.object_get_instance_binding(ret, token, Object::__bindingcallbacks)\n") TODO
          os.write_string(fd, "  return ret\n")
        } else {
          os.write_string(fd, fmt.tprintf("  ret : %s\n", get_gdextension_type(correct_type(return_type, "", g))))
          os.write_string(fd, "  __function(cast(gde.GDExtensionTypePtr)&ret, raw_data(args[:]), len(args))\n")
          os.write_string(fd, fmt.tprintf("  return cast(%s)ret\n", correct_type(return_type, "", g)))
        }
      } else {
        os.write_string(fd, "  __function(nil, raw_data(args[:]), len(args))\n")
      }
      
    } else { // is_vararg
      os.write_string(fd, fmt.tprintf("  ret := new(godot.Variant)\n"))
      os.write_string(fd, "  __function(cast(gde.GDExtensionTypePtr)ret, cast(^gde.GDExtensionConstTypePtr)args, arg_count)\n")
      if has_return {
        os.write_string(fd, fmt.tprintf("  return (cast(^%s)ret)^\n", correct_type(return_type, "", g)))
      } else {
        os.write_string(fd, "  free(ret)\n")
      }
      os.write_string(fd, "}\n")
      // now write with ..any
      if has_return {
        os.write_string(fd, fmt.tprintf("%s :: proc(args: ..any) -> %s {{\n", func_name, correct_type(return_type, "", g)))
      } else {
        os.write_string(fd, fmt.tprintf("%s :: proc(args: ..any) {{\n", func_name))
      }
      os.write_string(fd, fmt.tprintf("  gargs := make([]godot.Variant, len(args)); defer delete(gargs)\n"))
      os.write_string(fd, fmt.tprintf("  pargs := make([]^godot.Variant, len(args)); defer delete(pargs)\n"))
      os.write_string(fd, fmt.tprintf("  for &a, idx in args {{\n"))
      os.write_string(fd, fmt.tprintf("    gargs[idx] = variant.convert_any(a)\n"))
      os.write_string(fd, fmt.tprintf("    pargs[idx] = &gargs[idx]\n"))
      os.write_string(fd, fmt.tprintf("  }}\n"))
      os.write_string(fd, "  defer for &a in gargs do variant.destroy(&a)\n")
      
      if has_return {
        os.write_string(fd, fmt.tprintf("  return %s(&pargs[0], len(pargs))\n", fmt.tprintf("%s_internal", func_name)))
      } else {
        os.write_string(fd, fmt.tprintf("  %s(&pargs[0], len(pargs))\n", fmt.tprintf("%s_internal", func_name)))
      }
    }
    
    os.write_string(fd, fmt.tprintf("}}\n"))
  } 
}

generate_native_structures :: proc(root: json.Object, target_dir: string, g: ^Globals) {
  file := filepath.join([]string{target_dir, "native_structures.odin"})
  mode: int = 0
  when os.OS == .Linux || os.OS == .Darwin {
    mode = os.S_IRUSR | os.S_IWUSR | os.S_IRGRP | os.S_IROTH
  }

  os.remove(file)
  sfd, err := os.open(file, os.O_WRONLY|os.O_CREATE, mode)
  defer os.close(sfd)
  if err != os.ERROR_NONE {
    fmt.println("ERROR: unable to open native_structures.odin")
    return
  }
  os.write_string(sfd, "package godot\n\n")
  os.write_string(sfd, "import gde \"../gdextension\"\n\n")

  out_format :: proc(sfd: os.Handle, format_str: string, g: ^Globals) {
    // take somethins like: "float left;float right"
    // and output left: f32,\nright: f32
    ss := strings.split(format_str, ";")
    for s in ss {
      name_and_type := strings.split(s, " ")
      name := name_and_type[1]
      is_ptr := false
      if strings.has_prefix(name, "*") {
        is_ptr = true
        name = name[1:] // remove the "*"
      }
      is_arr := false
      arr_size := ""
      if strings.has_suffix(name, "]") {
        is_arr = true
        end := strings.index(name, "[") + 1
        arr_size = name[end:len(name)-1]
        name = name[:len(name)-2-len(arr_size)]
      }
      
      type := correct_type(name_and_type[0], "", g)
      type, _ = strings.replace_all(type, "::", "_")
      if is_ptr {
        type = fmt.tprintf("^%s", type)
      }
      if is_arr {
        type = fmt.tprintf("[%s]%s", arr_size, type)
      }
      os.write_string(sfd, fmt.tprintf("  %s : %s,\n", name, type))
    }
  }
  g.pck = ""
  for native_structs in root["native_structures"].(json.Array) {
    name := fmt.tprintf("%s", native_structs.(json.Object)["name"])
    os.write_string(sfd, fmt.tprintf("%s :: struct {{\n", name))
    format := fmt.tprintf("%s", native_structs.(json.Object)["format"])
    out_format(sfd, format, g)
    os.write_string(sfd, "}\n")
  }
}

generate_bindings :: proc(root: json.Object, use_template_get_node: bool, target_dir: string, bits:string="64", precision:string="single") {
	os.remove_directory(target_dir)
	os.make_directory(target_dir)

	real_t := (precision == "double") ? "double" : "float" // TODO expose this to main() and add usage() user report
	fmt.println("Built-in type config:", real_t, bits)

	globals : Globals
	globals.pck = ""

	for class_api in root["classes"].(json.Array) {
		name := fmt.tprintf("%s", class_api.(json.Object)["name"])
		ref_counted := cast(bool)class_api.(json.Object)["is_refcounted"].(json.Boolean)
		globals.engine_classes[strings.clone(name)] = ref_counted
	}
	for native_struct in root["native_structures"].(json.Array) {
		//fmt.println(native_struct)
		name := fmt.tprintf("%s", native_struct.(json.Object)["name"])
		append(&globals.native_structures, strings.clone(name))
	}
	for singleton in root["singletons"].(json.Array) {
		name := fmt.tprintf("%s", singleton.(json.Object)["name"])    
		append(&globals.singletons, strings.clone(name))
	}

	// generate_global_constants(root, target_dir, &globals)
	// generate_builtin_bindings(root, target_dir, fmt.tprintf("%s_%s", real_t, bits), &globals)
	// generate_engine_classes_bindings(root, target_dir, use_template_get_node, &globals)
	// generate_utility_functions(root, target_dir, &globals)
	// generate_native_structures(root, target_dir, &globals)
}

main :: proc() {
	// Load in json file!
	data, ok := os.read_entire_file_from_filename("./extension_api.json")
	if !ok {
		fmt.eprintln("Failed to load extension_api.json!")
		return
	}
	defer delete(data)
	
	// Parse the json file.
	json_data, err := json.parse(data)
	if err != .None {
		fmt.eprintln("Failed to parse the json file.")
		fmt.eprintln("Error:", err)
		return
	}
	defer json.destroy_value(json_data)

	// Access the Root Level Object
	root := json_data.(json.Object)

	// Do generator stuff
	header := root["header"].(json.Object)
	fmt.println("Version", header["version_full_name"])

	dovegen(root, "../godot")
	// generate_bindings(root, true, "../godot")
}

// ** godin
