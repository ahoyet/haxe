/*
 * Copyright (C)2005-2015 Haxe Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */
import lua.Boot;
import lua.NativeStringTools;

@:keepInit
@:coreApi class Std {

	public static inline function is( v : Dynamic, t : Dynamic ) : Bool {
		return untyped lua.Boot.__instanceof(v,t);
	}

	public static inline function instance<T:{},S:T>( value : T, c : Class<S> ) : S {
		return untyped lua.Boot.__instanceof(value, c) ? cast value : null;
	}

	@:keep
	public static function string( s : Dynamic ) : String {
		return untyped lua.Boot.__string_rec(s);
	}

	public static inline function int( x : Float ) : Int {
		return x > 0 ? Math.floor(x) : Math.ceil(x);
	}

	public static function parseInt( x : String ) : Null<Int> {
		if (x == null) return null;
		var hexMatch = NativeStringTools.match(x, "^ *[%-+]*0[xX][%da-FA-F]*");
		if (hexMatch != null){
			return lua.Lua.tonumber(hexMatch.substr(2), 16);
		} else {
			var intMatch = NativeStringTools.match(x, "^ *[%-+]?%d*");
			if (intMatch != null){
				return lua.Lua.tonumber(intMatch);
			} else {
				return null;
			}
		}
	}

	public static function parseFloat( x : String ) : Float {
		if (x == null || x == "") return Math.NaN;
		var digitMatch = NativeStringTools.match(x,  "^ *[%.%-+]?[0-9]%d*");
		if (digitMatch == null){
			return Math.NaN;
		}
		x = x.substr(digitMatch.length);

		var decimalMatch = NativeStringTools.match(x, "^%.%d*");
		if (decimalMatch == null) decimalMatch = "";
		x = x.substr(decimalMatch.length);

		var eMatch = NativeStringTools.match(x, "^[eE][+%-]?%d+");
		if (eMatch == null) eMatch = "";
		var result =  lua.Lua.tonumber(digitMatch + decimalMatch + eMatch);
		return result != null ? result : Math.NaN;
	}

	public static function random( x : Int ) : Int {
		return untyped x <= 0 ? 0 : Math.floor(Math.random()*x);
	}

	static function __init__() : Void untyped {
		__feature__("lua.Boot.getClass", String.prototype.__class__ = __feature__("Type.resolveClass",_hxClasses["String"] = String,String));
		__feature__("lua.Boot.isClass", String.__name__ = __feature__("Type.getClassName", __lua_table__("String"),true));
		__feature__("Type.resolveClass",_hxClasses["Array"] = Array);
		__feature__("lua.Boot.isClass",Array.__name__ = __feature__("Type.getClassName",__lua_table__("Array"),true));
		__feature__("Int.*",{
			var Int = __feature__("Type.resolveClass", _hxClasses["Int"] = { __name__ : __lua_table__("Int") }, { __name__ : __lua_table__("Int") });
		});
		__feature__("Dynamic.*",{
			var Dynamic = __feature__("Type.resolveClass", _hxClasses["Dynamic"] = { __name__ : __lua_table__("Dynamic") }, { __name__ : __lua_table__("Dynamic") });
		});
		__feature__("Float.*",{
			var Float = __feature__("Type.resolveClass", _hxClasses["Float"]={}, {});
			Float.__name__ = __lua_table__("Float");
		});
		__feature__("Bool.*",{
			var Bool = __feature__("Type.resolveEnum",_hxClasses["Bool"] = {}, {});
			Bool.__ename__ = __lua_table__("Bool");
		});
		__feature__("Class.*",{
			var Class = __feature__("Type.resolveClass", _hxClasses["Class"] = { __name__ : __lua_table__("Class") }, { __name__ : __lua_table__("Class") });
		});
		__feature__("Enum.*",{
			var Enum = {};
		});
		__feature__("Void.*",{
			var Void = __feature__("Type.resolveEnum", _hxClasses["Void"] = { __ename__ : ["Void"] }, { __ename__ : ["Void"] });
		});

	}

}
