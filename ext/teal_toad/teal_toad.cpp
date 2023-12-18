#include <ruby.h>

/*
@example
  series = Series[1, 2, 3, 4, 2, 3]
  series.mean # => 15/6

@return [Float] The average value of the Series.
*/
VALUE mean(VALUE self){
  double sum = NUM2DBL(rb_funcall(self, rb_intern("sum"), 0));
  double length = NUM2DBL(rb_funcall(self, rb_intern("size"), 0));
  return rb_float_new(sum / length);
}

VALUE tealToadModule;

extern "C" void Init_teal_toad(void){
  tealToadModule = rb_define_module("TealToad");

  VALUE seriesClass = rb_define_class_under(tealToadModule, "Series", rb_cArray);
  rb_define_method(seriesClass, "mean", mean, 0);
}
