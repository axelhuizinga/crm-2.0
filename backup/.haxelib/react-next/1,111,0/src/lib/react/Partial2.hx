// package react;

// #if macro
// import haxe.macro.Context.*;
// import haxe.macro.Expr;
// import haxe.macro.Type;
// using tink.MacroApi;
// #end

// @:forward abstract Partial2<T:{}>(T) from T from Partial<T> to Partial<T> to {} {}

// @:forward
// abstract Partial2<T:{}>(T) to {} {
// 	@:from static macro function ofAny(e:Expr) {
// 		var expected = getExpectedType();

// 		var ret =
// 		 	switch followWithAbstracts(expected) {
// 				// case TDynamic(_): e;
// 				case TAnonymous(_.get().fields => fields):
// 					var t:ComplexType = TAnonymous([
// 						for (f in fields) {
// 							name: f.name,
// 							pos: e.pos,
// 							kind: FProp('default', 'never', removeNullT(f.type)),
// 							// kind: FProp('default', 'never', f.type.toComplex()),
// 							meta: [{ name: ':optional', params: [], pos: e.pos }]
// 						}
// 					]);//TODO: consider caching these

// 					e = switch (e.expr) {
// 						case EObjectDecl(dfields):
// 							{pos: e.pos, expr: EObjectDecl([
// 							for (df in dfields) {
// 								for (f in fields) {
// 									if (f.name == df.field) {
// 										var ft = removeNullT(f.type);

// 										df = {
// 											field: df.field,
// 											quotes: df.quotes,
// 											expr: macro @:pos(df.expr.pos) (${df.expr} :$ft)
// 										};

// 										break;
// 									}
// 								}

// 								df;
// 							}])}

// 						default:
// 							trace(e.expr);
// 							e;
// 					}


// 					macro @:pos(e.pos) ($e:$t);
// 				case v:
// 					fatalError('Cannot have partial $v', currentPos());
// 			}

// 		var et = expected.toComplex();
// 		return macro @:pos(e.pos) (cast $ret:$et);
// 	}

// 	#if macro
// 	public static function removeNullT(
// 		?ct:ComplexType,
// 		?t:Type
// 	):ComplexType {
// 		if (t == null && ct == null) return null;
// 		if (ct == null) return removeNullT(t.toComplex());

// 		return switch(ct) {
// 			case TPath({
// 				name: "StdTypes",
// 				sub: "Null",
// 				pack: [],
// 				params: [TPType(subT)]
// 			}): removeNullT(subT);

// 			default: ct;
// 		}
// 	}
// 	#end
// }

/*
	From a gist by George Corney:
	https://gist.github.com/haxiomic/ad4f5d329ac616543819395f42037aa1

	A Partial<T>, where T is a typedef, is T where all the fields are optional
*/
package react;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.TypeTools;

#if !macro
@:genericBuild(react.Partial2Macro.build())
#end
class Partial2<T:{}> {}

class Partial2Macro {
	#if macro
	static function build()
	{
		switch Context.getLocalType()
		{
			// Match when class's type parameter leads to an anonymous type (we convert to a complex type in the process to make it easier to work with)
			case TInst(_, [Context.followWithAbstracts(_) => TypeTools.toComplexType(_) => TAnonymous(fields)]):
				// Add @:optional meta to all fields
				var newFields = fields.map(addMeta);
				return TAnonymous(newFields);

			// default:
			case v:
				trace(v);
				Context.fatalError('Type parameter should be an anonymous structure', Context.currentPos());
		}

		return null;
	}

	static function addMeta(field: Field): Field
	{
		// Handle Null<T> and optional fields already parsed by the compiler
		var kind = switch (field.kind) {
			case FVar(TPath({
					name: 'StdTypes',
					sub: 'Null',
					params: [TPType(TPath(tpath))]
				}), write):
				FVar(TPath(tpath), write);

			default:
				field.kind;
		}

		return {
			name: field.name,
			kind: kind,
			access: field.access,
			meta: field.meta.concat([{
				name: ':optional',
				params: [],
				pos: Context.currentPos()
			}]),
			pos: field.pos
		};
	}
	#end
}
