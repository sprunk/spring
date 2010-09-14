/* This file is part of the Spring engine (GPL v2 or later), see LICENSE.html */

#ifndef PATH_CONSTANTS_HDR
#define PATH_CONSTANTS_HDR

#include <limits>
#include "Sim/Misc/GlobalConstants.h"

static const float PATHCOST_INFINITY = std::numeric_limits<float>::infinity();
// minimum distance between two waypoints
static const unsigned int PATH_RESOLUTION = SQUARE_SIZE * 2;

// NOTE:
//     PF and PE both use a PathNodeBuffer of size MAX_SEARCHED_NODES,
//     thus MAX_SEARCHED_NODES_{PF, PE} MUST be <= MAX_SEARCHED_NODES
static const unsigned int MAX_SEARCHED_NODES = 10000U;
static const unsigned int MAX_SEARCHED_NODES_PF = MAX_SEARCHED_NODES;
static const unsigned int MAX_SEARCHED_NODES_PE = MAX_SEARCHED_NODES;

// PathManager distance thresholds (to use PF or PE)
const float ESTIMATE_DISTANCE     = 55;
const float MIN_ESTIMATE_DISTANCE = 40;
const float DETAILED_DISTANCE     = 25;
const float MIN_DETAILED_DISTANCE = 12;

const unsigned int PATHESTIMATOR_VERSION = 44;
const unsigned int SQUARES_TO_UPDATE = 600;
const unsigned int MAX_SEARCHED_NODES_ON_REFINE = 2000;

const unsigned int PATHDIR_LEFT       = 0; // +x
const unsigned int PATHDIR_LEFT_UP    = 1; // +x+z
const unsigned int PATHDIR_UP         = 2; // +z
const unsigned int PATHDIR_RIGHT_UP   = 3; // -x+z
const unsigned int PATHDIR_RIGHT      = 4; // -x
const unsigned int PATHDIR_RIGHT_DOWN = 5; // -x-z
const unsigned int PATHDIR_DOWN       = 6; // -z
const unsigned int PATHDIR_LEFT_DOWN  = 7; // +x-z

const unsigned int PATHOPT_OPEN      =   8;
const unsigned int PATHOPT_CLOSED    =  16;
const unsigned int PATHOPT_FORBIDDEN =  32;
const unsigned int PATHOPT_BLOCKED   =  64;
const unsigned int PATHOPT_OBSOLETE  = 128;
const unsigned int PATHOPT_SEARCHRELATED = (PATHOPT_OPEN | PATHOPT_CLOSED | PATHOPT_FORBIDDEN | PATHOPT_BLOCKED);

#endif
