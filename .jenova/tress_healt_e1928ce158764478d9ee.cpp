// Jenova Preprocessor Definitions
#define JENOVA_VERSION "0.3.9.9"
#define JENOVA_COMPILER "MinGW GCC Compiler"
#define MINGW_CLANG_COMPILER
#define JENOVA_CUSTOM

#line 1 "C:/Users/SHOFIY SALSABILA/OneDrive/Desktop/godot/Petapa agung/scripe/C++ Trees Limbo/tress_healt.cpp"
/* Jenova C++ Node Base Script (Meteora) */

// Godot SDK
#include <Godot/godot.hpp>
#include <Godot/classes/node.hpp>
#include <Godot/classes/node.hpp>
#include <Godot/variant/variant.hpp>

// Namespaces
using namespace godot;
using namespace jenova::sdk;

// Self Instance
static Node* self = nullptr;

// Jenova Script Block Start
namespace JNV_e1928ce158764478d9ee {

// Routines
void _enter_tree(Caller* instance) {
	// Called When Node Enters Scene Tree
	self = GetSelf<Node>(instance);
}
void _exit_tree(Caller* instance) {
	// Called When Node Exits Scene Tree
	self = nullptr;
}
void _ready(Caller* instance) {

	// Called When Node and All It's Children Entered Scene Tree
}
void _process(Caller* instance, double _delta) {
	// Called On Every Frame
}

// Jenova Script Block End
}; using namespace JNV_e1928ce158764478d9ee;
