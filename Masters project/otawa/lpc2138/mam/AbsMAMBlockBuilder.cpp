
#include <assert.h>
#include <otawa/proc/ProcessorException.h>
#include <otawa/hard/CacheConfiguration.h>
#include <otawa/hard/Platform.h>
#include <otawa/cfg.h>
#include <otawa/ilp.h>
#include <otawa/proc/ProcessorException.h>
#include <otawa/ipet/IPET.h>
#include <otawa/cfg/CFGCollector.h>
#include <elm/genstruct/Vector.h> 
#include <elm/genstruct/HashTable.h>
#include <elm/genstruct/Table.h>

#include "AbsMAMBlockBuilder.h"

namespace otawa {

/**
 * @class AbsMAMBlockBuilder
 * This processor builds the MAM for each lines of instruction
 * cache and stores it in the CFG.
 * 
 * @par Required Features
 * @li @ref INVOLVED_CFGS_FEATURE
 * 
 * @par Provided Features
 * @li @ref COLLECTED_MAMBLOCK_FEATURE
 */

Registration<AbsMAMBlockBuilder> AbsMAMBlockBuilder::reg(
	"otawa::lpc2138::AbsMAMBlockBuilder", Version(1, 1, 0),
	p::require, &COLLECTED_CFG_FEATURE,
	p::provide, &COLLECTED_MAMBLOCKS_FEATURE,
	p::end
);

/**
 * Build a new MemLine builder.
 */
AbsMAMBlockBuilder::AbsMAMBlockBuilder(void): BBProcessor(reg) {
}

/**
 */
void AbsMAMBlockBuilder::setup(WorkSpace *fw) {
	ASSERT(fw);
	// Build hash	
	MAMmap = new HashTable<int, int>();
	MAMBLOCKS(fw) = new MAMBlockSet();	
}

void AbsMAMBlockBuilder::configure(const PropList& props) {
  mamblock_bits = MAMBLOCK_BITS(props);
  BBProcessor::configure(props);
}

/**
 */
void AbsMAMBlockBuilder::cleanup(WorkSpace *fw) {
	ASSERT(fw);
	
	for (MAMBlockSet::Iterator mblock(**MAMBLOCKS(fw)); mblock; mblock++) {		
		for (MAMBlockSet::Iterator mblock2(**MAMBLOCKS(fw)); mblock2; mblock2++) {
			if (getBlock(mblock2->address()) == (getBlock(mblock->address()) + 1)) {
				mblock->next = mblock2->mamBlockID();
			} 			
		}		
	}
		
	// Remove hash
	delete MAMmap;
}


/**
 * Add a memline to the memline lists.
 * @param bb		Basic block containing the memline.
 * @param inst		First instruction of the memline.
 * @param index		Index in the BB memline table.
 * @paramlblocks	BB memline table.
 */
void AbsMAMBlockBuilder::addMAMBlock(
	BasicBlock *bb,
	Inst *inst,
	int& index,
	genstruct::AllocatedTable<MAMBlock*> *mblocks, MAMBlockSet *mbset
) {
	

	ASSERT(inst);
	// compute the cache block ID
	
	int block = getBlock(inst->address());		

	int mbid = MAMmap->get(block, -1);
	
	if(mbid == -1) {
		//	cerr << "\t\t\tnouvelle memline" << io::endl;
   	mbid = mbset->newMamBlockID();
		MAMmap->put(block, mbid);
    }
	
	// Compute the size
	Address top = (inst->address() + blockMask()) & ~blockMask();
	if(top > bb->address() + bb->size())
		top = bb->address() + bb->size();
	
	// Build the lblock
	MAMBlock *mamblock = new MAMBlock(
			mbset,
			inst->address(),
			top - inst->address(),
			mbid
		);
	mamblock->setBB(bb);

	// cerr << "\t\t\tligne de mem : " << mlid << io::endl;

	// Add 
	mblocks->set(index, mamblock); 											
	index++;
	INST_MAMBLOCK(inst) = mamblock;
}

/**
 */
void AbsMAMBlockBuilder::processBB(WorkSpace *fw, CFG *cfg, BasicBlock *bb) {
	ASSERT(fw);
	ASSERT(cfg);
	ASSERT(bb);
	
	// TODO : a mettre dans fw()->platform()->memory()

	
	// Do not process entry and exit
	if (bb->isEnd())
		return;
		
	// Allocate the BB lblock table
	int num_mamblocks =
		((bb->address() + bb->size() + blockMask()) >> blockBits())
		- (bb->address() >> blockBits());
	genstruct::AllocatedTable<MAMBlock*> *mblocks =
		new genstruct::AllocatedTable<MAMBlock*>(num_mamblocks);
	
	ASSERT(mblocks != NULL);
	BB_MAMBLOCKS(bb) = mblocks;
		
	// Traverse instruction
	int index = 0;
	int block = -1;
	for(BasicBlock::InstIterator inst(bb); inst; inst++) {

		// TODO: a mettre dans fw()->platform()->memory()
		int new_block = getBlock(inst->address());

		if(new_block != block) {
			addMAMBlock(bb, inst, index, mblocks, MAMBLOCKS(fw));
			block = new_block;
		}
		else
			// dans le cas ou il n'y a pas de nouvelle memline, on r�cup�re un pointeur vers la memline courante
			INST_MAMBLOCK(inst) = mblocks->get(index-1);
		
		//	cerr << "\t\t\tadresse inst : " << inst->address() << io::endl;
		
	}
	ASSERT(index == num_mamblocks);
}

/**
 * This feature ensures that the MemLines of the current task has been
 * collected.
 * 
 * @par Properties
 * @li @ref MEMLINES
 * @li @ref BB_MEMLINES
 * @li @ref INST_MEMLINE
 */

// MAMBLOCK_BITS = log2(mam buffer size in bytes)
Identifier<int> MAMBLOCK_BITS("otawa::mamblock_bits", 4);

Feature<AbsMAMBlockBuilder> COLLECTED_MAMBLOCKS_FEATURE("otawa::AbsMAMBlockBuilder");

} // otawa
