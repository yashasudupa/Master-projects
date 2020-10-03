
#ifndef OTAWA_UTIL_ABSMAMBUILDER_H
#define OTAWA_UTIL_ABSMAMBUILDER_H


#include <otawa/proc/BBProcessor.h>
#include <otawa/proc/Feature.h>
#include <elm/genstruct/Vector.h> 
#include <elm/genstruct/Table.h>

#include "MAMBlockSet.h"

namespace otawa {

class AbsMAMBlockBuilder: public BBProcessor {
	// friend class hard::Memory;
	MAMBlockSet *mblocks;
	HashTable<int,int> *MAMmap;
	// const hard::Memory *memory;
	
	void addMAMBlock(
		BasicBlock *bb,
		Inst *inst,
		int& index,
		genstruct::AllocatedTable<MAMBlock *> *mlines, MAMBlockSet *mbset);

protected:
	virtual void processBB(WorkSpace *fw, CFG *cfg, BasicBlock *bb);
	virtual void cleanup(WorkSpace *fw);
	virtual void setup(WorkSpace *fw);
	virtual void configure(const PropList &props); 

public:
	AbsMAMBlockBuilder(void);
	static Registration<AbsMAMBlockBuilder> reg;

	// TODO : a mettre dans fw()->platform()->memory()
	
	int mamblock_bits;

	// inlines 

	
	inline int blockBits(void) const {return mamblock_bits;}
	
	inline int blockSize(void) const {return (1 << blockBits());}


	inline ot::mask blockMask(void) const {return (blockSize() - 1);}
	
	inline ot::mask getBlock(address_t addr) const {
		return (ot::mask(addr.offset())) >> blockBits();
	}


};

// Features
extern Feature<AbsMAMBlockBuilder> COLLECTED_MAMBLOCKS_FEATURE;

// bits for a byte address in a memline
extern Identifier<int> MAMBLOCK_BITS;

} // otawa

#endif // OTAWA_UTIL_ABSMEMLINEBUILDER_H
