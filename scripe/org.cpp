
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
static CharacterBody2D* self = nullptr;

// Jenova Script Block Start
JENOVA_SCRIPT_BEGIN

// Routines
void OnAwake(Caller* instance)
{
	// Called When Node Enters Scene Tree
	self = GetSelf<CharacterBody2D>(instance);
}
void OnDestroy(Caller* instance)
{
	// Called When Node Exits Scene Tree
	self = nullptr;
}
void OnReady(Caller* instance)
{
	// Called When Node and All It's Children Entered Scene Tree
}
void OnProcess(Caller* instance, double _delta)
{
	// Called On Every Frame
}

// Jenova Script Block End
JENOVA_SCRIPT_END
