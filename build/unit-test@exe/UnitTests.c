/* UnitTests.c generated by valac 0.40.19, the Vala compiler
 * generated from UnitTests.vala, do not modify */



#include <glib.h>
#include <glib-object.h>
#include <float.h>
#include <math.h>
#include <gtk/gtk.h>
#include <stdlib.h>
#include <string.h>


#define TYPE_CAROLINE (caroline_get_type ())
#define CAROLINE(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TYPE_CAROLINE, Caroline))
#define CAROLINE_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), TYPE_CAROLINE, CarolineClass))
#define IS_CAROLINE(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TYPE_CAROLINE))
#define IS_CAROLINE_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), TYPE_CAROLINE))
#define CAROLINE_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), TYPE_CAROLINE, CarolineClass))

typedef struct _Caroline Caroline;
typedef struct _CarolineClass CarolineClass;
#define _g_object_unref0(var) ((var == NULL) ? NULL : (var = (g_object_unref (var), NULL)))
#define _vala_assert(expr, msg) if G_LIKELY (expr) ; else g_assertion_message_expr (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, msg);
#define _vala_return_if_fail(expr, msg) if G_LIKELY (expr) ; else { g_return_if_fail_warning (G_LOG_DOMAIN, G_STRFUNC, msg); return; }
#define _vala_return_val_if_fail(expr, msg, val) if G_LIKELY (expr) ; else { g_return_if_fail_warning (G_LOG_DOMAIN, G_STRFUNC, msg); return val; }
#define _vala_warn_if_fail(expr, msg) if G_LIKELY (expr) ; else g_warn_message (G_LOG_DOMAIN, __FILE__, __LINE__, G_STRFUNC, msg);



void lineTest (void);
static void __lambda4_ (void);
GType caroline_get_type (void) G_GNUC_CONST;
Caroline* caroline_new (gdouble* dataX,
                        int dataX_length1,
                        gdouble* dataY,
                        int dataY_length1,
                        const gchar* chartType,
                        gboolean generateColors,
                        gboolean scatterPlotLabels);
Caroline* caroline_construct (GType object_type,
                              gdouble* dataX,
                              int dataX_length1,
                              gdouble* dataY,
                              int dataY_length1,
                              const gchar* chartType,
                              gboolean generateColors,
                              gboolean scatterPlotLabels);
static void ___lambda4__gtest_func (void);
void _vala_main (gchar** args,
                 int args_length1);
static gboolean __lambda5_ (void);
static gboolean ___lambda5__gsource_func (gpointer self);


static void
__lambda4_ (void)
{
	gint benchNumber = 0;
	gdouble* x = NULL;
	gint _tmp0_;
	gdouble* _tmp1_;
	gint x_length1;
	gint _x_size_;
	gdouble* y = NULL;
	gint _tmp2_;
	gdouble* _tmp3_;
	gint y_length1;
	gint _y_size_;
	Caroline* carolineWidget = NULL;
	gdouble* _tmp12_;
	gint _tmp12__length1;
	gdouble* _tmp13_;
	gint _tmp13__length1;
	Caroline* _tmp14_;
#line 10 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	benchNumber = 10;
#line 11 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	_tmp0_ = benchNumber;
#line 11 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	_tmp1_ = g_new0 (gdouble, _tmp0_);
#line 11 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	x = _tmp1_;
#line 11 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	x_length1 = _tmp0_;
#line 11 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	_x_size_ = x_length1;
#line 12 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	_tmp2_ = benchNumber;
#line 12 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	_tmp3_ = g_new0 (gdouble, _tmp2_);
#line 12 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	y = _tmp3_;
#line 12 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	y_length1 = _tmp2_;
#line 12 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	_y_size_ = y_length1;
#line 100 "UnitTests.c"
	{
		gint i = 0;
#line 14 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
		i = 0;
#line 105 "UnitTests.c"
		{
			gboolean _tmp4_ = FALSE;
#line 14 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
			_tmp4_ = TRUE;
#line 14 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
			while (TRUE) {
#line 112 "UnitTests.c"
				gint _tmp6_;
				gint _tmp7_;
				gdouble* _tmp8_;
				gint _tmp8__length1;
				gint _tmp9_;
				gdouble* _tmp10_;
				gint _tmp10__length1;
				gint _tmp11_;
#line 14 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
				if (!_tmp4_) {
#line 123 "UnitTests.c"
					gint _tmp5_;
#line 14 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
					_tmp5_ = i;
#line 14 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
					i = _tmp5_ + 1;
#line 129 "UnitTests.c"
				}
#line 14 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
				_tmp4_ = FALSE;
#line 14 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
				_tmp6_ = i;
#line 14 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
				_tmp7_ = benchNumber;
#line 14 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
				if (!(_tmp6_ < _tmp7_)) {
#line 14 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
					break;
#line 141 "UnitTests.c"
				}
#line 16 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
				_tmp8_ = x;
#line 16 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
				_tmp8__length1 = x_length1;
#line 16 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
				_tmp9_ = i;
#line 16 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
				_tmp8_[_tmp9_] = g_random_double_range ((gdouble) 0, (gdouble) 10);
#line 17 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
				_tmp10_ = y;
#line 17 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
				_tmp10__length1 = y_length1;
#line 17 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
				_tmp11_ = i;
#line 17 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
				_tmp10_[_tmp11_] = g_random_double_range ((gdouble) 0, (gdouble) 10);
#line 159 "UnitTests.c"
			}
		}
	}
#line 22 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	_tmp12_ = x;
#line 22 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	_tmp12__length1 = x_length1;
#line 22 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	_tmp13_ = y;
#line 22 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	_tmp13__length1 = y_length1;
#line 22 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	_tmp14_ = caroline_new (_tmp12_, _tmp12__length1, _tmp13_, _tmp13__length1, "scatter", TRUE, TRUE);
#line 22 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	g_object_ref_sink (_tmp14_);
#line 22 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	carolineWidget = _tmp14_;
#line 24 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	_vala_assert (G_TYPE_CHECK_INSTANCE_TYPE (carolineWidget, gtk_widget_get_type ()), "carolineWidget is Gtk.Widget");
#line 8 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	_g_object_unref0 (carolineWidget);
#line 8 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	y = (g_free (y), NULL);
#line 8 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	x = (g_free (x), NULL);
#line 185 "UnitTests.c"
}


static void
___lambda4__gtest_func (void)
{
#line 8 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	__lambda4_ ();
#line 194 "UnitTests.c"
}


void
lineTest (void)
{
#line 8 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	g_test_add_func ("/vala/test", ___lambda4__gtest_func);
#line 203 "UnitTests.c"
}


static gboolean
__lambda5_ (void)
{
	gboolean result = FALSE;
#line 37 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	g_test_run ();
#line 38 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	gtk_main_quit ();
#line 39 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	result = FALSE;
#line 39 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	return result;
#line 219 "UnitTests.c"
}


static gboolean
___lambda5__gsource_func (gpointer self)
{
	gboolean result;
	result = __lambda5_ ();
#line 36 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	return result;
#line 230 "UnitTests.c"
}


void
_vala_main (gchar** args,
            int args_length1)
{
#line 31 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	gtk_init (&args_length1, &args);
#line 32 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	g_test_init (&args_length1, &args, NULL);
#line 34 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	lineTest ();
#line 36 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	g_idle_add_full (G_PRIORITY_DEFAULT_IDLE, ___lambda5__gsource_func, NULL, NULL);
#line 42 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	gtk_main ();
#line 248 "UnitTests.c"
}


int
main (int argc,
      char ** argv)
{
#line 29 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	_vala_main (argv, argc);
#line 29 "/mnt/6caf58d5-d873-41ac-930d-63ff042b1cad/Documents/Caroline/UnitTests.vala"
	return 0;
#line 260 "UnitTests.c"
}



