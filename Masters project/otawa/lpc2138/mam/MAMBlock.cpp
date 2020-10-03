
#include <assert.h>
#include "MAMBlock.h"
#include "MAMBlockSet.h"

#include <otawa/cfg/BasicBlock.h>

namespace otawa {

/**
 * This property is used for storing the list of memory lines of a BasicBlock.
 *
 * @par Hooks
 * @li @ref BasicBlock
 */
Identifier<MAMBlock *> INST_MAMBLOCK("otawa::inst_mamblock", 0);


/**
 * Build a new MAMBlock.
 * @param mlset		memory line set which owns this memory line.
 * @param address	Address of the memory line.
 * @param bb		Basic block containing this memory line.
 */
MAMBlock::MAMBlock(MAMBlockSet *mlset, address_t head, size_t size, int mbid): _size(size), addr(head), _mamBlockID(mbid), next(-1) {
	ident = mlset->MAMBlockSet::add(this);
}


/**
 * @fn size_t MAMBlock::size(void) const;
 * Get the size of the current memory line.
 * @return	memory line size.
 */


/**
 * Count the instructions in the memory line.
 * @return	memory line instruction count.
 */
int MAMBlock::countInsts(void) {
	int cnt = 0;
	
	if(_bb != 0){
		for(BasicBlock::InstIter instr(_bb); instr; instr++) {
			if(instr->address() >= addr && instr->address() < addr + _size)
				cnt++;
		}	
	}
	
	return cnt;	
}


/**
 */
int MAMBlock::id(void){
	return ident;
}


/**
 * @fn int MAMBlock::memblock(void)
 * Get identifier of the MAMBlock.
 * @return	MAMBlock identifier. 
 */
int MAMBlock::mamBlockID(void) {
        return _mamBlockID;
}


/**
 */
void MAMBlock::setBB(BasicBlock *bb) {
	_bb = bb;
}


/**
 * @fn address_t MAMBlock::address(void)
 * Get address of the memline.
 * @return	MAMBlock address.
 */


/** TODO : to check if this can be deleted safely
 * @fn BasicBlock *MAMBlock::bb(void);
 * Get the BB containing the memline.
 * @return	Container BB.
 */

} // otawa
