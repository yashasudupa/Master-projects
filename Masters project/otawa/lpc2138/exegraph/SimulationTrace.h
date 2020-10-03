#ifndef SIMULATION_TRACE_H
#define SIMULATION_TRACE_H

#include <elm/io/Output.h>
#include <elm/io.h>

namespace otawa { namespace gensim {

class Level;

extern const Level L1;
extern const Level L2;
extern const Level L3;
extern const Level L4;
extern const Level L5;
extern const Level L6;
extern const Level L7;
extern const Level L8;
extern const Level L9;


class Level {
 public:
  inline Level(int l)
    : _level(l) { }
  int _level;
};

 class NullStream: public elm::io::OutStream {
  virtual int write (const char *buffer, int size) { return 0; }
   int flush (void) { }
 }; 

extern NullStream null_stream;


class SimTrace : public elm::io::Output {
  int _level;
  elm::String _module_name;
  elm::io::OutStream& _stream;

 public:
  SimTrace (elm::io::OutStream& stream, int level, elm::String module_name)
    : _level(level), _stream(stream), _module_name(module_name) {
#ifdef SIMULATION_TRACE
    setStream(_stream);
#else
    setStream(null_stream);
#endif
}
  inline void checkLevel(int level) {
#ifdef SIMULATION_TRACE
    if (level <= _level)
      setStream(_stream);
    else
      setStream(null_stream);
#endif
  }
};

inline SimTrace& operator<<(SimTrace& trace, const Level& level) {
  trace.checkLevel(level._level);
  return trace;
}



}}

#endif //SIMULATION_TRACE_H
