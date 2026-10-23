// Jenova Preprocessor Definitions
#define JENOVA_VERSION "0.3.9.0"
#define JENOVA_COMPILER "Microsoft Visual C++ Compiler"
#define MSVC_COMPILER
#define JENOVA_CUSTOM

#line 1

/* Jenova C++ Node Base Script (Meteora) */

// Godot SDK
#include <Godot/godot.hpp>
#include <Godot/classes/node.hpp>
#include <Godot/classes/character_body2d.hpp>
#include <Godot/variant/variant.hpp>

// Namespaces
using namespace godot;
using namespace jenova::sdk;

// Self Instance
CharacterBody2D* self = nullptr;

// Jenova Script Block Start
namespace JNV_3a98f89e474519b6c60b {

// Routines
void _enter_tree(Caller* instance)
{
	// Called When Node Enters Scene Tree
	self = GetSelf<CharacterBody2D>(instance);
}
void _exit_tree(Caller* instance)
{
	// Called When Node Exits Scene Tree
	self = nullptr;
}
void _ready(Caller* instance)
{
	// Called When Node and All It's Children Entered Scene Tree
}
void _process(Caller* instance, double _delta)
{
	// Called On Every Frame
}

// Jenova Script Block End
}; using namespace JNV_3a98f89e474519b6c60b;
