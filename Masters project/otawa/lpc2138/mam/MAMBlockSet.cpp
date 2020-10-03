#include "MAMBlockSet.h"

namespace otawa {

//int LBlockSet::counter = 0;

/**
 * This property is used for storing the list of memory lines. The type of its
 * date is MAMBlockSet *[] with a size equal to the number of lines in the memory lines set.
 * 
 * @par Hooks
 * @li @ref FrameWork
 */
Identifier<MAMBlockSet *> MAMBLOCKS("otawa::mblocks", 0);

/**
 * This property is used for storing the list of memory lines of a BasicBlock.
 *
 * @par Hooks
 * @li @ref BasicBlock
 */
Identifier<genstruct::AllocatedTable<MAMBlock* >* > BB_MAMBLOCKS("otawa::bb_mblocks", 0);


/**
 */
int MAMBlockSet::add(MAMBlock *node){
	int id = listemls.length();
	listemls.add(node);
	return id;
}

/**
 */
int MAMBlockSet::count(void){
	return listemls.length();
}

int MAMBlockSet::newMamBlockID(void) {
	_mamBlockIDs++;
	return(_mamBlockIDs-1);
}


int MAMBlockSet::mamBlockIDCount(void) {
	return(_mamBlockIDs);
}


/**
 */
MAMBlock *MAMBlockSet::mblock(int i) {
		return listemls[i];
}

} // otawa
