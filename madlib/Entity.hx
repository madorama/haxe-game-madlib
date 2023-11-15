package madlib;

#if heaps
typedef Entity = madlib.heaps.Entity;
#else
typedef Entity = Dynamic;
#end
